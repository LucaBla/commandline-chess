# frozen_string_literal: true

# King Class
class King < Piece
  attr_accessor :moved
  attr_reader :model, :color

  def initialize
    super
    @model = "\u265a"
    @moves = { top_left: [1], top: [1], top_right: [1],
               bottom_left: [1], bottom: [1], bottom_right: [1], left: [1], right: [1] }
    @moved = false
  end
end

# Black King Class
class BlackKing < King
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265a"
  end
end

# White King Class
class WhiteKing < King
  def initialize
    super
    @color = WHITE
    @model = "#{@color}\u265a"
  end
end
