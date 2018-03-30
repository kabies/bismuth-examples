require 'bismuth'

class ClickToRemove < Bi::Scene
  def initialize
    super
    bg = Bi::Sprite.new "sky_red.png"
    add_child bg
    desc = Bi::TextSprite.new "Click Invader to Remove!", size:32
    desc.set_color 0xff,0xff,0xff
    add_child desc

    pole = Bi::Node.new(self.w/2, self.h/2,10,10)
    pole.set_color 0,0xff,0xff,128
    pole.anchor_x = pole.anchor_y = 0.5
    add_child pole
    pole.run_action Bi::Action::repeat_forever Bi::Action::rotate_by(10000,360)

    boxes = [
      Bi::Node.new(0,-120,200,200),
      Bi::Node.new(0,120,200,200),
    ]

    boxes.first.set_color 0xff,0,0,128
    boxes.last.set_color 0,0xff,0,128
    boxes.each{|box|
      box.anchor_x = box.anchor_y = 0.5
      pole.add_child box

      10.times do
        invader = Bi::Sprite.new("invader.png")
        box.add_child invader
        invader.anchor_x = invader.anchor_y = 0.5
        invader.x = rand(-90..90)
        invader.y = rand(-90..90)
        invader.run_action Bi::Action::repeat_forever Bi::Action::rotate_by(10000,-360)

        invader.add_event_callback(:MOUSE_BUTTON) {|button,press,x,y|
          if invader.include?(x,y) and press
            invader.remove_from_parent
          end
        }
      end
    }
  end
end

Bi::System.init(fps:60,font:"NotoMono-Regular.ttf",debug:true)
Bi::Window.make_window(640,480)
Bi::RunLoop.instance.run_with_scene ClickToRemove.new
