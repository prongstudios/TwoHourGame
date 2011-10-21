require "rubygems"
require "gosu"
require "./Timer.rb"

$found = 0


class Obstacle
  def initialize(window, image, x, y)
    @image = image
    @x = x
    @y = y 
  end
  
  def draw
    @image.draw_rot(@x, @y, 5, 0.0)
  end
end
    
class Egg
  def initialize(window, image, x, y)
    @image = image
    @chirp = Gosu::Sample.new(window, "media/sounds/chirp.wav")
    @x, @y = x,y
    @unfound = true
  end
  
  def chirp(x,y)
    if rand(120) == 30 and @unfound then
      pan = (540.0/x)-1.0
      vol = ((1000-(Gosu::distance(x, y, @x, @y)))/1000.0)-0.5
      # For debugging
      # puts "Volume: #{vol} Distance: #{Gosu::distance(x, y, @x, @y)}"
      @chirp.play(vol)
    end
  end
  
  def draw
    if @unfound then
      # @image.draw_rot(@x, @y, 1, 0.0)
    else
      @image.draw_rot(@x, @y, 11, 0.0)
    end
  end
  
  def try(x,y)
    if Gosu::distance(@x, @y, x, y) < 100 and @unfound
      @unfound = false
      $found += 1
    end
  end
end
    

class Player
  attr_accessor :x, :y, :score
  def initialize(window, image)
    @image = image
    @score = 60000
    @x = @y = @vel_x = @vel_y = @angle = 0.0
  end
  
  def warp(x,y)
    @x, @y = x,y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 6.5)
    @vel_y += Gosu::offset_y(@angle, 6.5)
  end
  
  def deccelerate
    @vel_x -= Gosu::offset_x(@angle, 3.5)
    @vel_y -= Gosu::offset_y(@angle, 3.5)
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 1000
    @y %= 1000
    
    @vel_x *= 0.0
    @vel_y *= 0.0
  end
  
  def draw
    @image.draw_rot(@x, @y, 2, @angle)
  end
  
end

class GameWindow < Gosu::Window
  def initialize
    super 1000, 1000, false
    self.caption = "Finding the chix"
    @curtime = 0
    @characters = Gosu::Image.load_tiles(self, "media/characters.png", 100, 100, false)
    @background_image = Gosu::Image.load_tiles(self, "media/terrain.png", 100, 100, true)
    @obstacle_images = Gosu::Image.load_tiles(self, "media/obstacles.png", 100, 100, false)
    @timer = Timer.new
    @font = Gosu::Font.new(self, "monospace", 50)
    @player = Player.new(self, @characters[1])
    @eggs = []
    @obstacles = []
    3.times do
      x = (rand(10)*100)+50
      y = (rand(10)*100)+50
      @eggs.push Egg.new(self, @characters[0], x, y)
      @obstacles.push Obstacle.new(self, @obstacle_images[rand(2)], x, y)
    end
    7.times do
      x = (rand(10)*100)+50
      y = (rand(10)*100)+50
      @obstacles.push Obstacle.new(self, @obstacle_images[rand(2)], x, y)
    end
      

    @player.warp(320, 240)
  end
  
  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    if button_down? Gosu::KbDown
      @player.deccelerate
    end
    if button_down? Gosu::KbSpace then
      starting = @found
      (0..2).each do |egg|
        @eggs[egg].try(@player.x, @player.y)
      end
      if @found == starting
        @player.score -= 500
      end
    end
    

    @player.move
    
    
    
  end
  
  def draw
    @player.draw
    (0..2).each do |egg|
      @eggs[egg].draw
      @eggs[egg].chirp(@player.x, @player.y)
    end
    @obstacles.each do |obstacle|
      obstacle.draw
    end
    poop = (0..12)
    poop.each do |pewpx|
      poop.each do |pewpy|
        @background_image[1].draw(pewpx*100, pewpy*100, 0);
      end
    end
    if $found == 3
      @font.draw("Congratulations! You've found all the chicks!", 50, 400, 20)
      
    end
    if $found < 3 
      @player.score -= 1000/60
      @curtime = (60 - (@timer.passed).round) 
    end

    @font.draw("Time remaining: #{@curtime}                         Score: #{@player.score}", 0, 0, 16)
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
  
    
  
end

window = GameWindow.new
window.show
