# https://adventofcode.com/2020/day/1

array = [1729, 979, 366, 299, 1041, 1456]
class Array
  def find_pair_that_sum(goal)
    sorted = sort

    sorted.each do |num|
      target = goal - num
      sorted.pop until sorted[-1] <= target

      return [num, target] if sorted[-1] == target
    end
  end
end

pair = array.find_pair_that_sum(2020)
puts "Pair: #{pair}. Product: #{pair.reduce(&:*)}"
