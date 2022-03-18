# frozen_string_literal: true

# Methods used to check if castling is possible and to move the pieces that are part of the Castling
module Castling
  def king_get_castle_move(start_field, allowed_fields)
    condition = can_castle?(start_field.piece.color)

    return allowed_fields if condition == false

    allowed_fields.push(start_field.left_field.left_field) if condition == 'left'
    allowed_fields.push(start_field.right_field.right_field) if condition == 'right'

    allowed_fields
  end

  def can_castle?(color)
    king_field = get_king(color)

    rooks = get_castle_rook(king_field)

    left_piece_field = rooks[0]
    right_piece_field = rooks[1]

    return false if left_piece_field.nil? && right_piece_field.nil?

    return false if left_piece_field.piece.nil? && right_piece_field.piece.nil?

    return false unless left_piece_field.piece.class <= Rook || right_piece_field.piece.class <= Rook

    return false if king_field.piece.moved == true

    atze = left_piece_field.piece.class <=> Rook
    return false if (left_piece_field.piece.nil? || atze.nil? || left_piece_field.piece.moved == true) &&
                    (right_piece_field.piece.nil? || right_piece_field.piece.moved == true)

    return 'left' if left_piece_field.piece.class <= Rook

    return 'right' if right_piece_field.piece.class <= Rook

    false
  end

  def get_king(color)
    team = find_all_team_pieces(color)
    team.each do |e|
      return e if e.piece.class <= King
    end
  end

  def get_castle_rook(king_field)
    root = king_field
    left_piece_field = root.left_field
    right_piece_field = root.right_field
    left_piece_field = left_piece_field.left_field until left_piece_field.nil? || !left_piece_field.piece.nil? ||
                                                         left_piece_field.left_field.nil?
    right_piece_field = right_piece_field.right_field until right_piece_field.nil? || !right_piece_field.piece.nil? ||
                                                            right_piece_field.right_field.nil?

    put_castling_rook_in_array(left_piece_field, right_piece_field)
  end

  def put_castling_rook_in_array(left_piece_field, right_piece_field)
    sol = []
    sol.push(left_piece_field) unless left_piece_field.nil?
    sol.push(nil) if sol.length != 1
    sol.push(right_piece_field) unless right_piece_field.nil?
    sol.push(nil) if sol.length != 2
    sol
  end

  def castling_move_rook(start_field, destination_field)
    new_rook_field = nil
    if start_field.left_field.left_field == destination_field
      rook = 0
      new_rook_field = destination_field.right_field
    elsif start_field.right_field.right_field == destination_field
      rook = 1
      new_rook_field = destination_field.left_field
    else
      return
    end
    rook_field = get_castle_rook(destination_field)[rook]
    new_rook_field.piece = rook_field.piece
    rook_field.piece = nil
  end
end
