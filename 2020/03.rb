# https://adventofcode.com/2020/day/3

str = "\
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"

class Map
  attr_reader :size

  def initialize(str)
    @pattern = str.split("\n")
    @size = { x: @pattern[0].length, y: @pattern.length }
  end

  def value_at(x, y)
    raise ArgumentError if y >= @size[:y]

    x_trans = x % @size[:x]
    @pattern[y][x_trans]
  end
end

class Toboggan
  def initialize(right:, down:, start: { x: 0, y: 0 })
    @position = start
    @right = right
    @down = down
  end

  def map_trajectory(map)
    steps = (map.size[:y] - @position[:y]) / @down
    trajectory = []
    steps.times do
      trajectory << map.value_at(@position[:x], @position[:y])
      update_position
    end

    trajectory
  end

  private

  def update_position
    @position[:x] += @right
    @position[:y] += @down
  end
end

map = Map.new(str)
trajectory = Toboggan.new(right: 3, down: 1).map_trajectory(map)
puts trajectory.count("#")
