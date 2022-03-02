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
    input = player_input(player, 'piece')
    @board.show_walkable_fields(input)
    @board.print_board
    destination = player_input(player, 'destination', input)
    @board.move_piece(@board.find_field(input), @board.find_field(destination))
    looking_for_check(input, destination, player)
    @board.print_board
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

  def set_player_check(current_player)
    puts "ATATATATATATATATAT"
    return @player2.checked = true if current_player == @player1

    @player1.checked = true
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

  def check_mate?(player)
    team = @board.find_all_team_pieces(player.color)
    king_field = team.select { |e| e if e.piece.class <= King }
    king_field = king_field[0]
    puts "checked: #{player.checked}"
    puts king_field
    puts "Empty: #{@board.walkable_fields(@board.find_field(king_field.coordinate)).empty?}"
    @board.checker.each { |e| puts e.coordinate }
    return true if player.checked == true && @board.walkable_fields(@board.find_field(king_field.coordinate)).empty? &&
                   !can_kick_checker?(player) && !can_move_between_checker?(player) && !@board.checker.empty?

    false
  end

  def can_kick_checker?(player)
    puts 'test'
    team = @board.find_all_team_pieces(player.color)
    team.each do |piece_field|
      possible_moves = @board.walkable_fields(piece_field)
      possible_moves.each do |move|
        if @board.checker.include?(move)
          @board.checker.delete(move)
          return true
        end
      end
    end
    false
  end

  def can_move_between_checker?(player)
    move_between = false
    team = @board.find_all_team_pieces(player.color)
    team.each do |piece_field|
      possible_moves = @board.walkable_fields(piece_field)
      possible_moves.each do |move|
        @board.force_move(piece_field, move) if move.piece.nil?
        color = WHITE if player.color == BLACK
        color = BLACK if player.color == WHITE
        move_between = true if @board.putting_check?(color) == false
        @board.force_move(move, piece_field) if piece_field.piece.nil?
      end
    end
    move_between
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
    play_turn(player)
  end

  def gameover?(player)
    return true if check_mate?(player) == true

    @board.checker = []
    false
  end
end

g = Game.new
g.board.move_piece(g.board.find_field([1, 0]), g.board.find_field([2, 0]))
# g.board.move_piece(g.board.find_field([1, 0]), g.board.find_field([2, 0]))
a = g.board.find_all_team_pieces(BLACK)
a.each { |e| e.piece = nil unless e.piece.class <= King || e.piece.class <= Queen }

b = g.board.find_all_team_pieces(WHITE)
b.each { |e| e.piece = nil if e.piece.class <= Pawn }

g.board.force_move(g.board.find_field([7, 3]), g.board.find_field([6, 3]))
g.board.force_move(g.board.find_field([0, 0]), g.board.find_field([7, 0]))
g.board.force_move(g.board.find_field([0, 7]), g.board.find_field([5, 7]))
g.board.force_move(g.board.find_field([0, 4]), g.board.find_field([1, 5]))

g.board.print_board
g.play_round
# p g.board.find_field([8, 8])
