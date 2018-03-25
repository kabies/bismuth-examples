require 'bismuth'

class RainbowExample < Bi::Scene

  INVADER_IMAGE = "invader_white.png"
  BACKGROUND_IMAGE = "sky.png"

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "Rainbow / FPS:#{Bi::RunLoop.fps}" }

    @background = Bi::Sprite.new BACKGROUND_IMAGE
    add_child @background

    @invaders = 10.times.map{|i|
      s = Bi::Sprite.new INVADER_IMAGE
      s.blendmode = Bi::BLENDMODE_ADD
      add_child s
      s.x = i*48
      s.y = 100
      s
    }

    @text = Bi::TextSprite.new("RAINBOW", size:32 )
    add_child @text

    @rect = Bi::Node.new(100,100,100,100)
    @rect.alpha =64
    @rect.blendmode = Bi::BLENDMODE_ADD
    add_child @rect

    @step = 0
    STEP_MAX = 60*3

    Bi::RunLoop.schedule_update{

      @step = (@step+1) % STEP_MAX
      r,g,b = Bi::Rainbow.at @step.to_f / STEP_MAX

      @text.set_color r,g,b
      @rect.set_color r,g,b

      @invaders.each_with_index{|invader,i|
        step = (@step+i*20) % STEP_MAX
        r,g,b = Bi::Rainbow.at step.to_f / STEP_MAX
        invader.set_color r,g,b
      }
    }
  end

end

Bi::System.init fps:120, font:"NotoMono-Regular.ttf"
Bi::Window.make_window(640,480)
Bi::RunLoop.instance.run_with_scene RainbowExample.new
