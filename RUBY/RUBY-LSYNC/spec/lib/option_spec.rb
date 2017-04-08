require 'spec_helper'
require 'option'

describe "Option::options" do
  it "オプションデフォルトで返ってくる" do
    expect(Option::options[:PID_FILE]).to eql '/var/run/sync.pid'
    expect(Option::options[:TMP_PATH]).to eql '/data/tmp'
    expect(Option::options[:WORKERS]).to eql 3
    expect(Option::options[:LOG_LEVEL]).to eql 'ERROR'
  end
end

describe "Option::parse" do
  subject { ARGV.getopts('vpn') }
  before do
    ARGV.clear
    ARGV.concat([
      '-v',
      '-p', '/run/sync.pid',
      '-n', '10',
      '-t', '/tmp'
    ])
  end

  it "
    -vオプションを渡すとLOG_LEVELがDEBUGになる
    -pオプションを渡すとPID_FILEが変更する
    -nオプションを渡すとWORKERSが変更する
    -nオプションを渡すとTMP_PATHが変更する
  " do
    options = Option::parse 
    expect(options[:LOG_LEVEL]).to eq('DEBUG')
    expect(options[:PID_FILE]).to eq('/run/sync.pid')
    expect(options[:WORKERS]).to eq('10')
    expect(options[:TMP_PATH]).to eq('/tmp')
  end
end

describe "Option::parse" do
  it "オプションを渡さないと全てのオプションがnilになる" do
    options = Option::parse
    expect(options[:PID_FILE]).to eq nil
    expect(options[:TMP_PATH]).to eq nil
    expect(options[:WORKERS]).to eq nil
    expect(options[:LOG_LEVEL]).to eq nil
  end
end
