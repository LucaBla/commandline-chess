require './lib/pieces/piece.rb'

class Rook < Piece
  attr_reader :model

  def initialize
    @model = "\u265c"
  end
end

class BlackRook < Rook
  def initialize
    @model = "\e[30m\u265c"
  end
end

class WhiteRook < Rook
  def initialize
    @model = "\u265c"
  end
end
