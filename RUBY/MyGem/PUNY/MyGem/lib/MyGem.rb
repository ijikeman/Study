require "MyGem/version"

module MyGem
  # Your code goes here...
  class Client
    def initialize(name)
      @name = name
    end

    def hello
      p "Hello! #{@name}"
    end
  end
end
