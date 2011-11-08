require 'rubygems'
require 'gosu'
$SCREEN_HEIGHT = 1200
$SCREEN_WIDTH = 1000
class GameWindow < Gosu::Window
  def initialize
    super $SCREEN_WIDTH, $SCREEN_HEIGHT, false
    @road_tiles = Gosu::Image.load_tiles(self, "resources/road.png", 100, 100, false)
    @this_row = []
    @all_rows = []
    @current_tile = 0
    
    (0..1000).each do |index|  
      row_gen
      @all_rows.push(@this_row)
    end
    @y_offset = 0

    @y_iterator = 0
    @x_iterator = 0 
  end
  
  def update
    # TODO: Get keyboard input
  end
  
  def draw
    @all_rows.each do |row|
      row.reverse!
      puts row.join(" ")
      
      row.each do |tile|
        @road_tiles[tile].draw(@x_iterator, @y_iterator + @y_offset, 0)
        if @x_iterator == 900
          @x_iterator = 0
        else
          @x_iterator = @x_iterator + 100
        end
        
      end
      
      @y_iterator = @y_iterator + 100
    end
    # @y_offset += 10
    
    
  end
  
  def row_gen
    (0..9).each do |index|
      @this_row[index] = @current_tile
      @current_tile = right_generator(@current_tile)
    end
  end
      
    
  
  def right_generator(tile_no)
    next_try = rand(8)
    case tile_no
    when 0
      good_list = [0,4,6]
    when 1
      good_list = [1,2,5,7]
    when 2 
      good_list = [0, 4, 6]
    when 3
      good_list = [1,5,7]
    when 4
      good_list = [1,2]
    when 5
      good_list = [0, 6]
    when 6
      good_list = [1,2]
    when 7
      good_list = [0, 6]
    end
    if good_list.include?(next_try)
      return next_try
    else
      right_generator(tile_no)
    end
  end
  
end


if __FILE__ == $0
  window = GameWindow.new
  window.show
end
