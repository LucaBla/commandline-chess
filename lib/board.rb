require './lib/field.rb'
require './lib/pieces/pawn.rb'
require './lib/field_filler.rb'

class Board
  include FieldFiller

  attr_accessor :board, :root

  def initialize
    @root = Field.new([0, 0])
    @board = create_board
  end

  def print_board
    root = @root
    root = root.top_field until root.top_field.nil?
    8.times do
      print_row(root)
      print "\n"
      root = root.bottom_field
    end
  end

  def print_row(root = @root)
    until root.nil?
      print_field(root)
      root = root.right_field
    end
  end

  def print_field(field)
    piece = ' '
    piece = field.piece.model unless field.piece.nil?
    print "\e[#{field.color}m #{piece}  \e[0m"
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
    until count == 9
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

  def move_piece(start_field, destination_field)
    destination_field.piece = start_field.piece
    start_field.piece = nil
  end
end

b = Board.new
# p b.board.top_field.coordinate
# p b.root.right_field.right_field.right_field.right_field.right_field.right_field.right_field
print b.root.right_field
# b.print_board
b.move_piece(b.find_field([1, 0]), b.find_field([2, 0]))
b.print_board
# p b.find_field([7, 7]).coordinate
# p b.root.top_field.right_field.top_field.left_field.coordinate
# puts b.board
