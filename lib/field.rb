class Field
  attr_accessor :coordinate, :piece, :color, :top_field, :bottom_field, :left_field, :right_field, :capturable

  def initialize(coordinate = [nil, nil])
    @piece = nil
    @coordinate = coordinate
    @color = set_color # U+25A0 [30m [37m

    @top_field = nil
    @bottom_field = nil
    @left_field = nil
    @right_field = nil

    @capturable = false
  end

  def to_s
    "coordinate: #{@coordinate}\ncolor: #{@color}\npiece: #{@piece}\n"
  end

  def set_color
    return '100' if (coordinate[0].even? && coordinate[1].even?) || (!coordinate[0].even? && !coordinate[1].even?)

    '106'
  end
end
