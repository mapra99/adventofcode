class BinarySplitter
  attr_reader :search_set

  def initialize(length:)
    @search_set = (0...length).to_a
  end

  def split_upper
    half = search_set.length / 2
    @search_set = search_set[half..-1]
  end

  def split_lower
    half = search_set.length / 2
    @search_set = search_set[0...half]
  end
end

class RowLocator < BinarySplitter
  def initialize
    super(length: 128)
  end

  def locate(str)
    str.split('').each do |char|
      split_lower if char == 'F'
      split_upper if char == 'B'
    end

    search_set
  end
end

class ColumnLocator < BinarySplitter
  def initialize
    super(length: 8)
  end

  def locate(str)
    str.split('').each do |char|
      split_lower if char == 'L'
      split_upper if char == 'R'
    end

    search_set
  end
end

class SeatLocator
  attr_reader :row_set, :column_set, :seat_id

  def initialize
    @row_set = RowLocator.new
    @column_set = ColumnLocator.new
  end

  def locate(str)
    seat_row = @row_set.locate(str[0...7]).first
    seat_column = @column_set.locate(str[7..-1]).first

    @seat_id = seat_row * 8 + seat_column
  end
end

input = %w[
  FBFBBFFRLR
  BFFFBBFRRR
  FFFBBBFRRR
  BBFFBBFRLL
]

seat_ids = input.map do |boarding_pass|
  locator = SeatLocator.new
  locator.locate(boarding_pass)
  locator.seat_id
end

puts seat_ids.max
