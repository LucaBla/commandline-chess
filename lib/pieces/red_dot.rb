class RedDot
  attr_reader :color, :model

  def initialize
    @color = "\e[31m"
    @model = "#{@color}\u25cf"
  end
end
