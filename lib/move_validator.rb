module MoveValidator
  BLACK = "\e[30m"
  WHITE = ""

  def walkable_fields(start_field)
    return if start_field == nil

    get_valid_pawn_move(start_field.piece, start_field) if start_field.piece.class <= Pawn
    moves = start_field.piece.moves.reject { |_, value| value == [0] }
    start_field.piece.color == WHITE ? allowed_fields = return_white_allowed_field(start_field, moves)
                                     : allowed_fields = return_black_allowed_field(start_field, moves)
    clear_allowed_fields(allowed_fields, start_field)
  end

  def clear_allowed_fields(allowed_fields, start_field)
    allowed_fields.reject! { |e| e.nil? }
    allowed_fields.reject! do |e|
      e.piece.color == start_field.piece.color unless e.nil? || e.piece.nil?
    end
    allowed_fields
  end

  def knight_allowed_fields(start_field, moves)
    allowed_fields = []
    plus = :+
    minus = :-
    2.times do |e|
      allowed_fields.push(find_field([start_field.coordinate[0].public_send(plus, moves[:top][e]),
                                      start_field.coordinate[1].public_send(minus, moves[:left][e])]))
      allowed_fields.push(find_field([start_field.coordinate[0].public_send(minus, moves[:top][e]),
                                      start_field.coordinate[1].public_send(minus, moves[:left][e])]))
      allowed_fields.push(find_field([start_field.coordinate[0].public_send(plus, moves[:top][e]),
                                      start_field.coordinate[1].public_send(plus, moves[:left][e])]))
      allowed_fields.push(find_field([start_field.coordinate[0].public_send(minus, moves[:top][e]),
                                      start_field.coordinate[1].public_send(plus, moves[:left][e])]))
    end

    allowed_fields
  end

  def return_white_allowed_field(start_field, moves)
    return knight_allowed_fields(start_field, moves) if start_field.piece.class <= Knight

    allowed_fields = []
    moves.each do |key, value|
      behind_piece = false
      case key
      when :top
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] + v, start_field.coordinate[1]])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :top_right
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] + v, start_field.coordinate[1] + v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :top_left
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] + v, start_field.coordinate[1] - v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :bottom
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] - v, start_field.coordinate[1]])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :bottom_right
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] - v, start_field.coordinate[1] + v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :bottom_left
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] - v, start_field.coordinate[1] - v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :left
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0], start_field.coordinate[1] - v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :right
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0], start_field.coordinate[1] + v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      end
    end
    allowed_fields
  end

  def return_black_allowed_field(start_field, moves)
    return knight_allowed_fields(start_field, moves) if start_field.piece.class <= Knight

    allowed_fields = []
    moves.each do |key, value|
      behind_piece = false
      case key
      when :top
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] - v, start_field.coordinate[1]])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :top_right
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] - v, start_field.coordinate[1] - v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :top_left
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] - v, start_field.coordinate[1] + v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :bottom
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] + v, start_field.coordinate[1]])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :bottom_right
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] + v, start_field.coordinate[1] - v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :bottom_left
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0] + v, start_field.coordinate[1] + v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :left
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0], start_field.coordinate[1] + v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      when :right
        value.each do |v|
          allowed_fields.push(find_field([start_field.coordinate[0], start_field.coordinate[1] - v])) unless behind_piece
          next if allowed_fields[allowed_fields.length - 1].nil?

          behind_piece = true unless allowed_fields[allowed_fields.length - 1].piece.nil?
        end
      end
    end
    allowed_fields
  end

  def get_valid_pawn_move(pawn, field)
    return 'Error' unless pawn.class <= Pawn

    top = pawn_top_move(pawn, field)

    diagonal_enemy_left(field, pawn) ? top_left = [1] : top_left = [0]
    diagonal_enemy_right(field, pawn) ? top_right = [1] : top_right = [0]

    pawn.moves = { top_left: top_left, top: top, top_right: top_right,
                   bottom_left: [0], bottom: [0], bottom_right: [0], left: [0], right: [0] }
  end

  def pawn_top_move(pawn, field)
    top = [0]
    top = [1, 2] if pawn.moved == false
    top = [1] if pawn.moved == true || top_enemy_double_move(field, pawn)
    top = [0] if top_enemy(field, pawn)
    top
  end

  def top_enemy(field, piece)
    piece.color == WHITE ? front_field = field.top_field : front_field = field.bottom_field

    return false if front_field.nil?

    unless front_field.piece.nil?
      return true if front_field.piece.color != piece.color
    end
    false
  end

  def top_enemy_double_move(field, piece)
    piece.color == WHITE ? front_field = field.top_field.top_field : front_field = field.bottom_field.bottom_field

    return false if front_field.nil?

    unless front_field.piece.nil?
      return true if front_field.piece.color != piece.color
    end
    false
  end

  def diagonal_enemy_left(field, piece)
    return false if field.top_field.nil?

    piece.color == WHITE ? front_field = field.top_field : front_field = field.bottom_field
    piece.color == WHITE ? diagonal_left_field = front_field.left_field : diagonal_left_field = front_field.right_field

    return false if diagonal_left_field.nil?

    unless diagonal_left_field.piece.nil?
      return true if diagonal_left_field.piece.color != piece.color
    end

    false
  end

  def diagonal_enemy_right(field, piece)
    return false if field.top_field.nil?

    piece.color == WHITE ? front_field = field.top_field : front_field = field.bottom_field
    piece.color == WHITE ? diagonal_right_field = front_field.right_field : diagonal_right_field = front_field.left_field

    return false if diagonal_right_field.nil?

    unless diagonal_right_field.piece.nil?
      return true if diagonal_right_field.piece.color != piece.color
    end

    false
  end
end
