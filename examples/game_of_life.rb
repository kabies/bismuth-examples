require 'bismuth'

class GameOfLifeExample < Bi::Scene

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }

    # game of life
    grid_width = 10
    birth = [3]
    death = [0,1,4,5,6,7,8]
    @grid = [
    # 2 3 4 5 6 7 8 9 10
    0,0,0,0,0,0,0,0,0,0, # 1
    0,1,1,1,0,0,0,0,0,0, # 2
    0,1,0,0,0,0,0,0,0,0, # 3
    0,0,1,0,0,0,0,0,0,0, # 4
    0,0,0,0,0,0,0,0,0,0, # 5
    0,0,0,0,0,0,0,0,0,0, # 6
    0,0,0,0,0,0,0,0,0,0, # 7
    0,0,0,0,0,0,1,1,1,0, # 8
    0,0,0,0,0,0,1,0,0,0, # 9
    0,0,0,0,0,0,0,1,0,0, # 10
    ]

    @nodes = 10.times.map{|x|
      10.times.map{|y|
        n = Bi::Node.new(x*32,y*32,32,32)
        n.set_color 0xFF,0xFF,0xFF,0xFF
        add_child n
        n
      }
    }.flatten

    add_timer(500){
      @grid = CellularAutomaton.step(@grid,grid_width,birth,death,true)
      @grid.each.with_index{|g,i|
        if g == 0
          @nodes[i].set_color 0xFF,0xFF,0xFF
        else
          @nodes[i].set_color 0,0,0
        end
      }
    }
  end

end

Bi::System.init(debug:true)
Bi::Window.make_window(320,320)
Bi::RunLoop.instance.run_with_scene GameOfLifeExample.new
