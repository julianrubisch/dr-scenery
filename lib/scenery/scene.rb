module Scenery
  class Scene
    attr_gtk

    attr_reader :data

    class << self
      def register(name:, **args)
        scene = new(**args)
        Registry.instance.register(name, scene)
        scene
      end
    end

    def initialize(renderables:, args:, data: {}, tick_callback: -> {})
      @renderables = renderables
      @args = args
      @data = data
      @callback = tick_callback

      @renderables.each do |renderable|
        renderable.class.class_eval do
          attr_gtk
        end
        renderable.args = args
      end
    end

    def tick
      @renderables.each(&:tick)
      @callback.call
    end
  end
end
