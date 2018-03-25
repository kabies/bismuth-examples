require 'bismuth'

class MenuExample < Bi::Scene

  def initialize
    super

    set_color 0xee,0xee,0xee,0xFF

    @text = Bi::TextSprite.new("Menu Example", size:32 )
    add_child @text

    @indicator = Bi::TextSprite.new("-", size:24 )
    add_child @indicator
    @indicator.y = 48

    callback_a = proc {|e| @indicator.set_text "menu A selected!" }

    menu_items = [
      Bi::MenuItem.new( "Menu A", {size:24}, &callback_a),
      Bi::MenuItem.new( "Menu B", size:24){|e| @indicator.set_text "menu B selected!" },
      Bi::MenuItem.new( "Menu C", size:24){|e| @indicator.set_text "menu C selected!"},
    ]

    @menu = Bi::Menu.new menu_items
    @menu.align_vertical(20)
    @menu.x = self.w/2
    @menu.y = self.h/2

    add_child @menu

    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }
  end

end

Bi::System.init font:"NotoMono-Regular.ttf"
Bi::Window.make_window 640,480
Bi::RunLoop.instance.run_with_scene MenuExample.new
