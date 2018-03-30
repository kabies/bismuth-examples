require 'bismuth'

class FadeExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "Fade / FPS:#{Bi::RunLoop.fps}" }

    @bg_blue = Bi::Sprite.new("sky.png")
    @bg_red = Bi::Sprite.new("sky_red.png")
    @bg_blue.alpha = 0
    @bg_red.alpha = 0xff
    add_child @bg_blue
    add_child @bg_red

    @fading = false
    @fade_direction = :to_red

    add_event_callback(:MOUSE_BUTTON){|button,state,x,y|
      next true unless state
      next true if @fading
      fade_start
    }
  end

  def fade_start
    if @bg_red.alpha == 0xFF
      p [:fade_to_blue]
      @bg_red.run_action Bi::Action::fade_alpha_to 1000, 0
      @bg_blue.run_action Bi::Action::fade_alpha_to 1000, 0xFF
    elsif @bg_blue.alpha == 0xFF
      p [:fade_to_red]
      @bg_red.run_action Bi::Action::fade_alpha_to 1000, 0xFF
      @bg_blue.run_action Bi::Action::fade_alpha_to 1000, 0
    end
  end

end

Bi::System.init(fps:60,debug:true)
Bi::Window.make_window(640,480)
Bi::RunLoop.instance.run_with_scene FadeExample.new
