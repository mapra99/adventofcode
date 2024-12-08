require 'byebug'

DO_KEYWORD=/\Ado\(\)/
DONT_KEYWORD=/\Adon't\(\)/
MULT_KEYWORD=/\Amul\((\d{1,3}),(\d{1,3})\)/

memory = File.read('03/input')
result = 0
ignore = false

memory.each_char.with_index do |char, index|
  if DO_KEYWORD.match(memory[index..])
    ignore = false
  elsif DONT_KEYWORD.match(memory[index..])
    ignore = true
  elsif MULT_KEYWORD.match(memory[index..])
    match = MULT_KEYWORD.match(memory[index..])

    if ignore
      puts "Ignoring: #{match}"
      next
    end

    numbers = match.captures.map(&:to_i)
    result += numbers[0] * numbers[1]
  end
end

puts "Result: #{result}"
