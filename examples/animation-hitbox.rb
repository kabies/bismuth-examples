require 'bismuth'

class AnimationExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.set_title("AnimationExample #{Bi::RunLoop.fps}FPS") }

    reader = Bi::AnimationYAMLReader.new("face.yml", hitbox:[0,0xFF,0,128], hurtbox:[0xFF,0,0,128])
    sprite = reader.default
    hitbox_node = Bi::Node.new
    animations = reader.read() {|frame|
      hitbox_node.remove_all_children
      frame.hitbox.each{|name,hitbox|
        hitbox.boxes.each{|box| hitbox_node.add_child box }
      }
    }

    sprite.anchor_x = sprite.anchor_y = 0.5
    sprite.x, sprite.y = self.w/2, self.h/2
    add_child sprite

    # hitbox position start from left-top.
    hitbox_node.x = - sprite.w * sprite.anchor_x
    hitbox_node.y = - sprite.h * sprite.anchor_y
    sprite.add_child hitbox_node

    tmp = animations.first
    animate = Bi::Action::animate tmp.frames, tmp.interval
    sprite.run_action Bi::Action.repeat_forever animate
  end

end

Bi::System.init(fps:60,debug:true)
Bi::Window.make_window( 320, 240)
Bi::RunLoop.instance.run_with_scene AnimationExample.new
