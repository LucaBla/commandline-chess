require './lib/pieces/piece.rb'

class Rook < Piece
  attr_reader :model

  def initialize
    super
    @model = "\u265c"
    @moves = { top_left: [0], top: (1..7).to_a, top_right: [0],
               bottom_left: [0], bottom: (1..7).to_a, bottom_right: [0], left: (1..7).to_a, right: (1..7).to_a }
  end
end

class BlackRook < Rook
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265c"
  end
end

class WhiteRook < Rook
  def initialize
    super
    @color = WHITE
    @model = "#{@color}\u265c"
  end
end
