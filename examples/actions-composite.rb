require 'bismuth'

class ActionCompositeExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }

    @invader =  Bi::Sprite.new("invader.png")
    @invader.x = @invader.y = 0
    add_child @invader

    @vehicle =  Bi::Sprite.new("vehicle.png")
    @vehicle.x = 160
    @vehicle.y = 120
    add_child @vehicle

    # invader moving
    actions = [
      Bi::Action::callback{|n| p [n,:callback1] },
      Bi::Action::move_by(500,320-@invader.w,0){|n| p [n,:right]},
      Bi::Action::callback{|n| p [n,:callback2] },
      Bi::Action::move_by(500,0,240-@invader.h){|n| p [n,:down]},
      Bi::Action::callback{|n| p [n,:callback3] },
      Bi::Action::move_by(500,-320+@invader.w,0){|n| p [n,:left]},
      Bi::Action::callback{|n| p [n,:callback4] },
      Bi::Action::move_by(500,0,-240+@invader.h){|n| p [n,:down]},
      Bi::Action::callback{|n| p [n,:callback5] },
    ]
    seq = Bi::Action::sequence(actions){|n| p [n,:sequence]}
    rep = Bi::Action::repeat(seq, 2){|n| p [n,:repeat]}
    @invader.run_action rep

    # vehicle moving forever
    actions = [
      Bi::Action::move_by(500,0,40){|n| p [n,:up] },
      Bi::Action::move_by(500,0,-40){|n| p [n,:down]}
    ]
    rep = Bi::Action::repeat_forever Bi::Action::sequence(actions)
    @vehicle.run_action rep
  end
end

Bi::System.init
Bi::Window.make_window(320,240)
Bi::RunLoop.instance.run_with_scene ActionCompositeExample.new
