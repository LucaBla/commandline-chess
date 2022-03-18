# frozen_string_literal: true

require './lib/color'

# Methods to set, unset and kick Pawns en-passant
module EnPassant
  include Color

  def set_en_passant(start_field, destination_field)
    destination_field.piece.en_passant = true if start_field.coordinate[0] == 1 && destination_field.coordinate[0] == 3
    destination_field.piece.en_passant = true if start_field.coordinate[0] == 6 && destination_field.coordinate[0] == 4
  end

  def remove_en_passant(player)
    team = find_all_team_pieces(player.color)
    team.each do |e|
      e.piece.en_passant = false if e.piece.class <= Pawn
    end
  end

  def kick_en_passant(color, destination_field)
    enemy_color = color == WHITE ? 'Black' : 'White'
    pawn_class = Object.const_get("#{enemy_color}Pawn")
    pawn_to_delete_field = enemy_color == 'Black' ? destination_field.bottom_field : destination_field.top_field
    pawn_to_delete = pawn_to_delete_field.piece
    pawn_to_delete_field.piece = nil if !pawn_to_delete_field.nil? && !pawn_to_delete.nil? &&
                                        pawn_to_delete.instance_of?(pawn_class) &&
                                        pawn_to_delete.en_passant
    @last_deleted_piece = destination_field.bottom_field.piece
  end

  def pawn_en_passant_move_left(pawn, field)
    color = 'Black' if pawn.instance_of?(WhitePawn)
    color = 'White' if pawn.instance_of?(BlackPawn)
    class_name = "#{color}Pawn"
    enemy_pawn = Object.const_get(class_name)
    enemy_pawn_field = field.left_field
    true if !enemy_pawn_field.nil? && !enemy_pawn_field.piece.nil? && enemy_pawn_field.piece.class <= enemy_pawn &&
            enemy_pawn_field.piece.en_passant
  end

  def pawn_en_passant_move_right(pawn, field)
    color = 'Black' if pawn.instance_of?(WhitePawn)
    color = 'White' if pawn.instance_of?(BlackPawn)
    class_name = "#{color}Pawn"
    enemy_pawn = Object.const_get(class_name)
    enemy_pawn_field = field.right_field
    true if !enemy_pawn_field.nil? && !enemy_pawn_field.piece.nil? && enemy_pawn_field.piece.class <= enemy_pawn &&
            enemy_pawn_field.piece.en_passant
  end
end
