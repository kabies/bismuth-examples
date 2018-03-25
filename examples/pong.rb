require 'bismuth'

class PongExample < Bi::Scene

  BALL_PNG = "ball.png"
  BAR_PNG = "bar.png"

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }

    self.set_color 0,0x66,0x33

    @balls = [
      Bi::Sprite.new(BALL_PNG),
      Bi::Sprite.new(BALL_PNG),
      Bi::Sprite.new(BALL_PNG)
    ]
    @balls.each{|b|
      b.x = rand(100)
      b.y = rand(100)
    }
    @velocities = [ [2,2], [2,-2], [-2,2] ]

    @bar = Bi::Sprite.new(BAR_PNG)
    @bar.y = self.h - @bar.h - 20
    add_child @bar

    @balls.each{|b| add_child b }


    add_event_callback(:MOUSE_MOTION){|x,y|
      # p [x,y]
      @bar.x = x
      true
    }

    Bi::RunLoop.schedule_update{
      @balls.each{|b|
        if b.y >= self.h
          b.x = 0
          b.y = 0
        end
      }
      @velocities.each_with_index{|v,i|
        v[0] = -2 if self.w <= @balls[i].x
        v[1] = -2 if self.h <= @balls[i].y
        v[0] = 2 if @balls[i].x <= 0
        v[1] = 2 if @balls[i].y <= 0
        if @bar.include? @balls[i].x, @balls[i].y
          v[1] = -2
        end
        @balls[i].x += v[0]
        @balls[i].y += v[1]
      }
    }
  end

end

Bi::System.init(fps:60)
Bi::Window.make_window 640, 480
Bi::RunLoop.instance.run_with_scene PongExample.new
