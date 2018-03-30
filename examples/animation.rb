require 'bismuth'

class AnimationExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.set_title("AnimationExample #{Bi::RunLoop.fps}FPS") }

    reader = Bi::AnimationYAMLReader.new "face.yml"
    sprite = reader.default
    animations = reader.read()

    sprite.anchor_x = sprite.anchor_y = 0.5
    sprite.x = self.w/2
    sprite.y = self.h/2
    add_child sprite

    tmp = animations.first
    animate = Bi::Action::animate tmp.frames, tmp.interval
    sprite.run_action Bi::Action.repeat_forever animate
  end

end

Bi::System.init(fps:60,debug:true)
Bi::Window.make_window(320,240)
Bi::RunLoop.instance.run_with_scene AnimationExample.new
