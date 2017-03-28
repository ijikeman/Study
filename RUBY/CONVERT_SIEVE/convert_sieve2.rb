require 'logger'

class DOVECOT
  MAILSPOOLS_PATH = '/data/vmail/mailspools'
  class VMAIL

    class << self
      # mailspools配下のdomainディレクトリを取得
      def vdomains
        vdomains = []
        get_filelist(MAILSPOOLS_PATH).each {|f|
          # ディレクトリのみ
          if File.directory?("#{MAILSPOOLS_PATH}/#{f}")
            vdomains.push(f)
          end
        }
        vdomains
      end

      # domainディレクトリ配下のaccountを取得
      def vaccounts(domain)
        vaccounts = []
        get_filelist("#{MAILSPOOLS_PATH}/#{domain}").each {|f|
          # .domain_sieveは省く && ディレクトリのみ
          if f !~ /(\.domain_sieve)/ && File.directory?("#{MAILSPOOLS_PATH}/#{domain}/#{f}") == TRUE
            vaccounts.push(f)
          end
        }
        vaccounts
      end

      private
      def get_filelist(path)
        paths = []
        # check directory?
        if File.directory?(path) == TRUE
          Dir.chdir(path)
          Dir.glob("*") {|f|
            paths.push(f)
          }
        end
        paths
      end
    end
  end

  class SIEVE
    def initialize(domain, account)
      @logger = Logger.new('/tmp/otedama.log')
      @logger.info('[start_convert_sieve]: ' + account + '@' + domain)
      @domain = domain
      @account = account
      @sieve_lines = {
        :autoreply => [],
        :discard => [],
        :redirect => [],
        :keep_or_discard => []
      }
    end

    def read
      sieve_path = "#{MAILSPOOLS_PATH}/#{@domain}/#{@account}/.dovecot.sieve"
      lines = []
      File.open(sieve_path) do |file|
        file.read.split("\n").each do |line|
          lines.push(line)
        end
      end
      lines
    end

    def parse(lines)
      while lines.count != 0
        line = lines.shift
        if line =~ /^vacation$/
          @sieve_lines[:autoreply].push(line)
          while lines.count != 0
            line = lines.shift
            @sieve_lines[:autoreply].push(line)
            if line =~ /\\\";$/ # \";
              # put otedama.log
              #raise
              break;
            elsif line =~ /\";$/
              break;
            end
          end
        elsif line =~ /^if( not)* header \:regex \"/
          second_line = lines.first
          if second_line =~ /^discard\;$/
            @sieve_lines[:discard].push(line) # if header line
            @sieve_lines[:discard].push(lines.shift) # discard line
            @sieve_lines[:discard].push(lines.shift) # stop line
            @sieve_lines[:discard].push(lines.shift) # "; line
          elsif second_line =~ /^redirect\s+\"[\w.@-]+\"\;$/
            @sieve_lines[:redirect].push(line) # if header line
            @sieve_lines[:redirect].push(lines.shift) # redirect line
            @sieve_lines[:redirect].push(lines.shift) # } line
          end
        elsif line =~ /^redirect\s+\"[\w.@-]+\";$/
            @sieve_lines[:redirect].push(line) # redirect line
        end
      end
      # last line
      if line =~ /^(keep\;)|(discard\;)$/
        @sieve_lines[:keep_or_discard].push(line)
      end
    end

    def save
      save_path = "#{MAILSPOOLS_PATH}/#{@domain}/#{@account}/.dovecot.sieve.newformat"
      File.open(save_path, "w") do |f|
        # Write new header
        f.puts('require ["fileinto", "vacation-seconds", "envelope", "regex", "include"];')
        f.puts('include :personal ".domain_sieve/filter";')
        if @sieve_lines != FALSE
          if @sieve_lines[:discard].nil? == FALSE && @sieve_lines[:discard].empty? == FALSE
            @sieve_lines[:discard].each do |line|
              f.puts(line)
            end
          end
          if @sieve_lines[:autoreply].nil? == FALSE && @sieve_lines[:autoreply].empty? == FALSE
            @sieve_lines[:autoreply].each do |line|
              f.puts(line)
            end
          end
          if @sieve_lines[:redirect].nil? == FALSE && @sieve_lines[:redirect].empty? == FALSE
            @sieve_lines[:redirect].each do |line|
              f.puts(line)
            end
          end
          if @sieve_lines[:keep_or_discard].nil? == FALSE && @sieve_lines[:keep_or_discard].empty? == FALSE
            @sieve_lines[:keep_or_discard].each do |line|
              f.puts(line)
            end
          end
        else
          f.puts('keep;')
        end
      end
    end

    def replace
    end

    def make_newformat
      parse(read)
      save
      replace
    end
  end
end

if (vdomains = DOVECOT::VMAIL::vdomains)
  vdomains.each do |vdomain|
    p vdomain
    if (vaccounts = DOVECOT::VMAIL::vaccounts(vdomain))
      vaccounts.each do |vaccount|
        p vaccount
        sieve = DOVECOT::SIEVE.new(vdomain, vaccount)
        sieve.make_newformat
      end
    end
  end
end

# account_path_array.each do |account_path|
#   if File.file?(account_path + '/.dovecot.sieve')
#     File.open(account_path + '/.dovecot.sieve') do |file|
#       file.each_line do |line|
#         if line ~= /^vacation/
#           vacation_line = TRUE
#           lines.push(line)
#         end
#       end

