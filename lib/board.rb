# frozen_string_literal: true

require './lib/field'
require './lib/pieces/pawn'
require './lib/create_board'
require './lib/field_filler'
require './lib/move_validator'
require './lib/en_passant'
require './lib/castling'
require './lib/pieces/red_dot'

# The Chessboard where the Game is played.
class Board
  include CreateBoard
  include FieldFiller
  include MoveValidator
  include EnPassant
  include Castling

  attr_accessor :board, :root, :last_deleted_piece, :checker

  def initialize
    @root = Field.new([0, 0])
    @board = create_board
    @walkable_fields = []
    @last_deleted_piece = nil
    @checker = []
  end

  def find_field(field_coordinates)
    root = @root
    count = 0
    until count == 8
      until root.nil?
        return root if root.coordinate == field_coordinates

        root = root.top_field
      end
      count += 1
      root = @root
      count.times do
        root = root.right_field
      end
    end
  end

  def find_all_team_pieces(color)
    team = []
    root = @root
    count = 0
    until count == 8
      until root.nil?
        team.push(root) if !root.piece.nil? && root.piece.color == color
        root = root.top_field
      end
      count += 1
      root = @root
      count.times do
        root = root.right_field
      end
    end
    team
  end

  def move_piece(start_field, destination_field)
    possible_moves = walkable_fields(start_field)
    if possible_moves.include?(destination_field) && !destination_field.nil?
      @last_deleted_piece = destination_field.piece
      force_move(start_field, destination_field)
      move_follow_ups(start_field, destination_field)
    else
      'error'
    end
  end

  def force_move(start_field, destination)
    destination.piece = start_field.piece
    start_field.piece = nil
  end

  def move_follow_ups(start_field, destination_field)
    piece_class = destination_field.piece.class
    kick_en_passant(destination_field.piece.color, destination_field) if piece_class <= Pawn
    castling_move_rook(start_field, destination_field) if piece_class <= King
    set_en_passant(start_field, destination_field) if piece_class <= Pawn
    destination_field.piece.moved = true if piece_class <= Pawn ||
                                            piece_class <= Rook ||
                                            piece_class <= King
  end

  def show_walkable_fields(start_field)
    start_field = find_field(start_field)
    return 'error' if start_field.piece.nil?

    possible_moves = walkable_fields(start_field)
    possible_moves.each do |e|
      e.capturable = true unless e.piece.nil?
      e.piece = RedDot.new if e.piece.nil?
      @walkable_fields.push(e)
    end
  end

  def delete_walkable_fields
    @walkable_fields.each do |e|
      e.capturable = false
      e.piece = nil if e.piece.class <= RedDot
    end
    @walkable_fields = []
  end

  def putting_check?(color, check = false)
    team = find_all_team_pieces(color)
    team.each do |piece_field|
      possible_moves = walkable_fields(piece_field)
      possible_moves.each do |move|
        if move.piece.class <= King && move.piece.color != color
          @checker.push(piece_field)
          check = true
        end
      end
    end
    check
  end
end
