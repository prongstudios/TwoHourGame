require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 1280, 1024, false
    self.caption = "The Howses Escape"
    @background_tiles = Gosu::Image.load_tiles(self, "media/background.png", 100, 100, true)
  end
end

window = GameWindow.new
window.show