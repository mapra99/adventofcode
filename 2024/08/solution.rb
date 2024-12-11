# frozen_string_literal: true

require 'byebug'

ANTENNA_REGEX = /[a-zA-Z0-9]/

def read_map(file)
  File.readlines(file, chomp: true).map(&:chars)
end

def locate_antennas(map)
  antennas = {}

  map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell.match?(ANTENNA_REGEX)
        antennas[cell] ||= []
        antennas[cell].push([x, y])
      end
    end
  end

  antennas
end

def out_of_bounds?(map, x, y)
  x.negative? || y.negative? || x >= map[0].size || y >= map.size
end

def locate_antenna_antinodes(map, positions)
  antinodes = Set.new
  return antinodes if positions.length <= 1

  positions.each do |x1, y1|
    positions.each do |x2, y2|
      next if x1 == x2 && y1 == y2

      delta_x = x2 - x1
      delta_y = y2 - y1

      multiplier = 0
      loop do
        antinode_x = x1 - delta_x * multiplier
        antinode_y = y1 - delta_y * multiplier

        break if out_of_bounds?(map, antinode_x, antinode_y)

        puts "Found antinode at #{antinode_x}, #{antinode_y}"
        antinodes.add([antinode_x, antinode_y])

        multiplier += 1
      end
    end
  end

  antinodes
end

def locate_antinodes(map, antennas)
  antinodes = Set.new

  antennas.each do |antenna, positions|
    puts "Processing antenna #{antenna}"
    antena_antinodes = locate_antenna_antinodes(map, positions)

    antinodes.merge(antena_antinodes)
  end

  antinodes
end

map = read_map('08/input')
antennas = locate_antennas(map)

antinodes = locate_antinodes(map, antennas)
puts "There are #{antinodes.size} unique antinode positions considering harmonies"
