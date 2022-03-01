class RedDot
  attr_reader :color, :model, :moves

  def initialize
    @color = "\e[31m"
    @model = "#{@color}\u25cf"
    @moves = { top_left: [0], top: [0], top_right: [0], bottom_left: [0], bottom: [0], bottom_right: [0], left: [0], right: [0] }
  end
end
