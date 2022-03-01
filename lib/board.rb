require './lib/field.rb'
require './lib/pieces/pawn.rb'
require './lib/field_filler.rb'
require './lib/move_validator.rb'
require './lib/pieces/red_dot.rb'

class Board
  include FieldFiller
  include MoveValidator

  attr_accessor :board, :root

  def initialize
    @root = Field.new([0, 0])
    @board = create_board
    @walkable_fields = []
  end

  def print_board
    root = @root
    root = root.top_field until root.top_field.nil?
    (0..7).reverse_each do |i|
      print "#{i} "
      print_row(root)
      print "\n"
      root = root.bottom_field
    end
    print "   a   b   c   d   e   f   g   h\n"
  end

  def print_row(root = @root)
    until root.nil?
      print_field(root)
      root = root.right_field
    end
  end

  def print_field(field)
    piece = ' '
    piece = field.piece.model unless field.piece.nil? || !field.piece <=> RedDot
    color = field.color unless field.capturable
    color = '41' if field.capturable
    print "\e[#{color}m #{piece}  \e[0m"
  end

  def create_board
    connect_columns
    connect_rows
    fill_board
  end

  def create_column(prior_field, column, count = 0, first_root = nil)
    return nil if count == 8

    root = Field.new([count, column]) if first_root.nil?
    root = first_root unless first_root.nil?
    root.bottom_field = prior_field
    root.top_field = create_column(root, column, count + 1, nil)
    root
  end

  def connect_columns
    root = @root
    8.times do |i|
      create_column(nil, i, 0, root)
      next if i == 7

      root.right_field = Field.new([0, i + 1])
      left_field = root
      root = root.right_field
      root.left_field = left_field
    end
  end

  def connect_left_right(left_column)
    root = left_column
    return if root.right_field.nil?

    until root.top_field.nil?
      left = root.top_field
      right = root.right_field.top_field
      left.right_field = right
      right.left_field = left
      root = root.top_field
    end
  end

  def connect_rows
    root = @root
    until root.right_field.nil?
      connect_left_right(root)
      root = root.right_field
    end
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
    delete_walkable_fields
    possible_moves = walkable_fields(start_field)
    if possible_moves.include?(destination_field) && !destination_field.nil?
      destination_field.piece = start_field.piece
      start_field.piece = nil
      destination_field.piece.moved = true if destination_field.piece.class <= Pawn
    else
      'error'
    end
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

  def putting_check?(color)
    team = find_all_team_pieces(color)
    team.each do |piece_field|
      possible_moves = walkable_fields(piece_field)
      possible_moves.each do |move|
        if move.piece.class <= King
          if move.piece.color != color
            return true
          end
        end
      end
    end
    false
  end

  def delete_walkable_fields
    @walkable_fields.each do |e|
      e.capturable = false
      e.piece = nil if e.piece.class <= RedDot
    end
    @walkable_fields = []
  end
end
