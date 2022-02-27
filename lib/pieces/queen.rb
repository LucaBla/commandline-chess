class Queen < Piece
  attr_reader :model

  def initialize
    super
    @model = "\u265b"
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
