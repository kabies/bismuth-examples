require 'bismuth'

class ArchiveExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.set_title("#{self.class.to_s} #{Bi::RunLoop.fps}FPS") }

    sprite = Bi::Sprite.new "face/face01.png"

    sprite.anchor_x = sprite.anchor_y = 0.5
    sprite.x = self.w/2
    sprite.y = self.h/2
    add_child sprite

    text = Bi::TextSprite.new "Archive Example", font:"NotoMono-Regular.ttf", size:18
    add_child text

    bgm = Bi::Sound.new "bgm.wav"
    bgm.play loop:true

    sound = Bi::Sound.new "shot.wav"
    add_event_callback(:MOUSE_BUTTON) {|button,press,x,y|
      sound.play if press
    }
  end

end

Bi::System.init(fps:60,debug:true,archive:"archive.biar",asset:"archive")
Bi::Window.make_window(320,240)
Bi::RunLoop.instance.run_with_scene ArchiveExample.new
