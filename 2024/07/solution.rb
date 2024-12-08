# frozen_string_literal: true

require 'byebug'

class Equation
  attr_reader :result, :operands_values, :operators, :root_operand

  def initialize(result, operands_values)
    @result = result
    @operands_values = operands_values
    @root_operand = build_operands_tree(operands_values)
  end

  def self.read_file(file_path)
    File.readlines(file_path, chomp: true).map do |line|
      result, operands = line.split(': ')
      new(result.to_i, operands.split.map(&:to_i))
    end
  end

  def inspect
    "Equation(#{result}: #{operands_values.join(' ')})"
  end

  def find_operators(node = root_operand, operators = [])
    if node.addition.nil? && node.multiplication.nil?
      return false if node.value != result

      puts "Equation #{inspect} can be satisfied with operators #{operators.join(' ')}"
      operators
    else
      find_operators(node.addition, [*operators, :addition]) ||
        find_operators(node.multiplication, [*operators, :multiplication]) ||
        find_operators(node.concatenation, [*operators, :concatenation])
    end
  end

  private

  def build_operands_tree(operands)
    root = OperandNode.new(operands.first)
    stack = [root]

    operands[1..].each do |operand|
      new_stack = []
      stack.each do |node|
        node.add_operand(operand)
        new_stack << node.addition
        new_stack << node.multiplication
        new_stack << node.concatenation
      end
      stack = new_stack
    end

    root
  end
end

class OperandNode
  attr_reader :value, :addition, :multiplication, :concatenation

  def initialize(value, addition: nil, multiplication: nil, concatenation: nil)
    @value = value
    @addition = addition
    @multiplication = multiplication
    @concatenation = concatenation
  end

  def add_operand(new_operand)
    @addition = OperandNode.new(value + new_operand)
    @multiplication = OperandNode.new(value * new_operand)
    @concatenation = OperandNode.new("#{value}#{new_operand}".to_i)
  end
end

def find_valid_equations
  equations = Equation.read_file('07/input')
  valid_equations = equations.select(&:find_operators)

  total = valid_equations.reduce(0) { |sum, equation| sum + equation.result }

  puts "There are #{valid_equations.size} valid equations. The total is #{total}."
  valid_equations
end

find_valid_equations
