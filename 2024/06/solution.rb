# frozen_string_literal: true

require 'byebug'

class LoopFound < StandardError; end

def read_map
  File.readlines('06/input', chomp: true).map(&:chars)
end

def find_starting_position(map)
  map.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      return [i, j] if cell == '^'
    end
  end
end

def outside_boundaries?(map, position)
  x, y = position
  x.negative? || y.negative? || x >= map.size || y >= map[0].size
end

def move_forward(position, direction)
  x, y = position

  case direction
  when :up
    [x - 1, y]
  when :down
    [x + 1, y]
  when :left
    [x, y - 1]
  when :right
    [x, y + 1]
  end
end

def turn_right(direction)
  right_directions = {
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }

  right_directions[direction]
end

def find_next_position(map, current_step)
  current_position = current_step[:position]
  current_direction = current_step[:direction]
  new_x, new_y = move_forward(current_position, current_direction)

  if outside_boundaries?(map, [new_x, new_y])
    [nil, current_direction]
  elsif map[new_x][new_y] == '#'
    find_next_position(map, { position: current_position, direction: turn_right(current_direction) })
  else
    [[new_x, new_y], current_direction]
  end
end

def draw_trajectory(map, starting_position, starting_direction: :up, log: true)
  trajectory = [{ position: starting_position, direction: starting_direction }]

  loop do
    next_position, next_direction = find_next_position(map, trajectory.last)
    break if next_position.nil?

    next_step = { position: next_position, direction: next_direction }
    raise LoopFound if found_loop?(trajectory, next_step)

    puts "Moving to #{next_position} with direction #{next_direction}" if log
    trajectory << { position: next_position, direction: next_direction }
  end

  trajectory
end

def take_positions(trajectory)
  trajectory.map { |step| step[:position] }
end

def found_loop?(trajectory, step)
  trajectory.any? { |s| s[:position] == step[:position] && s[:direction] == step[:direction] }
end

def find_potential_loops(map, starting_position, starting_direction: :up)
  loops = []
  original_trajectory = draw_trajectory(map, starting_position, starting_direction:, log: false)

  original_trajectory[1..].each do |step|
    modified_map = map.map(&:dup)
    modified_map[step[:position][0]][step[:position][1]] = '#'

    draw_trajectory(modified_map, starting_position, starting_direction:, log: false)
  rescue LoopFound
    puts "Loop found by placing obstacle at #{step[:position]}"
    loops.push(step[:position])
  end

  loops
end

map = read_map
starting_position = find_starting_position(map)
trajectory = draw_trajectory(map, starting_position)
positions = take_positions(trajectory)

puts "Trajectory took #{trajectory.size} steps, that is #{positions.uniq.size} unique positions"

loops = find_potential_loops(map, starting_position)
puts "Found #{loops.uniq.size} potential loops"
