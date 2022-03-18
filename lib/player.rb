require './lib/color.rb'

class Player
  include Color

  attr_accessor :color, :name, :checked

  def initialize(name)
    @name = name
    @color = set_color
    @checked = false
  end

  def set_color
    return WHITE if @name == 'Player 1'

    BLACK if @name == 'Player 2'
  end
end
