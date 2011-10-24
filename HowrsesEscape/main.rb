require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 1280, 1024, false
    self.caption = "The Howses Escape"
  end
end

window = GameWindow.new
window.show