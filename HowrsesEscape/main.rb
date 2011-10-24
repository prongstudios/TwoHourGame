require 'rubygems'
require 'gosu'

@debug = true

class GameWindow < Gosu::Window
  def initialize
    super 1000, 1200, false
    self.caption = "The Howses Escape"
    @background_tiles = Gosu::Image.load_tiles(self, "media/background.png", 200, 200, true)
    @howrse_tiles = Gosu::Image.load_tiles(self, "media/howrse.png", 200, 200, true)
    @font = Gosu::Font.new(self, "giddyup", 50)
    @map = [[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1]]
  end
  
  def draw
    @font.draw("HOWRSE! ESCAPE!", 50, 400, 20)
    @draw1 = 0
    @draw2 = 0
    @map.each do |row|
      if @debug
        puts row
      end
      row.each do |tile|
        @background_tiles[tile-1].draw(@draw2, @draw1,0)
        if @debug
          puts tile 
          puts "#{draw1} x #{draw2}"
        end
        @draw1 += 200
      end
      @draw2 += 200
    end
    
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show