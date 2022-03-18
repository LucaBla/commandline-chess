# frozen_string_literal: true

# Knight Class
class Knight < Piece
  attr_reader :model, :color

  def initialize
    super
    @model = "\u265e"
    @moves = { top_left: [0], top: [1, 2], top_right: [0],
               bottom_left: [0], bottom: [1, 2], bottom_right: [0], left: [2, 1], right: [2, 1] }
  end
end

# Black Knight Class
class BlackKnight < Knight
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265e"
  end
end

# White Knight Class
class WhiteKnight < Knight
  def initialize
    super
    @color = WHITE
    @model = "#{@color}\u265e"
  end
end
