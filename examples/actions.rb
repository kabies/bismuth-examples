require 'bismuth'

class ActionExample < Bi::Scene

  CIRCLE_PNG = "circle.png"
  INVADER_PNG = "invader.png"
  VEHICLE_PNG = "vehicle.png"

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }

    @circle =  Bi::Sprite.new(CIRCLE_PNG)
    add_child @circle

    @invader =  Bi::Sprite.new(INVADER_PNG)
    add_child @invader

    @vehicle =  Bi::Sprite.new(VEHICLE_PNG)
    add_child @vehicle

    # invader moving
    @invader.x, @invader.y = 100,200
    actions = [
      Bi::Action::move_to(1000,200,200),
      Bi::Action::rotate_by(1000,360),
      Bi::Action::move_to(1000,100,200),
      Bi::Action::callback{|node| puts "invader callback #{Time.now}!" }
    ]
    seq = Bi::Action::sequence(actions)
    rep = Bi::Action::repeat seq, 5
    @invader.run_action rep

    # vehicle moving forever
    @vehicle.x, @vehicle.y = 100,20
    actions = [
      Bi::Action::move_to(100,100,24),
      Bi::Action::move_to(100,100,20)
    ]
    rep = Bi::Action::repeat_forever Bi::Action::sequence(actions)
    @vehicle.run_action rep

    add_event_callback(:MOUSE_BUTTON){|button,state,x,y|
      if state
        p [:mouse_down]
        action!
      end
    }
  end

  def action!
    unless @circle.is_action_runnning?
      actions = [
        Bi::Action::callback{|node| p [:callback,:seq_start,Time.now] },
        Bi::Action::move_to(1000, @circle.x, self.h/2 ),
        Bi::Action::callback{|node| p [:callback,:delay_start,Time.now] },
        Bi::Action::wait(1000),
        Bi::Action::callback{|node| p [:callback,:delay_end,Time.now] },
        Bi::Action::move_to(1000,@circle.x,@circle.y),
        Bi::Action::callback{|node| p [:callback,:seq_end,Time.now] },
      ]
      seq = Bi::Action::sequence(actions)
      @circle.run_action seq

      return true
    end
    return false
  end

end

Bi::System.init
Bi::Window.make_window(320,240)
Bi::RunLoop.instance.run_with_scene ActionExample.new
