class Bishop < Piece
  attr_reader :model

  def initialize
    super
    @model = "\u265d"
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
