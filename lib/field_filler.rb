# frozen_string_literal: true

require './lib/pieces/rook'
require './lib/pieces/knight'
require './lib/pieces/bishop'
require './lib/pieces/king'
require './lib/pieces/queen'

# Module that contains Methods that fill the Field
module FieldFiller
  def fill_board
    fill_pawns
    fill_rooks
    fill_knights
    fill_bishops
    fill_king
    fill_queen
  end

  def fill_pawns
    root = @root.top_field
    until root.nil?
      root.piece = WhitePawn.new
      root = root.right_field
    end
    root = @root
    root = root.top_field until root.top_field.nil?
    root = root.bottom_field
    until root.nil?
      root.piece = BlackPawn.new
      root = root.right_field
    end
  end

  def fill_rooks
    @root.piece = WhiteRook.new
    find_field([0, 7]).piece = WhiteRook.new

    find_field([7, 0]).piece = BlackRook.new
    find_field([7, 7]).piece = BlackRook.new
  end

  def fill_knights
    find_field([0, 1]).piece = WhiteKnight.new
    find_field([0, 6]).piece = WhiteKnight.new

    find_field([7, 1]).piece = BlackKnight.new
    find_field([7, 6]).piece = BlackKnight.new
  end

  def fill_bishops
    find_field([0, 2]).piece = WhiteBishop.new
    find_field([0, 5]).piece = WhiteBishop.new

    find_field([7, 2]).piece = BlackBishop.new
    find_field([7, 5]).piece = BlackBishop.new
  end

  def fill_king
    find_field([0, 4]).piece = WhiteKing.new

    find_field([7, 4]).piece = BlackKing.new
  end

  def fill_queen
    find_field([0, 3]).piece = WhiteQueen.new

    find_field([7, 3]).piece = BlackQueen.new
  end
end
