# frozen_string_literal: true

require 'byebug'

def build_lists(lines)
  list1 = []
  list2 = []

  lines.each do |line|
    id1, id2 = line.split(/\s+/).map(&:to_i)

    list1.push(id1)
    list2.push(id2)
  end

  list1.sort!
  list2.sort!

  [list1, list2]
end

def build_frequencies(list1, list2)
  frequencies = {}
  list1.each { |id1| frequencies[id1] = 0 }

  list2.each do |id2|
    next if frequencies[id2].nil?

    frequencies[id2] += 1
  end

  frequencies
end

def calculate_distances(list1, list2)
  total_distance = 0
  list1.each_with_index do |id1, i|
    id2 = list2[i]

    total_distance += (id2 - id1).abs
  end

  total_distance
end

def calculate_similarity(list1, list2)
  frequencies = build_frequencies(list1, list2)

  total_similarity = 0
  frequencies.each do |id, count|
    total_similarity += id * count
  end

  total_similarity
end

lines = File.readlines('01/input', chomp: true)
list1, list2 = build_lists(lines)

puts "Total distance: #{calculate_distances(list1, list2)}"
puts "Total similarity: #{calculate_similarity(list1, list2)}"
