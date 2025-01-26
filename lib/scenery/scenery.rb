module Scenery
  VERSION = "0.1.0"
end

require "lib/scenery/registry.rb"
require "lib/scenery/root.rb"
require "lib/scenery/scene.rb"

def add_scene(**args)
  Scenery::Scene.register(**args)
end

def lookup_scene(name)
  Scenery::Registry.instance.lookup(name)
end

def current_scene
  lookup_scene Scenery::Registry.instance.root&.current_scene_name
end
