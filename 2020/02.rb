# https://adventofcode.com/2020/day/2

class PasswordPolicyTest
  attr_reader :password, :limits, :target_char

  def initialize(str)
    format_input(str)
  end

  def passes_policy?
    matches = @password.scan(@target_char)
    matches.length >= @limits.first && matches.length <= @limits.max
  end

  private

  def format_input(str)
    @limits = str
              .scan(/\d+-\d+/)
              .first
              .split('-')
              .map(&:to_i)

    @target_char = str.scan(/\w:/).first[0]

    @password = str.scan(/\w+$/).first
  end
end

array = [
  '1-3 a: abcde',
  '1-3 b: cdefg',
  '2-9 c: ccccccccc',
  '9-10 j: jjjjjjjjqjjjj',
  '13-16 w: wwlwwwwlwwxwwfwwwwf'
]

def how_many_passes(array)
  array.count do |pass|
    PasswordPolicyTest.new(pass).passes_policy?
  end
end

puts how_many_passes(array)
