require 'bismuth'

class ActionExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }

    @invaders = 8.times.map{|x|
      i = Bi::Sprite.new("invader_white.png")
      i.x = 16 + x*32
      i.y = 120
      i.angle = 90
      i.anchor_x = i.anchor_y = 0.5
      add_child i
      i
    }

    t = 5000 # 5sec
    @actions = [
      Bi::Action::move_to(t,20,20){|node| p [node,:move_to] },
      Bi::Action::move_by(t,20,20){|node| p [node,:move_by] },
      Bi::Action::rotate_by(t,360){|node| p [node,:rotate_by] },
      Bi::Action::rotate_to(t,360){|node| p [node,:rotate_to] },
      Bi::Action::fade_alpha_to(t,0){|node| p [node,:fade_alpha_to] },
      Bi::Action::scale_to(t,2.0,2.0){|node| p [node,:scale_to] },
      Bi::Action::remove(){|node| p [node,:remove] },
      Bi::Action::wait(t){|node| p [node,:wait] },
    ]

    @actions.each_with_index{|a,i|
      @invaders[i].run_action a
    }
  end
end

Bi::System.init(debug:true)
Bi::Window.make_window(320,240)
Bi::RunLoop.instance.run_with_scene ActionExample.new
