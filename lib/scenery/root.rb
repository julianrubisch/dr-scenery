module Scenery::Root
  def self.included(mod)
    # holds the current scene name
    attr_accessor :current_scene_name

    attr_gtk
  end

  def initialize
    super()

    # registers itself to the registry, so we can look up the current scene from the top level import
    Scenery::Registry.instance.root = self
  end

  # should extend `tick` to current_scene&.tick
  def tick
    # call super if we are not the top of the call chain
    super if self.class.ancestors[self.class.ancestors.index(self.class) + 2] != AttrGTK

    Scenery::Registry.instance.lookup(@current_scene_name)&.tick
  end
end
