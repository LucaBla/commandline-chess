class Queen < Piece
  attr_reader :model, :color

  def initialize
    super
    @model = "\u265b"
    @moves = { top_left: (1..7).to_a, top: (1..7).to_a, top_right: (1..7).to_a,
               bottom_left: (1..7).to_a, bottom: (1..7).to_a, bottom_right: (1..7).to_a,
               left: (1..7).to_a, right: (1..7).to_a }
  end
end

class BlackQueen < Queen
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265b"
  end
end

class WhiteQueen < Queen
  def initialize
    super
    @color = WHITE
    @model = "#{@color}\u265b"
  end
end
