require 'bismuth'

class ScreenshotExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "Screenshot / FPS:#{Bi::RunLoop.fps}" }

    bg = Bi::Sprite.new("sky.png")
    add_child bg

    desc = Bi::TextSprite.new("Press P key to screenshot.", size:32,color:[0xff,0xff,0xff] )
    add_child desc
    filename = Bi::TextSprite.new("-", size:32,color:[0xff,0xff,0xff] )
    filename.y = desc.h
    add_child filename

    screenshot_number = 0

    add_event_callback(:KEYBOARD){|key,mod,press|
      if key == Bi::Keyboard::P and press
        f = "ss-#{screenshot_number}.bmp"
        Bi::Window.screenshot(f)
        puts "screenshot: #{f}"
        filename.set_text f
        screenshot_number+=1
      end
    }
  end
end

Bi::System.init(font:"NotoMono-Regular.ttf",debug:true)
Bi::Window.make_window(640,480)
Bi::RunLoop.instance.run_with_scene ScreenshotExample.new
