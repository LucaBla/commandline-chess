class Bishop < Piece
  attr_reader :model

  def initialize
    @model = "\u265d"
  end
end

class BlackBishop < Bishop
  def initialize
    @model = "\e[30m\u265d"
  end
end

class WhiteBishop < Bishop
  def initialize
    @model = "\u265d"
  end
end
