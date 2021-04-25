require 'byebug'

input = [
  'light red bags contain 1 bright white bag, 2 muted yellow bags.',
  'dark orange bags contain 3 bright white bags, 4 muted yellow bags.',
  'bright white bags contain 1 shiny gold bag.',
  'muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.',
  'shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.',
  'dark olive bags contain 3 faded blue bags, 4 dotted black bags.',
  'vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.',
  'faded blue bags contain no other bags.',
  'dotted black bags contain no other bags.'
]

class String
  def snake_case
    underscored = split(/\s+/).join('_')
    underscored.downcase
  end
end

class Bag
  attr_reader :color, :capacity

  def initialize(color:, capacity: 0)
    @color = color
    @capacity = capacity
  end
end

class BagGraph
  attr_reader :color_graph

  def initialize(input)
    build_color_graph(input)
  end

  def traverse_nodes(node_key, traversed_nodes = [])
    traversed_nodes << node_key
    node_connections = color_graph[node_key]

    node_connections.each do |connection_key|
      traverse_nodes(connection_key, traversed_nodes)
    end

    traversed_nodes
  end

  private

  def build_color_graph(input)
    @color_graph = {}

    input.each do |line|
      line_bags = parse_line(line)

      line_bags[:contained].each do |contained_bag|
        @color_graph[contained_bag] = [] if @color_graph[contained_bag].nil?
        @color_graph[contained_bag].push(line_bags[:container])
      end

      @color_graph[line_bags[:container]] = [] if @color_graph[line_bags[:container]].nil?
    end
  end

  def parse_line(line, only_colors: true)
    container_bag = line[/^(\w+|\s){1,5}bags/].gsub(' bags', '').snake_case.to_sym
    contained_bags = line.scan(/((\d+)\s([\w+\s]+))/).map do |bag|
      capacity = bag[1].to_i
      color = bag[2].gsub(/\sbags?$/, '').snake_case.to_sym
      if only_colors
        color
      else
        Bag.new(color: color, capacity: capacity)
      end
    end

    {
      container: container_bag,
      contained: contained_bags
    }
  end
end

bags = BagGraph.new(input)
puts bags.traverse_nodes(:shiny_gold).uniq.length - 1 # substracting 1 because the option of sending the initial bag unpackaged is not a solution
