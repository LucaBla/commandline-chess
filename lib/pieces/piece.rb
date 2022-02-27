class Piece
  attr_accessor :moves
  attr_reader :color

  @color = ''
  @model = ''
  @moves = { top_left: [0], top: [0], top_right: [0], bottom_left: [0], bottom: [0], bottom_right: [0], left: [0], right: [0] }
end
