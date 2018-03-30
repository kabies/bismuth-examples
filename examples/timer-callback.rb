require 'bismuth'

class TimerCallbackSample < Bi::Scene

  def initialize
    super

    @text_a = Bi::TextSprite.new("Callback A", size:32, color:[0xFF,0,0] )
    @text_b = Bi::TextSprite.new("Callback B", size:32, color:[0,0xFF,0] )
    @text_c = Bi::TextSprite.new("Callback C", size:32, color:[0,0,0xFF] )

    add_child @text_a
    add_child @text_b
    add_child @text_c

    @text_a.x, @text_a.y = 100,200
    @text_b.x, @text_b.y = 100,300
    @text_c.x, @text_c.y = 100,400

    Bi::RunLoop.add_timer(1000){
      @text_a.x, @text_a.y = rand(self.w), rand(self.h)
      puts "#{Time.now} A: #{@text_a.x},#{@text_a.y}"
    }

    Bi::RunLoop.add_timer(500){
      @text_b.x, @text_b.y = rand(self.w), rand(self.h)
      puts "#{Time.now} B: #{@text_b.x},#{@text_b.y}"
    }

    Bi::RunLoop.add_timer(2000, repeat:false){
      @text_c.x, @text_c.y = rand(self.w), rand(self.h)
      puts "#{Time.now} C: #{@text_c.x},#{@text_c.y}"
    }
  end

end

Bi::System.init font:"NotoMono-Regular.ttf"
Bi::Window.make_window 640,480
Bi::RunLoop.instance.run_with_scene TimerCallbackSample.new
