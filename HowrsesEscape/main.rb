require 'rubygems'
require 'gosu'

$debug = false
class GameWindow < Gosu::Window
  def initialize
    super 1000, 1200, false
    @howrse = Howrse.new(self)
    @wrangler = Wrangler.new(self)

    @y_offset = 1
    self.caption = "The Howses Escape"
    @background_tiles = Gosu::Image.load_tiles(self, "media/background.png", 200, 200, true)
    @howrse_tiles = Gosu::Image.load_tiles(self, "media/howrse.png", 200, 200, false)
    @font = Gosu::Font.new(self, "giddyup", 50)
    @map = [[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1],[1,1,1,1,1]]
  end
  
  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @howrse.move_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @howrse.move_right
    end
    if button_down? Gosu::KbSpace then
      @howrse.jumping = true
    end
  end
  
  def draw
    @font.draw("HOWRSE! ESCAPE!", 50, 400, 20)
    @y_iterator = 0 + @y_offset
    @x_iterator = 0
    @map.each do |row|
      if $debug
        # puts row
      end
      row.each do |tile|
        @background_tiles[tile-1].draw(@x_iterator, @y_iterator,0)
        if $debug
          # puts tile 
          puts "#{@y_iterator} x #{@x_iterator}"
        end
        if @y_iterator == 1000 + @y_offset
          @y_iterator = 0 + @y_offset
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
    @wrangler.draw
    @y_offset += 1
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
    if id == Gosu::KbSpace
      @howrse.jumping = true
    end
  end
end

class Howrse
  attr_accessor :x, :y, :score
  attr_writer :jumping
  def initialize(window)
    @howrse_tiles = Gosu::Image.load_tiles(window, "media/howrse.png", 200, 200, false)
    @x = 400
    @y = 600

  end
  def draw
    if @jumping
      @scale = 1.2
    else
      @scale = 1.0
    end
    @howrse_tiles[0].draw(@x, @y, 1, @scale, @scale)
    @jumping = false
  end
  def move_right
    @x += 10
    @x %= 1000  
  end
  def move_left
    @x -= 10
    @x %= 1000
  end

    
end

class Wrangler
  attr_accessor :x, :y
  def initialize(window)
    @wrangler_tiles = Gosu::Image.load_tiles(window, "media/wrangler.png", 200, 200, false)
    @x = 400
    @y = 1000
  end
  def draw
    @wrangler_tiles[0].draw(@x, @y, 2)
  end
end

if __FILE__ == $0
  window = GameWindow.new
  window.show
end
