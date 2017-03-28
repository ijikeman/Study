require './logging'

module Process
  class Lib
    def self.logger
      Process::Logger.logger
    end
  end
end
   
  
