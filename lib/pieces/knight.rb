class Knight < Piece
  attr_reader :model

  def initialize
    @model = "\u265e"
  end
end

class BlackKnight < Knight
  def initialize
    @model = "\e[30m\u265e"
  end
end

class WhiteKnight < Knight
  def initialize
    @model = "\u265e"
  end
end
