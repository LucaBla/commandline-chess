require './lib/board.rb'
require './lib/player.rb'
require './lib/game_ending_conditions.rb'

class Game
  include GameEndingConditions

  attr_accessor :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new('Player 1')
    @player2 = Player.new('Player 2')
  end

  def play_round(current_player = player1)
    until gameover?(current_player) == true
      play_turn(current_player)
      if current_player == player1
        current_player = player2
      else
        current_player = player1
      end
    end
    puts gameover?(current_player)
  end

  def play_turn(player)
    @board.remove_en_passant(player)
    input = player_input(player, 'piece')
    @board.show_walkable_fields(input)
    @board.print_board
    destination = player_input(player, 'destination', input)
    @board.move_piece(@board.find_field(input), @board.find_field(destination))
    looking_for_check(input, destination, player)
    @board.print_board
    promote(player, destination) if promotion?(player, destination)
  end

  def player_input(player, type, start = nil)
    puts "#{player.name} pls enter the Piece you want to move: (like a1 or h7)" if type == 'piece'
    puts "#{player.name} pls enter your destination: (like a1 or h7)" if type == 'destination'
    input = gets.chomp
    return player_input(player, type) if input.length != 2 || !('a'..'h').include?(input[0]) || !('0'..'7').include?(input[1])

    input = refactor_input(input)
    allowed_field?(input, player, type, start)
  end

  def refactor_input(input)
    move = []
    move.push(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].index(input[0]))
    move.push(input[1].to_i)
    move.reverse
  end

  def allowed_field?(input, player, type, start = nil)
    return player_input(player, type) if type == 'piece' &&
                                         (@board.find_field(input).piece.nil? ||
                                          @board.find_field(input).piece.color != player.color ||
                                          @board.walkable_fields(@board.find_field(input)).empty?)

    return player_input(player, type, start) if type == 'destination' &&
                                                (@board.walkable_fields(@board.find_field(start)).empty? ||
                                                !@board.walkable_fields(@board.find_field(start)).include?(@board.find_field(input)))

    input
  end

  def undo_move(start, destination, player)
    @board.force_move(@board.find_field(destination), @board.find_field(start))
    puts 'cant do that or you would be check-mate!'
    if player == @player1
      player = @player2
    else
      player = @player1
    end
    @board.find_field(destination).piece = @board.last_deleted_piece
    @board.find_field(start).piece.moved = false if (start[0] == 1 && @board.find_field(start).piece.class == WhitePawn) ||
                                                    (start[0] == 6 && @board.find_field(start).piece.class == BlackPawn)
    play_turn(player)
  end

  def promotion?(player, field)
    field = @board.find_field(field)
    player.color == WHITE ? needed_field = 7 : needed_field = 0
    return true if field.coordinate[0] == needed_field && field.piece.class <= Pawn

    false
  end

  def promote(player, field)
    field = @board.find_field(field)
    player.color == WHITE ? color = 'White' : color = 'Black'
    promotion_ui
    input = gets.chomp.to_i
    return promote(player, field.coordinate) unless [1, 2, 3, 4].include?(input)

    field.piece = Object.const_get(promotion_get_class(input, color)).new
  end

  def promotion_ui
    puts 'You can promote your Pawn pls select to which Piece you want to promote him:'
    puts 'Queen = 1'
    puts 'Rook = 2'
    puts 'Knight = 3'
    puts 'Bishop = 4'
  end

  def promotion_get_class(input, color)
    case input
    when 1
      piece = "#{color}Queen"
    when 2
      piece = "#{color}Rook"
    when 3
      piece = "#{color}Knight"
    when 4
      piece = "#{color}Bishop"
    end
    piece
  end
end

g = Game.new
# g.board.move_piece(g.board.find_field([1, 0]), g.board.find_field([2, 0]))
# g.board.move_piece(g.board.find_field([1, 0]), g.board.find_field([2, 0]))
# a = g.board.find_all_team_pieces(BLACK)
# a.each { |e| e.piece = nil unless e.piece.class <= King || e.piece.class <= Queen }

# b = g.board.find_all_team_pieces(WHITE)
# b.each { |e| e.piece = nil if e.piece.class <= Pawn }

# g.board.force_move(g.board.find_field([7, 3]), g.board.find_field([6, 3]))
# g.board.force_move(g.board.find_field([0, 0]), g.board.find_field([7, 0]))
# g.board.force_move(g.board.find_field([0, 7]), g.board.find_field([5, 7]))
# g.board.force_move(g.board.find_field([0, 4]), g.board.find_field([1, 4]))

# g.board.find_field([7, 4]).piece = nil
# g.board.find_field([5, 4]).piece = WhitePawn.new
# g.board.find_field([1, 0]).piece = WhitePawn.new
# g.board.find_field([5, 3]).piece = BlackQueen.new
# g.board.find_field([2, 1]).piece = BlackPawn.new

# puts g.board.walkable_fields(g.board.find_field([1, 4]))

g.board.print_board
g.play_round
# p g.board.find_field([8, 8])
