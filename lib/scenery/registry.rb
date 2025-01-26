module Scenery
  class Registry
    attr_accessor :root

    class << self
      def instance
        @instance ||= new
      end

      private :new
    end

    def initialize
      @registry = {}
    end

    def register(name, scene)
      @registry[name] = scene
    end

    def lookup(name)
      @registry[name]
    end
  end
end
