require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 1000, 1200, false
    @howrse = Howrse.new(self)
    @debug = true
    @y_velocity = 10
    self.caption = "The Howses Escape"
    @background_tiles = Gosu::Image.load_tiles(self, "media/background.png", 200, 200, true)
    @howrse_tiles = Gosu::Image.load_tiles(self, "media/howrse.png", 200, 200, false)
    @font = Gosu::Font.new(self, "giddyup", 50)
    @map = [[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1]]
  end
  
  def draw
    @font.draw("HOWRSE! ESCAPE!", 50, 400, 20)
    @y_iterator = 0
    @x_iterator = 0
    @map.each do |row|
      if @debug
        # puts row
      end
      row.each do |tile|
        @background_tiles[tile-1].draw(@x_iterator, @y_iterator,0)
        if @debug
          # puts tile 
          puts "#{@y_iterator} x #{@x_iterator}"
        end
        if @y_iterator == 1000
          @y_iterator = 0
        else
          @y_iterator += 200
        end
      end
      if @x_iterator == 800
        @x_iterator = 0 
      else
        @x_iterator += 200
      end
    end
    @howrse.draw
    
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

class Howrse
  attr_accessor :x, :y, :score
  def initialize(window)
    @howrse_tiles = Gosu::Image.load_tiles(window, "media/howrse.png", 200, 200, false)
    @x = 400
    @y = 1000
  end
  def draw
    @howrse_tiles[0].draw(@x, @y, 1)
  end
end

if __FILE__ == $0
  window = GameWindow.new
  window.show
end
