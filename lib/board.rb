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

  # at the moment only working for pawn, and made only for pawn
  def move_piece(start_field, destination_field)
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
end

b = Board.new
# p b.board.top_field.coordinate
# p b.root.right_field.right_field.right_field.right_field.right_field.right_field.right_field
print b.root.right_field
# b.print_board
b.move_piece(b.find_field([1, 1]), b.find_field([3, 1]))
b.move_piece(b.find_field([1, 3]), b.find_field([3, 3]))
b.move_piece(b.find_field([6, 0]), b.find_field([4, 0]))
b.move_piece(b.find_field([6, 2]), b.find_field([4, 2]))

b.find_field([1, 0]).piece = nil
p b.move_piece(b.find_field([0, 0]), b.find_field([2, 0]))
p b.move_piece(b.find_field([2, 0]), b.find_field([2, 3]))
p b.move_piece(b.find_field([2, 3]), b.find_field([2, 7]))
p b.move_piece(b.find_field([2, 7]), b.find_field([6, 7]))
p b.move_piece(b.find_field([6, 7]), b.find_field([7, 7]))
p b.move_piece(b.find_field([7, 7]), b.find_field([7, 5]))

p b.move_piece(b.find_field([7, 0]), b.find_field([5, 0]))
p b.move_piece(b.find_field([5, 0]), b.find_field([5, 5]))
p b.move_piece(b.find_field([5, 5]), b.find_field([5, 4]))
p b.move_piece(b.find_field([5, 4]), b.find_field([0, 4]))

# p b.move_piece(b.find_field([0, 2]), b.find_field([2, 4]))
# p b.move_piece(b.find_field([2, 4]), b.find_field([4, 2]))

p b.move_piece(b.find_field([0, 3]), b.find_field([0, 2]))
p b.move_piece(b.find_field([0, 2]), b.find_field([1, 1]))

p b.move_piece(b.find_field([0, 4]), b.find_field([2, 2]))
p b.move_piece(b.find_field([2, 2]), b.find_field([4, 2]))

p b.move_piece(b.find_field([6, 5]), b.find_field([4, 5]))
p b.move_piece(b.find_field([6, 1]), b.find_field([5, 1]))

p b.move_piece(b.find_field([1, 4]), b.find_field([2, 4]))
p b.move_piece(b.find_field([3, 3]), b.find_field([4, 3]))
p b.move_piece(b.find_field([1, 7]), b.find_field([2, 7]))

# b.show_walkable_fields(b.find_field([0, 1]))
p b.move_piece(b.find_field([0, 6]), b.find_field([2, 5]))
b.show_walkable_fields(b.find_field([2, 5]))

# b.show_walkable_fields(b.find_field([1, 5]))
# b.print_board
# puts
# b.show_walkable_fields(b.find_field([4, 0]))
# b.show_walkable_fields(b.find_field([7, 2]))
# b.show_walkable_fields(b.find_field([5, 4]))

# b.move_piece(b.find_field([7, 5]), b.find_field([7, 3]))
# b.move_piece(b.find_field([3, 0]), b.find_field([4, 0]))
# b.move_piece(b.find_field([4, 2]), b.find_field([3, 3]))
# b.move_piece(b.find_field([3, 1]), b.find_field([4, 0]))
# b.move_piece(b.find_field([6, 1]), b.find_field([4, 1]))
# b.move_piece(b.find_field([3, 0]), b.find_field([4, 1]))
# b.move_piece(b.find_field([4, 1]), b.find_field([3, 0]))
b.print_board
# b.delete_walkable_fields
# puts
# b.print_board
# p b.find_field([7, 7]).coordinate
# p b.root.top_field.right_field.top_field.left_field.coordinate
# puts b.board
