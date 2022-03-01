require './lib/board.rb'
require './lib/player.rb'

class Game
  attr_accessor :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new('Player 1')
    @player2 = Player.new('Player 2')
  end

  def play_round(current_player = player1)
    until gameover?
      play_turn(current_player)
      if current_player == player1
        current_player = player2
      else
        current_player = player1
      end
    end
  end

  def play_turn(player)
    input = player_input(player, 'piece')
    @board.show_walkable_fields(input)
    @board.print_board
    destination = player_input(player, 'destination', input)
    @board.move_piece(@board.find_field(input), @board.find_field(destination))
    looking_for_check(input, destination, player)
    @board.print_board
  end

  def set_player_check(current_player)
    puts "ATATATATATATATATAT"
    return @player2.checked = true if current_player == @player1

    @player1.checked = true
  end

  def player_input(player, type, start = nil)
    puts "#{player.name} pls enter the Piece you want to move: (like a1 or h7)" if type == 'piece'
    puts "#{player.name} pls enter your destination: (like a1 or h7)" if type == 'destination'
    input = gets.chomp
    return player_input(player, type) if input.length != 2 || !('a'..'h').include?(input[0]) || !('0'..'7').include?(input[1])

    input = refactor_input(input)
    allowed_field?(input, player, type, start)
    input
  end

  def refactor_input(input)
    move = []
    move.push(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].index(input[0]))
    move.push(input[1].to_i)
    move.reverse
  end

  def allowed_field?(move, player, type, start = nil)
    return player_input(player, type) if (@board.find_field(move).piece.nil? ||
    @board.find_field(move).piece.color != player.color ||
    @board.walkable_fields(@board.find_field(move)).empty?) &&
    type == 'piece'

    return player_input(player, type) if !@board.walkable_fields(@board.find_field(start)).nil? && !@board.walkable_fields(@board.find_field(start)).empty? && !@board.walkable_fields(@board.find_field(start)).include?(move) && type == 'destination'    
  end

  def looking_for_check(start, destination, player)
    set_player_check(player) if @board.putting_check?(player.color)
    if player == @player1
      player = @player2
    else
      player = @player1
    end
    return undo_move(start, destination, player) if @board.putting_check?(player.color)
  end

  def undo_move(start, destination, player)
    # dosent work for pawns
    @board.move_piece(@board.find_field(destination), @board.find_field(start))
    puts 'cant do that or you would be check!'
    if player == @player1
      player = @player2
    else
      player = @player1
    end
    play_turn(player)
  end

  def gameover?
    return true if 'a' == 'b'

    false
  end
end

g = Game.new
g.board.move_piece(g.board.find_field([1, 0]), g.board.find_field([2, 0]))
g.board.print_board
# puts g.board.find_all_team_pieces("\e[30m")
g.play_round
# p g.board.find_field([8, 8])
