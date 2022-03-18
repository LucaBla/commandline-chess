require './lib/pieces/piece.rb'
require './lib/color.rb'

class Pawn < Piece
  include Color

  attr_accessor :moved, :moves, :en_passant
  attr_reader :model, :color

  def initialize
    super
    @model = "\u265f"
    @moved = false
    @moves = {}
    @en_passant = false
  end
end

class BlackPawn < Pawn
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265f"
  end
end

class WhitePawn < Pawn
  def initialize
    super
    @color = WHITE
    @model = "\u265f"
  end
end
