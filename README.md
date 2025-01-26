# DR-Scenery

Welcome to Scenery!

## Installation

1. Create a `lib` directory inside the base directory of your DR game if it doesn't exist yet.
2. Copy the `lib/scenery` directory over.
3. Add require `'lib/scenery/scenery'` to the top of your `app/main.rb` file.


## Usage

Scenery uses a singleton registry to manage your game's scenes. Each scene is composed of several `renderables` whose only requirement is to have a `tick` method. It's not necessary to pass `args` around, each `renderable` is bestowed with `attr_gtk` and `args`, you just have to pass them once when registering the scene.

First, you will need an object including `Scenery::Root` which will automatically add a `current_scene_name` attribute for it. Building upon the stock DR scene management example, it could look like this:

```rb
require "lib/scenery/scenery"

def tick args
  $game ||= Game.new
  $game.args = args # set args property on game

  # initialize the game with a scene
  $game.current_scene_name ||= :title_scene

  # automatically ticks current scene
  $game.tick
end

class Game
  include Scenery::Root

  def tick
    # don't forget to call super!
    super

    if inputs.mouse.click
      case @current_scene_name
      when :title_scene
        @current_scene_name = :game_scene
      when :game_scene
        @current_scene_name = :game_over_scene
      when :game_over_scene
        @current_scene_name = :title_scene
      end
    end
  end
end
```

In `Game`'s `tick` method, we call `super`, which will automatically forward `tick` to the current scene (more on that later). This is also a good place to handle any mutating of the game state, i.e. set the current scene to another one.

As it stands, this code will not run, though, because we haven't actually registered any scenes. Let's continue by adding a few `renderables` to compose these:

```rb
class TitleLabel
  def tick
    outputs.labels << { x: 640,
                        y: 360,
                        text: "Title Scene (click to go to game)",
                        alignment_enum: 1 }
  end
end

class GameLabel
  def tick
    outputs.labels << { x: 640,
                        y: 360,
                        text: "Game Scene (click to go to game over)",
                        alignment_enum: 1 }
  end
end

class GameOverLabel
  def tick
    outputs.labels << { x: 640,
                        y: 360,
                        text: "Game Over Scene (click to go to title)",
                        alignment_enum: 1 }
  end
end
```

Again taken from the scene management example, we define three distinct labels. Note that they adhere to the required protocol of having a `tick` method, and that we can omit `args` because `attr_gtk` is being passed to them.

All that's left to do is actually register the scenes:

```diff
  require "lib/scenery/scenery"
  
  def tick args
+   @title_label ||= TitleLabel.new
+   @game_label ||= GameLabel.new
+   @game_over_label ||= GameOverLabel.new
+ 
+   add_scene(name: :title_scene, renderables: [@title_label], args: args)
+   add_scene(name: :game_scene, renderables: [@game_label], args: args)
+   add_scene(name: :game_over_scene, renderables: [@game_over_label], args: args)
  
    $game ||= Game.new
    $game.args = args # set args property on game
  
    # initialize the game with a scene
    $game.current_scene_name ||= :title_scene
  
    # automatically ticks current scene
    $game.tick
  end
  
  class Game
    include Scenery::Root
  
    def tick
      super
  
      if inputs.mouse.click
        case @current_scene_name
        when :title_scene
          @current_scene_name = :game_scene
        when :game_scene
          @current_scene_name = :game_over_scene
        when :game_over_scene
          @current_scene_name = :title_scene
        end
      end
    end
  end
  
  # label definitions omitted
```

Scenery adds an `add_scene` method to the top level namespace that allows you to register scenes. The `Game#tick` method (via `super`) now simply forwards `tick` to whicheverscene is denoted by `current_scene_name`, ticking all renderables within it. 

More details on the API below:

## API

### `add_scene(name:, renderables:, args:, data: {}, tick_callback: ->{})`

Parameters:
  - `name`: A unique name for the scene (required)
  - `renderables`: An array of objects adhering to the `renderable` protocol (having a `tick` method) (required)
  - `args`: Forward `args` here (required)
  - `data`: A convenience hash to put in any data you mmight need when looking up a scene, e.g. `{ background_color: : [0, 255, 128, 255] }`
  - `tick_callback`: A lambda containing any additional behavior to be run after each tick of each renderable, e.g. `-> { GTK.start_server! port: 3000 }` etc.

### `current_scene`

A top level method that returns the current scene as defined by the `Scenery::Root` object's `current_scene_name` property. Useful for accessing any metadata stored on the scene, e.g.

`current_scene.data.dig(:background_color)`

### `lookup_scene(name)`

A top level method that returns a `Scene`. Mainly used internally for `current_scene`.

## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/julianrubisch/dr-scenery.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
