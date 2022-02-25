class Field
  attr_reader :color
  attr_accessor :coordinate, :piece, :top_field, :bottom_field, :left_field, :right_field

  def initialize(coordinate = [nil, nil])
    @piece = nil
    @coordinate = coordinate
    @color = set_color # U+25A0 [30m [37m

    @top_field = nil
    @bottom_field = nil
    @left_field = nil
    @right_field = nil
  end

  def to_s
    "coordinate: #{@coordinate}\ncolor: #{@color}\npiece: #{@piece}\n"
  end

  def set_color
    return '100' if (coordinate[0].even? && coordinate[1].even?) || (!coordinate[0].even? && !coordinate[1].even?) 
    return '106'
  end
end
