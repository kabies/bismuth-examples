
require 'bismuth'

class Invader
  INVADER_PNG = "invader.png"

  attr_accessor :sprite

  def initialize(x,y)
    @alpha_velocity = 0
    @sprite = Bi::Sprite.new(INVADER_PNG)
    @sprite.x = x
    @sprite.y = y
    @alpha_velocity = -8
  end
  def move
    @sprite.x += rand(3)-1
    @sprite.y += 1-rand(2)
  end
  def update_alpha
    @sprite.alpha = @sprite.alpha + @alpha_velocity
    if @sprite.alpha > 0xFF
      @sprite.alpha = 0xFF
      @alpha_velocity = -8
    elsif @sprite.alpha < 0
      @sprite.alpha = 0
      @alpha_velocity = 8
    end
  end
end

class ShootingExample < Bi::Scene

  MAX_INVADERS = 20

  BACKGROUND_IMAGE = "sky.png"
  BULLET_IMAGE = "ball.png"
  VEHICLE_IMAGE = "vehicle.png"
  SHOOT_BGM = "bgm.wav"
  SHOOT_SE = "shot.wav"
  EXPLODE_SE = "death.wav"

  def add_invader
    i = Invader.new(rand(self.w),rand(self.h/4))
    @invaders << i
    add_child i.sprite
  end

  def initialize
    super()
    add_timer(1000){
      Bi::Window.title = "#{Bi::RunLoop.fps}FPS / #{Bi::Window.renderer_name} / #{Bi::Window.driver_name} / #{Bi::Sound.driver_name}"
    }

    Bi::Sound.init
    p [:sound_decoders, Bi::Sound.decoders]
    p [:music_decoders, Bi::Music.decoders]

    @shoot_se = Bi::Sound.new SHOOT_SE
    @explode_se = Bi::Sound.new EXPLODE_SE
    @bgm2 = Bi::Sound.new SHOOT_BGM

    @bgm2.play loop:true

    @text = Bi::TextSprite.new("Shot:Z / Move:Arrow(Up,Down,Left,Right)", size:24, color:[0xFF,0,0] )
    @background = Bi::Sprite.new(BACKGROUND_IMAGE)
    @vehicle = Bi::Sprite.new(VEHICLE_IMAGE)

    @vehicle.x = self.w/2
    @vehicle.y = self.h-@vehicle.h
    @vehicle.anchor_x = 0.5
    @vehicle.anchor_y = 0
    @balls = []

    @velocity_x = 0
    @velocity_y = 0
    @speed = 2
    add_child @background
    add_child @text
    add_child @vehicle

    @invaders = []
    MAX_INVADERS.times{ add_invader }

    add_event_callback(:KEYBOARD){|key,mod,press|
      case key
      when Bi::Keyboard::LEFT
        @velocity_x = (press ? -1 : 0) * @speed
      when Bi::Keyboard::RIGHT
        @velocity_x = (press ? 1 : 0 ) * @speed
      when Bi::Keyboard::UP
        @velocity_y = (press ? -1 : 0) * @speed
      when Bi::Keyboard::DOWN
        @velocity_y = (press ? 1 : 0) * @speed
      when Bi::Keyboard::Z
        @shooting = press
      when Bi::Keyboard::X
        @speed = press ? 4 : 2
      end
    }

    add_event_callback(:L_STICK_X){|value|
      @velocity_x = value.round * @speed
    }

    add_event_callback(:L_STICK_Y){|value|
      @velocity_y = value.round * @speed
    }

    add_event_callback(:BUTTON_A){|value|
      @speed = value ? 4 : 2
    }

    @shooting = false
    @shoot_interval = 4
    add_event_callback(:BUTTON_B){|value|
      @shooting = value
    }

    Bi::RunLoop.schedule_update{
      if @shooting
        @shoot_interval -= 1
        if @shoot_interval < 0

          @shoot_se.play #override:true

          @shoot_interval = 4
          b = Bi::Sprite.new(BULLET_IMAGE)
          @balls << b
          add_child b
          b.x, b.y = @vehicle.x, @vehicle.y
          b.anchor_x = b.anchor_y = 0.5
        end
      end
    }

    Bi::RunLoop.schedule_update{
      @invaders.each{|i|
        i.update_alpha
      }
    }

    Bi::RunLoop.schedule_update{
      if @invaders.size < MAX_INVADERS
        add_invader
      end

      @vehicle.x += @velocity_x
      @vehicle.y += @velocity_y

      @invaders.each{|i|
        i.move
        if i.sprite.y > self.h
          i.sprite.y = 0
        end
      }

      removing_balls = []
      removing_invaders = []
      @balls.each{|b|
        b.y -= 4
        @invaders.each{|i|
          if i.sprite.intersect? b
            removing_invaders << i
            removing_balls << b
          end
        }
        removing_balls << b if b.y < 0
      }
      if removing_invaders.size > 0
        @explode_se.play #override:true
        removing_invaders.uniq!
        @invaders -= removing_invaders
        removing_invaders.each{|i|
          i.sprite.remove_from_parent
        }
      end
      if removing_balls.size > 0
        removing_balls.uniq!
        @balls -= removing_balls
        removing_balls.each{|b|
          b.remove_from_parent
        }
      end
    }
  end

end

Bi::System.init fps:60, font: "NotoMono-Regular.ttf"
Bi::Window.make_window(640,480)
Bi::RunLoop.instance.run_with_scene ShootingExample.new
