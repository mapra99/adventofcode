# frozen_string_literal: true

require 'byebug'

def read_input
  input = File.readlines('05/input', chomp: true)

  rules = {}
  updates = []

  input.each do |line|
    if line.include?('|')
      x, y = line.split('|').map(&:to_i)
      rules[x] ||= []
      rules[x] << y
    elsif line.include?(',')
      updates << line.split(',').map(&:to_i)
    end
  end

  [rules, updates]
end

def select_updates(updates, rules, ordered: false)
  updates.select do |update|
    is_ordered = (0...update.length).all? do |index|
      page = update[index]
      page_rules = rules[page]
      next true if page_rules.nil?

      violation_index = find_violation_index(update[0...index], page_rules)
      violation_index.nil?
    end

    puts "Update #{update} is #{is_ordered ? 'ordered' : 'not ordered'}"
    ordered ? is_ordered : !is_ordered
  end
end

def add_mid_pages(updates)
  updates.map do |update|
    update[update.length / 2]
  end.sum
end

def find_violation_index(pages, page_rules)
  pages.find_index do |prev_page|
    page_rules.include?(prev_page)
  end
end

def swap_pages(pages, index_i, index_j)
  prev_page = pages[index_i]
  pages[index_i] = pages[index_j]
  pages[index_j] = prev_page

  pages
end

def order_update(pages, rules)
  pages.each_with_index do |page, i|
    page_rules = rules[page]
    next if page_rules.nil?

    violation_index = find_violation_index(pages[0...i], page_rules)
    next if violation_index.nil?

    puts "Swapping #{pages[i]} and #{pages[violation_index]}"
    pages = swap_pages(pages, i, violation_index)

    order_update(pages, rules)
    break
  end

  pages
end

def order_updates(updates, rules)
  updates.map do |update|
    pages = update.dup
    puts "Ordering #{pages}"
    order_update(pages, rules)
  end
end

rules, updates = read_input

unordered_updates = select_updates(updates, rules, ordered: false)
puts "There are #{unordered_updates.size} unordered updates"

reordered_updates = order_updates(unordered_updates, rules)

result = add_mid_pages(reordered_updates)
puts "The result is #{result}"
