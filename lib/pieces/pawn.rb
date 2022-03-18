# frozen_string_literal: true

require './lib/pieces/piece'
require './lib/color'

# Pawn Class
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

# Black Pawn Class
class BlackPawn < Pawn
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265f"
  end
end

# White Pawn Class
class WhitePawn < Pawn
  def initialize
    super
    @color = WHITE
    @model = "\u265f"
  end
end
