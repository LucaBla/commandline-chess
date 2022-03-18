# frozen_string_literal: true

require './lib/color'

# Contains the Methods that controls if the gameover conditions are meet
module GameEndingConditions
  include Color

  def gameover?(player)
    return true if check_mate?(player) == true || stalemate?(player) == true

    @board.checker = []
    false
  end

  def set_player_check(current_player)
    puts 'You are Checked!'
    return @player2.checked = true if current_player == @player1

    @player1.checked = true
  end

  def set_player_no_check(current_player)
    return @player2.checked = false if current_player == @player1

    @player1.checked = false
  end

  def looking_for_check(start, destination, player)
    set_player_check(player) if @board.putting_check?(player.color)
    set_player_no_check(player) unless @board.putting_check?(player.color)
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
    @board.checker.each { |e| puts e.coordinate }
    return true if player.checked == true && @board.walkable_fields(@board.find_field(king_field.coordinate)).empty? &&
                   !can_kick_checker?(player) && !can_move_between_checker?(player) && !@board.checker.empty?

    false
  end

  def stalemate?(player)
    possible_moves = []
    team = @board.find_all_team_pieces(player.color)
    team.each do |piece_field|
      possible_moves.concat(@board.walkable_fields(piece_field))
    end

    return true if possible_moves.empty?

    false
  end

  def can_kick_checker?(player)
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
end
