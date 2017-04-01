module Test
  module Gem
    class Client
      attr_reader :tel, :address
      def initialize(tel, address)
        @tel = tel
        @address = address
      end

      def name
        'hanako'
      end
    end
  end
end
