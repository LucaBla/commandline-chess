class Knight < Piece
  attr_reader :model

  def initialize
    super
    @model = "\u265e"
  end
end

class BlackKnight < Knight
  def initialize
    super
    @color = BLACK
    @model = "#{@color}\u265e"
  end
end

class WhiteKnight < Knight
  def initialize
    super
    @color = WHITE
    @model = "#{@color}\u265e"
  end
end
