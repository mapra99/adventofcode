# frozen_string_literal: true

require 'byebug'

def br_to_tl(i, j, puzzle)
  puzzle[i + 1][j + 1] == 'M' && puzzle[i - 1][j - 1] == 'S'
end

def tl_to_br(i, j, puzzle)
  puzzle[i - 1][j - 1] == 'M' && puzzle[i + 1][j + 1] == 'S'
end

def tr_to_bl(i, j, puzzle)
  puzzle[i - 1][j + 1] == 'M' && puzzle[i + 1][j - 1] == 'S'
end

def bl_to_tr(i, j, puzzle)
  puzzle[i + 1][j - 1] == 'M' && puzzle[i - 1][j + 1] == 'S'
end

def match_target?(i, j, puzzle)
  return false if puzzle[i][j] != 'A'

  (tl_to_br(i, j, puzzle) && (tr_to_bl(i, j, puzzle) || bl_to_tr(i, j, puzzle))) ||
    (tr_to_bl(i, j, puzzle) && br_to_tl(i, j, puzzle)) ||
    (br_to_tl(i, j, puzzle) && bl_to_tr(i, j, puzzle))
end

puzzle = File.readlines('04/input', chomp: true)
matches = 0
puzzle.each_with_index do |line, i|
  next if i.zero? || i == puzzle.length - 1

  line.each_char.with_index do |_char, j|
    next if j.zero? || j == line.length - 1

    matches += 1 if match_target?(i, j, puzzle)
  end
end

puts "Total matches: #{matches}"
