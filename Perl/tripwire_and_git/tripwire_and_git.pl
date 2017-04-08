#!/usr/bin/perl
#
# fixed Envirov by uehata 2012.05.24
# fixed SunOS by uehata 2012.05.16
# fixed SunOS by uehata 2012.04.23
# fixed some bugs by uehata 2012.03.01
# fixed Debian by uehata 2011.11.15
# fixed check_git_lsfiles() by uehata 2011.08.17
# add_check_acl() by uehata 2011.08.13
#
use File::Basename;
use Sys::Syslog;
use IPC::Open3 qw(open3);
use Symbol;
use POSIX 'strftime';

use constant TRUE => 1;
use constant FALSE => 0;
use constant UNIX_TRUE => 0;

## VARIABLES
$PROGRAM_NAME = "TRIPWIRE_AND_GIT";

# SET ENVIROVMENT
$ENV{'PATH'}=$ENV{'PATH'}.":/usr/sbin:/usr/local/bin:/usr/local/sbin";

$CMD_SED = &get_cmdpath('sed');
$CMD_AWK = &get_cmdpath('awk');
$CMD_CAT = &get_cmdpath('cat');
$CMD_EGREP = &get_cmdpath('egrep');
$CMD_MKDIR = &get_cmdpath('mkdir');
$CMD_ECHO = &get_cmdpath('echo');
$CMD_RM = &get_cmdpath('rm');
$CMD_GIT = &get_cmdpath('git');
$CMD_GETFACL = &get_cmdpath('getfacl');
$CMD_TRIPWIRE = &get_cmdpath('tripwire');
$CMD_TWADMIN = &get_cmdpath('twadmin');

# Tripwire のチェックポリシーファイル
$FILE_TWPOL = "/etc/tripwire/twpol.txt";

# ACLファイルの保存先ディレクトリ
$PATH_DATA = "usr/local/tripwire_and_git/";
$PATH_CHECK_DEBIAN = "/etc/debian_version";
$PATH_CHECK_SUNOS = "/etc/vfstab";
$PATH_ACL = $PATH_DATA . "acl/";
$PATH_ACL_REGEX = $PATH_ACL;
$PATH_ACL_REGEX =~ s/\//\\\//g;

# tripwire --checkの開始文字
$TRIPWIRE_CHECK_START_REGEX = "Total violations found:";

#ACLファイル名
$FILENAME_ACL = ".acl";
$PASSWORD_TRIPWIRE = "ksi01ksi";

# デバックログの保存先
$LOG_FILE = "/usr/local/tripwire_and_git/log/tripwire.log";

# GLOBAL VARIABLS(グローバル変数)
# コミットフラグ
$GIT_COMMIT_FLAG = 0;
$HOSTNAME = `hostname`;
chomp $HOSTNAME;
@TWPOL_SETFILE_ARRAY;
@TWPOL_SETDIR_ARRAY;
@GIT_LSFILES_ARRAY; # git ls-filesの保存先
@GIT_LSFILES_ARRAY_WITHOUT_ACL;

## 処理開始
# デバックレベル 0:デバッグなし 1:デバッグ 2:デバッグ詳細(第１引数がデバックログのレベルになる。)
$DEBUG_LEVEL = 0;
# デバックモードON,OFFの確認
if ($DEBUG_LEVEL == 0) {
  if($ARGV[0] eq "1") {
    $DEBUG_LEVEL = 1;
  } elsif($ARGV[0] eq "2") {
    $DEBUG_LEVEL = 2;
  }
}

## OSチェック
if (-e $PATH_CHECK_DEBIAN) {
  $OS = "DEBIAN";
} elsif (-e $PATH_CHECK_SUNOS) {
  $OS = "SUNOS";
} else {
  $OS = "OTHER";
}

# 処理実行
&main();

## FUNCTIONS
# function main
#
sub main {
  my $ret = FALSE;
  my $function_name = "main";

  syslog("info", " [INFO]: START $PROGRAM_NAME");

  &open_log();
  &output_log(2, $function_name, "START");
  &output_log(2, $function_name, "OS=" . $OS);
  
  # カレントディレクトリを変更する
  chdir("/");
  
  # twpol.txtのデータをグローバル配列に設定する
  &set_array_twpol();
  &set_git_lsfiles_array();

  # gitに登録されているが、ファイルがない場合はgitから削除、aclファイルじゃない場合はaclも削除
  &check_exist_git_lsfiles();
  
  # gitにあってaclに無いものはgetfaclしてgit addする(手動でgit addしたものとか)
  &check_acl();
  
  #twpol.txtに記載されていないgit ls-filesのファイルはgitから削除する
  &check_compare_twpol_and_git_lsfiles();
  
  # twpolに記載されているものはgit addする
  &add_git_twpol();

  # tripwireの更新履歴チェック
  &check_tripwire();

  # GIT_COMMIT_FLAGがある時
  if ($GIT_COMMIT_FLAG == 1) {
    # git commit作業
    &commit_git();
  }
  &output_log(2, $function_name, "END");
  &close_log();
  &exit();
}
# end main

## FUNCTIONS
# function exit
#
sub exit {
  syslog("info", " [INFO]: END $PROGRAM_NAME");
  exit;
}
# end exit

#
# function get_cmdpath
#
# 引数:なし
#
# 日付の取得
# @return : 日付
sub get_cmdpath {
  my $name = shift;
  my $function_name = "get_cmdpath";
  my $ret = FALSE, $cmd='';
  
  $cmd = `which $name`;
  chomp $cmd;
  if ($cmd eq "") {
    syslog("info", " [ERROR]: 'GET_PATH $name'");
    &exit();
  }
  return $cmd;
}
# end get_cmdpath

#
# function get_date
#
# 引数:なし
#
# 日付の取得
# @return : 日付
sub get_date {
  my $date;
  my ($sec, $min ,$hour ,$mday ,$month ,$year ,$wday ,$stime) = localtime(time());
  return ($year+1900) . sprintf("%02d",$month+1) . sprintf("%02d", $mday) . "-" . sprintf("%02d", $hour) . sprintf("%02d", $min) . sprintf("%02d", $sec);
}
# end get_date

#
# function add_git_twpol
#
# twpol.txtをチェックして、gitに登録、削除されてない場合はgitに登録、削除を行う
# @return : 1(コミット要),  0(コミット不要)
sub add_git_twpol {
  my $function_name = "add_git_twpol";
  my $ret = FALSE;

  &output_log(0, $function_name, "START");

  # twpol.txtのSET_FILE設定をgit登録していく
  foreach (@TWPOL_SETFILE_ARRAY) {
    # 末尾の改行コード削除
    chomp $_;
    if (&add_file($_) != TRUE) {
       #error処理?
    }
  }

  # twpol.txtのSET_DIR設定をgit登録していく
  foreach (@TWPOL_SETDIR_ARRAY) {
    # 末尾の改行コード削除
    chomp $_;
    if (&add_dir($_) != TRUE) {
       #error処理?
    }
  }
  &output_log(0, $function_name, "END ret=$ret");
}
# end add_git_twpol

#
# function check_acl
#
# git ls-filesにあってaclファイルがない場合はaclを作成してgitに登録する (手動でgit addだけした場合など)
sub check_acl {
  my $ret = FALSE;
  my $function_name = "check_acl";
  my $cmd, $cmd_ret;

  if ( $OS eq "SUNOS") {
    $ret = TRUE;
    return $ret;
  }
  
  &output_log(1, $function_name, "START");
  
  # gitにファイルが1件でも登録されている場合はチェックする
  if (@GIT_LSFILES_ARRAY_WITHOUT_ACL != 0) {
    foreach (@GIT_LSFILES_ARRAY_WITHOUT_ACL) {
      chomp $_;
      ($path_type, $path_status) = &check_exist($PATH_ACL . $_);
      # aclファイルが存在しない場合
      if ($path_type eq 'not_found') {
        &output_log(1, $function_name, "NO_EXIST_ACL: path_type=$path_type, acl_file=" . $PATH_ACL .$_);
        &add_acl($_);
      # aclファイルが存在する
      } else {
        &output_log(1, $function_name, "EXIST_ACL: path_type=$path_type, path_status=$path_status" . $PATH_ACL . $_);
      }
    }
  }
  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end check_acl

#
# function check_exist_git_lsfiles
#
# git ls-filesをチェックして、ファイルが存在しない場合はgitから削除を行う
sub check_exist_git_lsfiles {
  my $function_name = "check_exist_git_lsfiles";
  my $ret = FALSE;
  my $cmd, $cmd_ret;
  
  &output_log(1, $function_name, "START");

  # git ls-filesのリスト分ループする
  foreach (@GIT_LSFILES_ARRAY) {
    chomp $_;
    &output_log(1, $function_name, "git_lsfile=$_");
    # pathが存在しない場合はgitから削除する
    ($path_type, $path_status) = &check_exist($_);
    if ($path_type eq "not_found") {
      # 該当ファイルがaclファイルのじゃない場合
      if (($_ =~ /^$PATH_ACL_REGEX/) != TRUE) {
        # gitから削除しaclも削除
        &remove_file_or_dir($_);
      # ACLの場合はgitからのみ削除
      } else {
        &remove_git($_);
      }
    }
  }
  &output_log(1, $function_name, "END");
}
# end check_exist_git_lsfiles

#
# function check_compare_twpol_and_git_lsfiles
#
# git ls-filesがtwpolにない場合は、gitから削除を行う。
sub check_compare_twpol_and_git_lsfiles {
  my $function_name = "check_compare_twpol_and_git_lsfiles";
  my $ret = FALSE;
  my $cmd, $cmd_ret;
  my $i, $lsfile_match;
  
  &output_log(1, $function_name, "START");
  
  # twpol.txtに存在しなくて、git-lsfilesに存在する場合はgitから削除する
  
  # git ls-filesのリスト分ループする
  for ($i=0; $i < scalar(@GIT_LSFILES_ARRAY_WITHOUT_ACL); $i++) {
    chomp $GIT_LSFILES_ARRAY_WITHOUT_ACL[$i];
    
    # SET_DIRと先頭マッチするか調べる
    $lsfile_match = 0;
    foreach (@TWPOL_SETDIR_ARRAY) {
      # 末尾の改行コード削除
      chomp $_;
      if ($GIT_LSFILES_ARRAY_WITHOUT_ACL[$i] =~ /^$_/){
        $lsfile_match = 1;
        &output_log(1, "DIRMATCH: " . $function_name, $GIT_LSFILES_ARRAY_WITHOUT_ACL[$i] . ' =~ /^' . $_ . '/ ');
        last;
      }
    }

    # SET_DIRとマッチしなかった場合
    if ($lsfile_match == 0) {
      # SET_FILEと全文マッチするか調べる
      foreach (@TWPOL_SETFILE_ARRAY) {
        # 末尾の改行コード削除
        chomp $_;
        if ($GIT_LSFILES_ARRAY_WITHOUT_ACL[$i] =~ /^$_$/){
          $lsfile_match = 1;
          &output_log(1, "FILE_MATCH: " . $function_name, $GIT_LSFILES_ARRAY_WITHOUT_ACL[$i] . ' =~ /^' . $_ . '$/ ');
          last;
        }
      }
    }
    # いずれもマッチしない場合は削除する
    if ($lsfile_match == 0) {
      # gitからremoveする
      &remove_file_or_dir($GIT_LSFILES_ARRAY_WITHOUT_ACL[$i]);
    }
  }

  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end check_compare_twpol_and git_lsfiles

#
# function check_tripwire
#
# tripwireリポートのチェック
sub check_tripwire {
  my $function_name = "check_tripwire";
  my $ret = FALSE;
  my $cmd, $cmd_ret;
  my @tripwire_report_logs;
  my $null, $total_num, $mode, $type, $error;
  
  output_log(0, $function_name, "START");

  # tripwireリポートを取得
  $cmd = $CMD_TRIPWIRE . " --check 2>/dev/null";
  @tripwire_report_logs = &exec_readpipe($cmd);

  # tripwireリポート行分ループ
  for (@tripwire_report_logs) {
    chomp $_;
    &output_log(1, $function_name, "$_");
    
    # Total violations found行から処理開始
    if ($_ =~ /^$TRIPWIRE_CHECK_START_REGEX/) {
       # 変更数を取得
       ($null, $total_num) = split(/\:\s+/, $_);
       &output_log(1, $function_name, "TRIPWIRE_CHECK_START total_num='" . $total_num . "'");
    }
    
    # 変更数が0ならレポート解析処理終了する
    if ($total_num eq '') {
      next;
    } elsif ($total_num == 0) {
      last;
    # 変更数が0以上ならレポート解析処理を行う
    } else {
      if ($_ =~ /^Added\:$/) {
        $mode = 'add';
        next;
      } elsif ($_ =~ /^Removed\:$/) {
        $mode = 'remove';
        next;
      } elsif ($_ =~ /^Modified\:$/) {
        $mode = 'modified';
        next;
      # Error Report行で処理終了
      } elsif ($_ =~ /^Error Report$/) {
        &output_log(1, $function_name, "TRIPWIRE_CHECK_END");
        undef($mode);
        last;
      }
    }

    # modeが空以外でgit処理を行う
    if (defined($mode) && $mode ne '') {
      # "/*"で囲まれているか判断
      if ($_ =~ /\s*\"\/.*\"$/) {
        # "とスペースを取り除く
        $_ =~s/\s*\"//g;
        
        $_ =~s/^\///g;
        # removeの場合はディレクトリ or ファイルチェックができないのでtypeを指定できない
        if ($mode eq "remove") {
          $type = 'none';
        } else {
          # typeを取得
          ($type) = check_exist($_)
        }
        &output_log(1, $function_name, "mode='" . $mode . "' file='" . $_ . "' 'type=" . $type);

        # 該当ファイルがaclファイルのじゃない場合のみ処理
        if (($_ =~ /^$PATH_ACL_REGEX/) != TRUE) {
          # tripwireの判定がaddもしくはmodifiedの場合
          if ($mode eq "add") {
            if ($type eq "file") {
              # ファイルを登録する
              &add_file($_);
            } elsif ($type eq "dir") {
              # ディレクトリを登録する
              &add_dir($_);
            } else {
              &output_log(3, $function_name, "Type_ERROR: mode='" . $mode . "' file='" . $_ . "' 'type=" . $type);
            }
          } elsif ($mode eq "modified") {
            if ($type eq "file") {
              # ファイルを登録する
              &modify_file($_);
            } elsif ($type eq "dir") {
              # ディレクトリを登録する
              &modify_dir($_);
            } else {
              &output_log(3, $function_name, "Type_ERROR: mode='" . $mode . "' file='" . $_ . "' 'type=" . $type);
            }
          # tripwireの判定がremoveの場合
          } elsif ($mode eq "remove") {
            &remove_file_or_dir($_);
          }
        }
      }
    }
  }

  # tripwireデータベースファイルの更新
#  $cmd = $CMD_TWADMIN . ' --create-polfile -Q ' . $PASSWORD_TRIPWIRE . ' -S /etc/tripwire/' . $HOSTNAME . '-local.key ' . $FILE_TWPOL . ' >/dev/null 2>&1';
#  $cmd_ret = &exec_system($cmd);
#  &output_log(2, $function_name, "tripwire_create_polfile cmd_ret=$cmd_ret");
  
  # tripwireのデータベースを初期化
  $cmd = $CMD_TRIPWIRE . ' --init -P ' . $PASSWORD_TRIPWIRE . ' >/dev/null 2>&1';
  $cmd_ret = &exec_system($cmd);
  &output_log(2, $function_name, "tripwire_init cmd_ret=$cmd_ret");

  $ret = TRUE;
  &output_log(0, $function_name, "END ret=$ret");
  return $ret;
}
# end check_tripwire

#
# function set_git_lsfiles_array
#
# git ls-filesを配列に登録
sub set_git_lsfiles_array {
  my $function_name = "set_git_lsfiles_array";
  my $ret = FALSE;
  my $cmd;
  
  # GET GIT LSFILES
  $cmd = $CMD_GIT . " ls-files";
  @GIT_LSFILES_ARRAY = &exec_readpipe($cmd);
  foreach(@GIT_LSFILES_ARRAY) {
    chomp $_;
    # 該当ファイルがaclファイルのじゃない場合のみ
    if (($_ =~ /^$PATH_ACL_REGEX/) != TRUE) {
      push (@GIT_LSFILES_ARRAY_WITHOUT_ACL, $_);
    }
  }
  return;
}
# end set_git_lsfiles_array

#
# function set_array_twpol
#
# twpolの設定を@TWPOL_SETFILE_ARRAYと@TWPOL_SETDIR_ARRAY配列に登録する
#
# 引数1:なし
#
sub set_array_twpol {
  my $function_name = "set_array_twpol";
  my $cmd;
  &output_log(0, $function_name, "START");
  
  # twpol.txtのSET_FILE設定をgit登録していく
  $cmd = $CMD_CAT . " " . $FILE_TWPOL . "|" . $CMD_EGREP . " -v '^ *#'|" . $CMD_EGREP . " '\\->'|" . $CMD_EGREP . ' "\(SET_FILE\)"|' . $CMD_AWK . ' \'{print $1}\'|' . $CMD_SED . ' -e \'s/^\///\'';
  @TWPOL_SETFILE_ARRAY = &exec_readpipe($cmd);

  # twpol.txtのSET_DIR設定をgit登録していく
  $cmd = $CMD_CAT . " " . $FILE_TWPOL . "|" . $CMD_EGREP . " -v '^ *#'|" . $CMD_EGREP . " '\\->'|" . $CMD_EGREP . ' "\(SET_DIR\)"|' . $CMD_AWK . ' \'{print $1}\'|' . $CMD_SED . ' -e \'s/^\///\'';
  @TWPOL_SETDIR_ARRAY = &exec_readpipe($cmd);
  &output_log(0, $function_name, "END");
}
# end set_array_twpol

#
# function exec_readpipe
#
# 引数1:コマンドライン
#
# コマンド実行で標準出力を配列で返す
# @return : コマンドの標準出力
sub exec_readpipe {
  my $cmd = shift;
  my $function_name = "exec_readpipe";
  my @stdout;

  &output_log(1, $function_name, "START cmd=$cmd");
  
  @stdout = readpipe($cmd);
  &output_log(0, $function_name, "'$cmd' stdout_num='" . @stdout . "'");
  
  &output_log(1, $function_name, "END");
  return @stdout;
}
# end exec_readpipe

#
# function exec_system
#
# 引数1:コマンドライン
#
# コマンド実行
# @return : TRUE=成功, FALSE=失敗
sub exec_system {
  my $cmd = shift;
  my $function_name = "exec_system";
  my $ret = FALSE;
  my $unix_ret;

  &output_log(1, $function_name, "START");
  
  $unix_ret = system("$cmd");
  &output_log(0, $function_name, "'$cmd' unix_ret='$unix_ret'");
  if ($unix_ret != 0) {
    syslog("info", " [ERROR]: '". $cmd . "' unix_ret='" . $unix_ret . "'");
  } else {
    $ret = TRUE;
  }
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end exec_system

#
# function add_file
#
# 引数1:gitに登録するファイル
# 渡された引数をgitに登録、aclも登録
sub add_file {
  my $path = shift;
  my $ret = FALSE;
  my $function_name = "add_file";
  my $cmd, $cmd_ret, $path_type;

  &output_log(1, $function_name, "START path=$path");

  # ファイルが存在しているかチェック
  ($path_type) = &check_exist($path);
  &output_log(1, "path_type=$path_type, path_status=$path_status");
  if ($path_type eq 'not_found' || $path_type eq 'dir') {
    return $ret;
  }

  # git addの実施
  if (&add_git($path) == TRUE) {
    #aclを追加&更新する
    &add_acl($path);
  }

  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end add_file

#
# function add_dir
#
# 引数1:gitに登録するパス
#
# git登録するときにaclも登録
# 渡された引数をgitに登録、aclも登録
sub add_dir {
  my $path = shift;
  my $ret = FALSE;
  my $function_name = "add_dir";
  my $cmd, $cmd_ret, $path_type, $path_status;

  &output_log(1, $function_name, "START path=$path");

  # 空ディレクトリの場合はgit addしない
  ($path_type, $path_status) = &check_exist($path);
  &output_log(1, "path_type=$path_type, path_status=$path_status");
  if ($path_type eq 'not_found' || $path_type eq 'file' || ($path_type eq 'dir' && $path_status eq 'empty')) {
    return $ret;
  }

  # git add --dry-runの結果を配列で取得
  @add_git_dryrun_array = &get_add_git_dryrun_array($path);
  if (@add_git_dryrun_array != 0) {
    foreach(@add_git_dryrun_array) {
      chomp $_;
      # git addの実施
      if (&add_git($_) == TRUE) {
        # git addで追加された場合のみaclを追加&更新する
        &add_acl($_);
      }
    }
  }
  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end add_dir

#
# function modify_file
#
# 引数1:gitに登録するファイル
#
# git登録するときにaclも登録
# 渡された引数をgitに登録、aclはgit addされなくても上書き登録
sub modify_file {
  my $path = shift;
  my $ret = FALSE;
  my $function_name = "modify_file";
  my $cmd, $cmd_ret, $path_type;

  &output_log(1, $function_name, "START path=$path");

  # ファイルが存在しているかチェック
  ($path_type) = &check_exist($path);
  &output_log(1, "path_type=$path_type, path_status=$path_status");
  if ($path_type eq 'not_found' || $path_type eq 'dir') {
    return $ret;
  }

  # git addの実施
  &add_git($path);
  #aclを追加&更新する
  &add_acl($path);

  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end modify_filee

#
# function modify_dir
#
# 引数1:gitに登録するパス
#
# git登録するときにaclも登録
# 渡された引数をgitに登録、aclはgit addされなくても上書き登録
# git登録するときにaclも登録
sub modify_dir {
  my $path = shift;
  my $ret = FALSE;
  my $function_name = "modify_dir";
  my $cmd, $cmd_ret, $path_type, $path_status;

  &output_log(1, $function_name, "START path=$path");

  # 空ディレクトリの場合はgit addしない
  ($path_type, $path_status) = &check_exist($path);
  &output_log(1, $function_name, "path_type=$path_type, path_status=$path_status");
  if ($path_type eq 'not_found' || $path_type eq 'file' || ($path_type eq 'dir' && $path_status eq 'empty')) {
    return $ret;
  }

  # ディレクトリのaclは先に更新する
  &add_acl($path);
  
  # git add --dry-runの結果を配列で取得
  @add_git_dryrun_array = &get_add_git_dryrun_array($path);
  if (@add_git_dryrun_array != 0) {
    foreach(@add_git_dryrun_array) {
      chomp $_;
      # git addの実施
      &add_git($_);
      # add_gitされなくてもaclを追加&更新する
      &add_acl($_);
    }
  }
  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end modify_dir

# function remove_file_or_dir
#
# 引数1:ファイルパス
#
# gitからfileの情報(実ファイルは消さない)を削除し、aclファイルの削除とgitからacl情報を削除する
# @return : TRUE=成功,  FALSE=失敗
sub remove_file_or_dir {
  my $path = shift;
  my $function_name = 'remove_file_or_dir';
  my $ret = FALSE;

  &output_log(1, $function_name, "START path=$path");

  # ファイルのgit情報を削除する
  if (&remove_git($path) == TRUE) {
    &remove_acl($path);
  }
  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end remove_file_or_dir

#
# function add_acl
#
# 引数1:ファイルパス
#
# aclをファイルを作成する
# @return : TRUE=成功,  FALSE=失敗
sub add_acl {
  my $path = shift;
  my $function_name = "add_acl";
  my $ret = FALSE;
  my $cmd, $cmd_ret;
  my $check_path, $check_acl_path, $dir_path;
  my @dirname_list;
  
  if ( $OS eq "SUNOS") {
    $ret = TRUE;
    return $ret;
  }
  
  &output_log(1, $function_name, "START path=$path");
  
  # ディレクトリの場合dirname()を回避
  if (-d $path) {
    $dir_path = $path;
  } else {
    $dir_path = dirname($path);
  }
  # ディレクトリ存在チェックの為に'/'毎に区切る
  @dirname_list = split('/', $dir_path);
  $check_acl_path = $PATH_ACL;
  foreach (@dirname_list) {
    chomp $_;
    $check_acl_path .= $_ . '/';
    $check_path .= $_ . '/';
    &output_log(1, $function_name, "path=$path, check_acl_path=$check_acl_path, check_path=$check_path");
    # acl保存先のディレクトリチェック
    if (-d $check_path && ! -e $check_acl_path) {
      $cmd = $CMD_MKDIR . ' ' . $check_acl_path;
      $cmd_ret = &exec_system($cmd);
      if ($cmd_ret == TRUE) {
        # acl/にaclファイルを作成
        if (-e $check_path) {
          $cmd = $CMD_GETFACL . " " . $check_path . " > " . $check_acl_path . $FILENAME_ACL;
          $cmd_ret = &exec_system($cmd);
          if ($cmd_ret == TRUE) {
            &add_git($check_acl_path . $FILENAME_ACL);
          }
        }
      }
    }
  }

  # aclの更新
  if (-e $path) {
    $cmd = $CMD_GETFACL . " " . $path . " > " . $PATH_ACL . $path;
    # もしディレクトリの場合は.aclを更新する
    if (-d $path) {
      $cmd .= '/' . $FILENAME_ACL;
    }
    $cmd_ret = &exec_system($cmd);
    if ($cmd_ret == TRUE) {
      &add_git($PATH_ACL . $path);
    }
  }

  &output_log(1, $function_name, "END ret=$ret");
  $ret = TRUE;
  return $ret;
}
# end add_acl

#
# function remove_acl
#
# 引数1:ファイルパス
#
# aclを削除する
# @return : TRUE=成功,  FALSE=失敗
sub remove_acl {
  my $path = shift;
  my $function_name = "remove_acl";
  my $ret = FALSE;
  my $cmd, $cmd_ret, my $path_type, $path_type_status, $dh, $acl_type;
  my @dirname_list;

  if ( $OS eq "SUNOS") {
    $ret = TRUE;
    return $ret;
  }
  
  &output_log(1, $function_name, "START path=$path");
  
  # $FILENAME_ACLのacl情報を削除する
  ($path_type, $path_status) = &check_exist($path);
  if ($path_type eq 'dir') {
    $acl_file = $PATH_ACL . $path . '/' . $FILENAME_ACL;
  } elsif ($path_type eq 'file') {
    $acl_file = $PATH_ACL . $path;
  # 存在しない場合dirかfileかわからない
  } elsif ($path_type eq 'not_found') {
    $acl_file = $PATH_ACL . $path;
  } else {
    return $ret;
  }

  # aclファイルをチェックする
  ($acl_type, $acl_status) = &check_exist($acl_file);
  # aclファイルを削除する
  if ($acl_type eq 'file') {
    $cmd = $CMD_RM . ' -f ' . $acl_file;
    $cmd_ret=&exec_system($cmd);
    if ($cmd_ret == TRUE) {
      &remove_git($acl_file);
    }
  # aclディレクトリが空ディレクトリの場合
  } elsif ($acl_type eq 'dir') {
    # ディレクトリを削除
    $cmd = $CMD_RM . ' -rf ' . dirname($acl_file);
    $cmd_ret = exec_system($cmd);
    if ($cmd_ret == TRUE) {
      # gitから削除
      &remove_git($acl_file);
    }
  # not foundの場合
  } else {
    return $ret;
  }
  
  #aclディレクトリが.aclファイル以外空の場合はそのaclディレクトリは削除する
  ($acl_type) = &check_exist(dirname($acl_file));
  if ($acl_type eq "dir") {
    opendir $dh, dirname($acl_file) or die $!;
    &output_log(1, $function_name, "opendir dirname($acl_file)");
    if ( ! grep { $_ ne '.' && $_ ne '..' && $_ ne $FILENAME_ACL } readdir $dh ) {
      $cmd = $CMD_RM . ' -rf ' . dirname($acl_file);
      $cmd_ret = exec_system($cmd);
      if ($cmd_ret == TRUE) {
        # gitから削除
        &remove_git(dirname($acl_file));
      }
    }
  }
  $ret = TRUE;
  &output_log(1, $function_name, "END ret=$ret");
  return $ret;
}
# end remove_acl

#
# function add_git_dryrun_array
#
# 引数1:ファイルパス
#
# @return : git add --dry-runをした標準出力を返す
sub get_add_git_dryrun_array {
  my $path = shift;
  my $function_name = "get_add_git_dryrun_array";
  my @dryrun_stdout, @array_list;
  my $cmd, $cmd_ret, $null, $i=0;
  
  &output_log(1, $function_name, "START path=$path");

  # git addのdryrunの標準出力を受け取る
  $cmd = $CMD_GIT . ' add --dry-run ' . $path . ' 2>&1';
  @dryrun_stdout = &exec_readpipe($cmd);

  # git add dryrunした場合に成功予定だと標準出力が出力される
  if (@dryrun_stdout != 0) {
    foreach (@dryrun_stdout) {
      chomp $_;
      # 標準出力を確認する
      if ($_ =~ /^add\s\'/) {
        ($null, $array_list[$i]) = split("'", $_);
        $i++;
      }
    }
  }
  &output_log(1, $function_name, "END");
  return @array_list;
}

#
# function add_git
#
# 引数1:ファイルパス
#
# gitリストにファイルを追加する
# @return : TRUE=git登録した時のみ,  FALSE=それ以外
sub add_git {
  my $path = shift;
  my $function_name = "add_git";
  my $ret = FALSE;
  my @dryrun_stdout;
  my $cmd, $cmd_ret;

  &output_log(1, $function_name, "START path=$path");

  # git addのdryrun実施
  $cmd = $CMD_GIT . ' add --dry-run ' . $path . ' 2>&1';
  @dryrun_stdout = &exec_readpipe($cmd);

  # git add dryrunした場合に成功予定だと標準出力が出力される
  if (@dryrun_stdout != 0) {
    # 標準出力を確認する
    $line_stdout = shift @dryrun_stdout;
    if ($line_stdout =~ /^add\s\'/) {
      &output_log(1, $function_name, "dry-run stdout_check=OK");
      # git add実施
      $cmd = $CMD_GIT . ' add ' . $path;
      $cmd_ret = &exec_system($cmd);
      if ($cmd_ret == TRUE) {
        $GIT_COMMIT_FLAG = 1;
        $ret = TRUE;
        &output_log(2, $function_name, "GIT ADD $path ret=$cmd_ret");
      } else {
        &output_log(2, $function_name, "GIT ADD $path ret=$cmd_ret");
      }
    } elsif ($line_stdout =~ /^fatal\:/) {
      &output_log(3, $function_name, "dry-run stdout_check=FATAL '$line_stdout'");
    } else {
      &output_log(3, $function_name, "dry-run stdout_check=NG");
    }
  } else {
    &output_log(1, $function_name, "dry-run stdout_check=NO_STDOUT");
  }
  &output_log(1, $function_name, "END ret=$ret, GIT_COMMIT_FLAG=$GIT_COMMIT_FLAG");
  return $ret;
}

#
# function remove_git
#
# 引数1:ファイルパス
#
# gitリストからファイルを削除する
# @return : TRUE=git削除した時のみ,  FALSE=それ以外
sub remove_git {
  my $path = shift;
  my $function_name = "remove_git";
  my $ret = FALSE;
  my @dryrun_stdout, @exec_stdout;
  my $cmd, $cmd_re, $line_stdout;
  
  &output_log(1, $function_name, "START path=$path");
  
  # git removeのdryrun実施
  $cmd = $CMD_GIT . ' rm -r  --cached --dry-run ' . $path . ' 2>&1';
  @dryrun_stdout = &exec_readpipe($cmd);
  
  # git rm dryrunした場合に成功予定だと標準出力が出力される
  if (@dryrun_stdout != 0) {
    # 標準出力を確認する
    $line_stdout = shift @dryrun_stdout;
    if ($line_stdout =~ /^rm\s\'/) {
      &output_log(1, $function_name, "dry-run stdout_check=OK");
      # git remove実施
      $cmd = $CMD_GIT . ' rm -r --cached ' . $path . ' > /dev/null 2>&1';
      $cmd_ret = &exec_system($cmd);
      if ($cmd_ret == TRUE) {
        &output_log(1, $function_name, "dry-run stdout_check=OK");
        $GIT_COMMIT_FLAG = 1;
        $ret = TRUE;
        &output_log(2, $function_name, "GIT REMOVE $path ret=$cmd_ret");
      } else {
        &output_log(3, $function_name, "GIT REMOVE $path ret=$cmd_ret");
      }
    } elsif ($line_stdout =~ /^fatal\:/) {
      &output_log(3, $function_name, "dry-run stdout_check=FATAL '$line_stdout'");
    } else {
      &output_log(3, $function_name, "dry-run stdout_check=NG");
    }
  } else {
    &output_log(1, $function_name, "dry-run stdout_check=NO_STDOUT");
  }
  &output_log(1, $function_name, "END ret=$ret, GIT_COMMIT_FLAG=$GIT_COMMIT_FLAG");
  return $ret;
}
# end remove_git

#
# function commit_git
#
# gitの変更点をコミットする
# @return : TRUE=成功,  FALSE=失敗
sub commit_git {
  my $function_name = "commit_git";
  my $ret = FALSE;
  my $cmd, $cmd_ret;

  &output_log(1, $function_name, "START");

  # OSがDEBIANの場合はdryrunをしない(gitバージョンが古い為、dryrunオプションがない)
  if ( $OS ne "DEBIAN") {
    # git commit のdryrun
    $cmd = $CMD_GIT . ' commit -q --dry-run -m \'' . &get_date . '\' >/dev/null';
    $cmd_ret = &exec_system($cmd);
    &output_log(2, $function_name, "GIT COMMIT DRYRUN cmd_ret=$cmd_ret");
  } else {
    $cmd_ret = TRUE;
  }
  
  if ($cmd_ret == TRUE) {
    # git commit実施
    $cmd = $CMD_GIT . ' commit -q -m \'' . &get_date . '\' >/dev/null';
    $cmd_ret = &exec_system($cmd);
    &output_log(2, $function_name, "GIT COMMIT cmd_ret=$cmd_ret");
  } else {
    return $ret;
  }

  if ($cmd_ret == TRUE) {
    # git tag実施
    $cmd = $CMD_GIT . ' tag ' . &get_date . ' > /dev/null';
    $cmd_ret = &exec_system($cmd);
    &output_log(2, $function_name, "GIT TAG cmd_ret=$cmd_ret");
  } else {
    return $ret;
  }

  if ($cmd_ret == TRUE) {
    # git pushのdryrun実施
    $cmd = $CMD_GIT .  ' push --dry-run origin master 2>/dev/null';
    $cmd_ret = &exec_system($cmd);
    &output_log(2, $function_name, "GIT PUSH DRYRUN cmd_ret=$cmd_ret");
  } else {
    return $ret;
  }

  if ($cmd_ret == TRUE) {
    # git push実施
    $cmd = $CMD_GIT . ' push origin master 2>/dev/null';
    $cmd_ret = &exec_system($cmd);
    &output_log(2, $function_name, "GIT PUSH cmd_ret=$cmd_ret");
    $ret = TRUE;
  } else {
    return $ret;
  }
  &output_log(1, $function_name, "END");
  return $ret;
}
# end commit_git

#
# function check_exist
#
# ファイルorディレクトリのチェック
# @return : 
sub check_exist {
  my $path = shift;
  my $function_name = "check_exist";
  my $ret, $ret2;
  
  &output_log(1, $function_name, "START path=$path");
  
  if (-f $path) {
    $ret = "file";
  } elsif (-d $path) {
    # 空ディレクトリの場合
    opendir $dh, dirname($path) or die $!;
    if ( ! grep { $_ ne '.' && $_ ne '..' } readdir $dh ) {
      $ret = "dir";
      $ret2 = "empty";
    } else {
      $ret = "dir";
    }
  } else {
    $ret = "not_found";
  }
  &output_log(1, $function_name, "END ret=$ret ret2=$ret2");
  return $ret, $ret2;
}
# end check_exist

#
# function output_log
#
# 引数1:情報タイプ
# 引数2:ログメッセージ
#
# ログファイル出力
sub output_log {
  my $type_no = shift;
  my $function_name = shift;
  my @debuglog = shift;
  my $type, $output_log;

  if ($type_no == 0) {
    # デバックモードのみログ出力
    if (0 < $DEBUG_LEVEL) {
      $type = "debug";
    }
  } elsif ($type_no == 1) {
    # デバックモード詳細のみログ出力
    if (1 < $DEBUG_LEVEL) {
      $type = "detai";
    }
  } elsif ($type_no == 2) {
    # デバックモード関係なしにログ出力
    $type = "info ";
  } elsif ($type_no == 3) {
    # デバックモード関係なしにログ出力
    $type = "error";
  } else {
  }

  # $typeが空でなければ出力
  if ($type ne '') {
    # 時刻取得
    my $now = strftime "%Y/%m/%d %H:%M:%S", localtime;
    # ログ出力
    for (my $i=0; $i < scalar(@debuglog); $i++) {
      $output_log = $debuglog[$i];
      chomp $output_log;
      print LOGOUT $now . " [" . $type . "]: " . $function_name . "()" . " \"" . $output_log . "\"\n";
    }
    #SYSLOG出力
    if ($type eq "error") {
      syslog("info", " [ERROR]: $output_log");
    }
  }
}

sub open_log {
  open LOGOUT, ">> $LOG_FILE" or die "Open Error. No such file or directory \"$LOG_FILE \" \n";
  flock(LOGOUT, 2);
}

sub close_log {
  # ログファイルクローズ
  close LOGOUT;
}
