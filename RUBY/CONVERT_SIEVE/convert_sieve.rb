class ConvertSieve
  MAILSPOOLS_PATH = '/data/vmail/mailspools'

  # mailspools配下のdomainディレクトリを取得
  def vdomains
    @vdomains = []
    if File.directory?("#{MAILSPOOLS_PATH}") == FALSE
      return FALSE
    end
    Dir.chdir(MAILSPOOLS_PATH)
    Dir.glob("*") {|f|
      if f !~ /(\.domain_sieve)/ && File.directory?("#{MAILSPOOLS_PATH}/#{f}")
        @vdomains.push(f)
      end
    }
    @vdomains
  end

  # domainディレクトリ配下のaccountを取得
  def vaccounts(vdomain)
    @vaccounts = []
    if File.directory?("#{MAILSPOOLS_PATH}/#{vdomain}") == FALSE
      return FALSE
    end
    Dir.chdir("#{MAILSPOOLS_PATH}/#{vdomain}")
    Dir.glob("*") {|f|
      if File.directory?("#{MAILSPOOLS_PATH}/#{vdomain}/#{f}")
        @vaccounts.push(f)
      end
    }
    @vaccounts
  end

  def read_sieve(vdomain, vaccount)
    sieve_path = "#{MAILSPOOLS_PATH}/#{vdomain}/#{vaccount}/.dovecot.sieve"
    @current_lines = []
    # return sieve_path
    begin
      File.open(sieve_path) do |file|
        file.read.split("\n").each do |line|
          @current_lines.push(line)
        end
      end
      @current_lines
    rescue SystemCallError => e
      puts %Q{class=[#{e.class}] message=[#{e.message}]}
      return FALSE
    rescue IOError => e
      puts %Q{class=[#{e.class}] message=[#{e.message}]}
      return FALSE
    rescue
      puts %Q{class=[#{e.class}] message=[#{e.message}]}
      return FALSE
    end
  end

  def parse_sieve(current_line)
    @parsed_lines = {}
    if current_line == FALSE || current_line.nil? == TRUE
      return FALSE
    end

    autoreply = []
    discard = []
    redirect = []
    keep_or_discard = []
    kind = nil
    while current_line.count != 0
      line = current_line.shift
      if kind == nil
        if line.match(/^if header \:regex/)
          next_line = current_line.shift
          if next_line.match(/^discard\;$/)
            kind = 'discard'
            discard.push(line)
            discard.push(next_line)
          elsif next_line.match(/redirect/)
            kind = 'redirect'
            redirect.push(line)
            redirect.push(next_line)
          end
        elsif line.match(/^vacation$/)
          kind = 'autoreply'
          autoreply.push(line)
        elsif line.match(/^(keep;)|(discard;)/)
          keep_or_discard.push(line)
        end
      elsif kind == 'autoreply'
        autoreply.push(line)
        kind = nil if line.match(/\"\;$/)
      elsif kind == 'discard'
        discard.push(line)
        kind = nil if line.match(/^\}$/)
      elsif kind == 'redirect'
        redirect.push(line)
        kind = nil if line.match(/^\}$/)
      end
    end
    {
      :autoreply => autoreply,
      :keep_or_discard => keep_or_discard,
      :discard => discard,
      :redirect => redirect
    }
  end

  def save_newformat_sieve(vdomain, vaccount, newformat_lines)
    new_sieve_path = "#{MAILSPOOLS_PATH}/#{vdomain}/#{vaccount}/.dovecot.sieve.newformat"
    File.open(new_sieve_path, "w") do |f|
      # Write new header
      f.puts('require ["fileinto", "vacation-seconds", "envelope", "regex", "include"];')
      f.puts('include :personal ".domain_sieve/filter";')
      if newformat_lines != FALSE
        if newformat_lines[:discard].nil? == FALSE && newformat_lines[:discard].empty? == FALSE
          newformat_lines[:discard].each do |line|
            f.puts(line)
          end
        end
        if newformat_lines[:autoreply].nil? == FALSE && newformat_lines[:autoreply].empty? == FALSE
          newformat_lines[:autoreply].each do |line|
            f.puts(line)
          end
        end
        if newformat_lines[:redirect].nil? == FALSE && newformat_lines[:redirect].empty? == FALSE
          newformat_lines[:redirect].each do |line|
            f.puts(line)
          end
        end
        if newformat_lines[:keep_or_discard].nil? == FALSE && newformat_lines[:keep_or_discard].empty? == FALSE
          newformat_lines[:keep_or_discard].each do |line|
            f.puts(line)
          end
        end
      else
        f.puts('keep;')
      end
    end
  end

  def replace_newformat_sieve(vdomain, vaccount)
  end

  def make_newformat_sieve()
    newformat_lines = parse_sieve(read_sieve)
    save_newformat_sieve(newformat_lines)
    replace_newformat_sieve
  end
  attr_reader :vdomain, :vaccount
  def initialize(vdomain, vaccount)
    @vdomain = vdomain
    @vaccount = vaccount
  end
end




if (vdomains = A.vdomains)
  vdomains.each do |vdomain|
    if (vaccounts = A.vaccounts(vdomain))
      vaccounts.each do |vaccount|
c = ConvertSieve.new(vdomain, vaccount)
c.make_newformat_sieve
        # c.make_newformat_sieve(vdomain, vaccount)
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

