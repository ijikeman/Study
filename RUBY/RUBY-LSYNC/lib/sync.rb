require 'bundler'
Bundler.setup
require 'rb-inotify'

class Sync
  def get_fstat(path)
    f = File::Stat.new(path)
    p f.ino
    p f.size
    p f.mtime
  end

  def copy_to_tmp(path)
      Logging.logger.debug "Copy to #{@options[:TMP_PATH]}/#{File.basename(path)}"
      FileUtils.cp path, "#{@options[:TMP_PATH]}/#{File.basename(path)}"
    rescue => e
      puts e
  end  
end
