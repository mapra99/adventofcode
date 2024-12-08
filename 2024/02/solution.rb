# frozen_string_literal: true

require 'byebug'

def gradually_changing?(levels, direction)
  result = true
  i = 0

  while i < levels.length - 1
    difference = levels[i + 1] - levels[i]
    difference *= -1 if direction == :desc

    result &= difference >= 1 && difference <= 3
    return false unless result

    i += 1
  end

  result
end

def safe?(levels, direction)
  return true if gradually_changing?(levels, direction)

  (0...levels.length).each do |i|
    new_levels = levels.dup
    new_levels.delete_at(i)
    return true if gradually_changing?(new_levels, direction)
  end

  false
end

def count_safe_reports
  reports = File.readlines('02/input', chomp: true)
  safe_reports = reports.select do |report|
    levels = report.split(' ').map(&:to_i)
    safe = safe?(levels, :asc) || safe?(levels, :desc)
    puts "levels: #{levels}, safe: #{safe}"

    safe
  end

  safe_reports.length
end

puts "There are #{count_safe_reports} safe reports"
