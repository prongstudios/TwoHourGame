require 'rubygems'
require 'gosu'

$debug = false
$SCREEN_HEIGHT = 1200
$SCREEN_WIDTH = 1000
class GameWindow < Gosu::Window
  def initialize
    super $SCREEN_WIDTH, $SCREEN_HEIGHT, false
    @howrse = Howrse.new(self)
    @wrangler = Wrangler.new(self)

    @y_offset = 1
    self.caption = "The Howses Escape"
    @background_tiles = Gosu::Image.load_tiles(self, "media/background.png", 200, 200, true)
    @howrse_tiles = Gosu::Image.load_tiles(self, "media/howrse.png", 200, 200, false)
    @font = Gosu::Font.new(self, "giddyup", 50)
    @obstacles = []
    @powerups = []
    rand(12).times do
      @obstacles.push(Obstacle.new(self, rand(12) * rand(10) * 200, Gosu::Image.load_tiles(self, "media/obstacles.png", 200, 200, false)))
      @powerups.push(Powerup.new(self, rand(12) * rand(10) * 200, Gosu::Image.load_tiles(self, "media/powerup.png", 200, 200, false)))
      
    end
    @map = [[1,1,2,1,1,1],[1,2,1,2,1,2]]
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
    @y_iterator = 000 
    @x_iterator = 0
    @map.each do |row|
      if $debug
         puts row
      end
      row.each do |tile|
        @background_tiles[tile-1].draw(@x_iterator, @y_iterator,0)
        if $debug
          puts tile 
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
    
    # @map.each do |row|
    #   row.each do |tile|
    #     @background_tiles[tile-1].draw(@x_iterator, @y_iterator,0)
    #   end
    #   if @x_iterator == 800
    #     @x_iterator = 0 
    #   else
    #     @x_iterator += 200
    #   end
    # end
    @howrse.draw
    @wrangler.draw
    @obstacles.each do |obstacle|
      obstacle.draw(10)
    end
    @powerups.each do |powerup|
      powerup.draw(10)
    end
    @y_offset += 10
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
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
      @howrse_tiles[1].draw(@x, @y, 2, 1.2, 1.2)
      
    else
      @howrse_tiles[0].draw(@x, @y, 2)
      
    end
    @jumping = false
  end
  def move_right
    @x += 10
    if @x >= $SCREEN_WIDTH - 100
      @x = $SCREEN_WIDTH - 100
    end
  end
  def move_left
    @x -= 10
    if @x <= -100
      @x = -100
    end
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

class Obstacle
  attr_accessor :x, :y
  def initialize(window, y_up ,tileset)
    @image = tileset[rand(2)]
    @x = rand(1000)
    @y = -200 - y_up
  end
  def draw(speed)
    @y += speed
    @image.draw(@x, @y, 1)
  end
end

class Powerup
  attr_accessor :x, :y
  def initialize(window, y_up ,tileset)
    @image = tileset[0]
    @x = rand(1000)
    @y = -200 - y_up
  end
  def draw(speed)
    @y += speed
    @image.draw(@x, @y, 1, 0.5, 0.5)
  end
end


    

if __FILE__ == $0
  window = GameWindow.new
  window.show
end
