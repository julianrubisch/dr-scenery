require "lib/scenery/scenery"

def tick args
  @title_label ||= TitleLabel.new
  @game_label ||= GameLabel.new
  @game_over_label ||= GameOverLabel.new

  add_scene(name: :title_scene, renderables: [@title_label], args: args)
  add_scene(name: :game_scene, renderables: [@game_label], args: args)
  add_scene(name: :game_over_scene, renderables: [@game_over_label], args: args)

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
