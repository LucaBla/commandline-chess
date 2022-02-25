require './lib/pieces/piece.rb'

class Pawn < Piece
  attr_reader :model

  def initialize
    super
    @model = "\u265f"
    @moved = false
  end

  def moves
    top = 1
    top = [1, 2] if @moved == false

    { top: top, bottom: 0, left: 0, right: 0 }
  end
end

class BlackPawn < Pawn
  def initialize
    super
    @model = "\e[30m\u265f"
  end
end

class WhitePawn < Pawn
  def initialize
    super
    @model = "\u265f"
  end
end
