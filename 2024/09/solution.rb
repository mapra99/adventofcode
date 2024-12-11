# frozen_string_literal: true

require 'byebug'

def main
  disk_map = File.read('09/input').chars.map(&:to_i)

  file_blocks = []
  empty_blocks = []

  disk_map.each_with_index do |entry, index|
    if index.even?
      empty_blocks << entry
    else
      file_blocks << entry
    end
  end

  blocks = []
  index = 0
  while index < file_blocks.length
    file_block = file_blocks[index]
    file_block.times do
      blocks << index
    end
    file_blocks[index] = nil

    empty_block = empty_blocks[index]
    latest_index = -1
    latest_file_block = file_blocks[latest_index]
    loop do
      break if !latest_file_block.nil?

      latest_index -= 1
    end

    index += 1
  end

  puts empty_blocks.size
  puts file_blocks.size
end

main
