class King < Piece
  attr_reader :model

  def initialize
    @model = "\u265a"
  end
end

class BlackKing < King
  def initialize
    @model = "\e[30m\u265a"
  end
end

class WhiteKing < King
  def initialize
    @model = "\u265a"
  end
end
