require 'bismuth'

class KeyboardCallbackExample < Bi::Scene
  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }
    self.set_color 0xff,0xff,0xff,0xff
    @text = Bi::TextSprite.new("-", size:18 )
    add_child @text
    add_event_callback(:KEYBOARD) {|key,mod,press|
      if press
        keyname = Bi::Keyboard.name(key)
        p [:keyname, keyname]
        @text.set_text "#{keyname}"
      end
    }
  end
end

Bi::System.init font:"NotoMono-Regular.ttf"
Bi::Window.make_window(320,240)
Bi::RunLoop.instance.run_with_scene KeyboardCallbackExample.new
