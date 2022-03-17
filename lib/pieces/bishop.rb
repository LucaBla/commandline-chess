class Bishop < Piece
  attr_reader :model, :color

  def initialize
    super
    @model = "\u265d"
    @moves = { top_left: (1..7).to_a, top: [0], top_right: (1..7).to_a,
               bottom_left: (1..7).to_a, bottom: [0], bottom_right: (1..7).to_a, left: [0], right: [0] }
  end
end

class BlackBishop < Bishop
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265d"
  end
end

class WhiteBishop < Bishop
  def initialize
    super
    @color = WHITE
    @model = "#{@color}\u265d"
  end
end
