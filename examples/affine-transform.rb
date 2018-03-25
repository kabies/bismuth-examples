require 'bismuth'

class AffineTransformExample < Bi::Scene

  BULLETMAN_PNG = "bulletman.png"
  BULLETMAN_ARM_PNG = "bulletman_arm.png"
  FIRE_PNG = "fire.png"

  SKY_PNG = "sky.png"
  VEHICLE_PNG = "vehicle.png"
  INVADER_PNG = "invader.png"

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }

    @sky = Bi::Sprite.new(SKY_PNG)
    add_child @sky

    @vehicle = Bi::Sprite.new(VEHICLE_PNG)
    add_child @vehicle

    @text = Bi::TextSprite.new("Affine Transform", size:32 )
    @text.anchor_x = 1.0
    @text.anchor_y = 0.5
    @text.run_action Bi::Action::repeat_forever(Bi::Action::sequence([
      Bi::Action::scale_to(1000, -1, 1),
      Bi::Action::scale_to(1000,  1, 1),
    ]))

    @vehicle.add_child @text

    @invader1 =  Bi::Sprite.new(INVADER_PNG)
    @invader2 =  Bi::Sprite.new(INVADER_PNG)

    @vehicle.x = Bi::Window.w / 2
    @vehicle.y = Bi::Window.h / 2
    @vehicle.anchor_x = 0.5
    @vehicle.anchor_y = 0.5
    @vehicle.add_child @invader1
    @vehicle.add_child @invader2

    # invader1 : rotation
    @invader1.run_action Bi::Action::repeat_forever(Bi::Action::rotate_by(4000,360))
    @invader1.y = -32
    @invader1.anchor_x = 0.5
    @invader1.anchor_y = 0.5

    # invader2 : piston
    seq = Bi::Action::sequence([
      Bi::Action::move_to(1000,0,200),
      Bi::Action::move_to(1000,0,40),
      Bi::Action::scale_to(1000, -1, 1),
      Bi::Action::scale_to(1000,  1, 1),
    ])
    @invader2.run_action Bi::Action::repeat_forever(seq)

    # vehicle rotation
    @vehicle.run_action Bi::Action::repeat_forever(Bi::Action::rotate_by(4000,360))

    # bulletman
    @bulletman = Bi::Sprite.new BULLETMAN_PNG
    @bulletman_arm = Bi::Sprite.new BULLETMAN_ARM_PNG
    @fire = Bi::Sprite.new FIRE_PNG
    @fire.anchor_x = 0.5
    @fire.anchor_y = 1
    @fire.x = 16
    @fire.y = 10
    @bulletman_arm.x = 12
    @bulletman_arm.y = 24
    @bulletman_arm.anchor_x = 11.0/32.0
    @bulletman_arm.anchor_y = 11.0/32.0
    rotate = Bi::Action.sequence([
      Bi::Action::rotate_by(2000,-360),
      Bi::Action::wait(1000),
      Bi::Action::rotate_by(2000,360),
      Bi::Action::wait(1000),
    ])
    @bulletman_arm.run_action Bi::Action::repeat_forever(rotate)
    @bulletman_arm.add_child @fire
    @bulletman.add_child @bulletman_arm
    add_child @bulletman
    @bulletman.x = 40
    @bulletman.y = 40
    scaling = Bi::Action::sequence([
      Bi::Action::scale_to( 2000, 4,4),
      Bi::Action::wait(2000),
      Bi::Action::scale_to( 2000, 1,1),
      Bi::Action::wait(2000),
    ])
    @bulletman.run_action Bi::Action::repeat_forever scaling
  end

end

Bi::System.init(fps:120, font:"NotoMono-Regular.ttf")
Bi::Window.make_window(640,480)
Bi::RunLoop.instance.run_with_scene AffineTransformExample.new
