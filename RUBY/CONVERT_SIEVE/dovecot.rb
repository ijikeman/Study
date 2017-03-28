module Dovecot
  MAILSPOOLS_PATH = '/data/vmail/mailspools'
  MAILSPOOLS_PATH.freeze
  LOG_FILE = '/tmp/otedama.log'
  LOG_FILE.freeze

  class Vmail
    class << self
      # mailspools配下のdomainディレクトリを取得
      def vdomains
        directories(MAILSPOOLS_PATH)
      end

      # domainディレクトリ配下のaccountを取得(.domain_sieveは省く)
      def vaccounts(domain)
        directories("#{MAILSPOOLS_PATH}/#{domain}").reject {|f| 
          f =~ /^\.domain_sieve$/
        }
      end

      private
      def directories(path)
        if Dir.exist?(path)
          Dir.chdir(path)
          Dir.glob("*").select {|f| File.directory?(f)}
        end
      end
    end
  end

  class Sieve
    require 'logger'

    def initialize(domain, account)
      logger.info('[start_convert_sieve]: ' + account + '@' + domain)
      @domain = domain
      @account = account
      @sieve_lines = {
        :autoreply => [],
        :discard => [],
        :redirect => [],
        :keep_or_discard => ['keep;']
      }
      @sieve_path = "#{MAILSPOOLS_PATH}/#{@domain}/#{@account}/.dovecot.sieve"
    end

    # return nil when file not found
    def read
      IO.readlines(@sieve_path)
      rescue
      return []
    end

    def parse_autoreply(lines)
      vacation = false
      while lines.count != 0
       line = lines.shift
        vacation = true if line =~ /^vacation$/
        # vacation行が終了すればbreak
        break if vacation && line =~ /\";$/
        # vacation行なら変数に格納
        @sieve_lines[:autoreply].push(line) if vacation
      end
    end

    def parse(lines)
      # \";で終わっている場合は危ないのでコンバートせずログに吐いてスキップ
      if lines.grep(/\\\";\n$/)
        logger.info("[pending]: #{@account}@#{@domain}")
        return false
      end
      # 自動返信のみ別処理に切り出し
      parse_autoreply(lines)

      lines.each do |line|
        if line =~ /^if( not)* header \:regex \"/
          # 正規表現マッチは
          second_line = lines.first
          discard = true if second_line =~ /^discard\;$/
          redirect = true if second_line =~ /^redirect\s+\"[\w.@-]+\"\;$/
        end
        discard = redirect = nil if line =~ /\}\;$/
        @sieve_lines[:discard].push(line) if discard
        @sieve_lines[:redirect].push(line) if redirect || line =~ /^redirect\s+\"[\w.@-]+\"\;$/
      end

      if lines.last =~ /^(keep;)|(discard;)$/
        @sieve_lines[:keep_or_discard].push(line)
      end
    end

    def save
      save_path = "#{MAILSPOOLS_PATH}/#{@domain}/#{@account}/.dovecot.sieve.newformat"
      File.open(save_path, "w") do |f|
        # Write new header
        f.puts('require ["fileinto", "vacation-seconds", "envelope", "regex", "include"];')
        f.puts('include :personal ".domain_sieve/filter";')
        @sieve_lines[:discard].each do |line|
          f.puts(line)
        end
        @sieve_lines[:autoreply].each do |line|
          f.puts(line)
        end
        @sieve_lines[:redirect].each do |line|
          f.puts(line)
        end
        @sieve_lines[:keep_or_discard].each do |line|
          f.puts(line)
        end
      end
    end

    def make_newformat
      if parse(read)
        save
      end
    end

    private
    def logger
      @logger ||= Logger.new(LOG_FILE)
      @logger
    end
  end
end

Dovecot::Vmail.vdomains.each do |vdomain|
  Dovecot::Vmail.vaccounts(vdomain).each do |vaccount|
    sieve = Dovecot::Sieve.new(vdomain, vaccount)
    sieve.make_newformat
  end
end
