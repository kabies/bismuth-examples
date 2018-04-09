require 'bismuth'

class CaveGeneratorExample < Bi::Scene
  WALL=[0x18,0x01,0x0d,0xFF]
  FLOOR=[0x64,0x4d,0x37,0xFF]

  def initialize
    super
    add_timer(1000){ Bi::Window.title = "FPS:#{Bi::RunLoop.fps}" }

    grid_width = 48
    grid_height = 48
    birth = [5,6,7,8]
    death = [0,1,2,3]

    srand(Time.now.to_i)
    @step = rand(8..12)
    @grid = (grid_width*grid_height).times.map{ rand(100)<50?0:1 }
    grid_width.times{|x| @grid[0+x] = @grid[(grid_height-1)*grid_width+x] = 0 }
    grid_height.times{|y| @grid[grid_width*y+0] = @grid[grid_width*y+grid_width-1] = 0 }

    @nodes = grid_width.times.map{|x|
      grid_height.times.map{|y|
        n = Bi::Node.new(x*4,y*4,4,4)
        if @grid[y*grid_width+x] == 0
          n.set_color(*WALL)
        else
          n.set_color(*FLOOR)
        end
        add_child n
        n
      }
    }.flatten

    add_timer(800){
      next if @step <= 0
      puts "#{Time.now} step:#{@step}"
      @step -= 1
      @grid = CellularAutomaton.step(@grid,grid_width,birth,death,true)
      grid_width.times{|x| @grid[0+x] = @grid[(grid_height-1)*grid_width+x] = 0 }
      grid_height.times{|y| @grid[grid_width*y+0] = @grid[grid_width*y+grid_width-1] = 0 }

      @grid.each.with_index{|g,i|
        if g == 0
          @nodes[i].set_color(*WALL)
        else
          @nodes[i].set_color(*FLOOR)
        end
      }
    }
  end

end

Bi::System.init(debug:true)
Bi::Window.make_window(192,192)
Bi::RunLoop.instance.run_with_scene CaveGeneratorExample.new
