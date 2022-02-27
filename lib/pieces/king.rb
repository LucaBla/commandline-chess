class King < Piece
  attr_reader :model

  def initialize
    super
    @model = "\u265a"
  end
end

class BlackKing < King
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265a"
  end
end

class WhiteKing < King
  def initialize
    super
    @color = WHITE
    @model = "#{@color}\u265a"
  end
end
