class Queen < Piece
  attr_reader :model

  def initialize
    @model = "\u265b"
  end
end

class BlackQueen < Queen
  def initialize
    @model = "\e[30m\u265b"
  end
end

class WhiteQueen < Queen
  def initialize
    @model = "\u265b"
  end
end
