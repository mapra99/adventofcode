# https://adventofcode.com/2020/day/4
require 'byebug'

input = "\
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007

pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"

module DataValidator
  def valid?(attr, criteria = {})
    @value = @passport[attr]
    criteria.each do |type, params|
      result = run_validation(type, params)
      @validation_errors.push([attr, type]) unless result
    end
  end

  private

  def run_validation(type, params)
    if params.is_a?(Hash)
      send(type, **params)
    elsif params.is_a?(Array)
      send(type, params)
    else
      send(type, *params)
    end
  end

  def prefix(expr)
    @value.delete_prefix!(expr)
  end

  def suffix(expr)
    @value.delete_suffix!(expr)
  end

  def integer(expected)
    parsed_value = @value.to_i
    is_integer = parsed_value.to_s == @value

    @value = parsed_value
    is_integer == expected
  end

  def range(min:, max:)
    @value.to_f >= min && @value.to_f <= max
  end

  def contains_only(valid_set)
    valid_set.map!(&:to_s)
    @value.split('').all? {|char| valid_set.include?(char) }
  end

  def equals_only(valid_set)
    valid_set.map!(&:to_s)
    valid_set.include?(@value)
  end

  def length(expected)
    @value.length == expected
  end

  def or(criteria)
    criteria.any? do |validation|
      validation.all? do |type, params|
        run_validation(type, params)
      end
    end
  end
end

class PassportProcessor
  include DataValidator

  attr_reader :passport

  REQUIRED_KEYS = %i[
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
    cid
  ].freeze

  def initialize(str)
    @passport = parse_hash(str)
  end

  def validate
    @validation_errors = []
    validate_data

    (are_all_fields_present? || are_north_pole_creds?) && @validation_errors.empty?
  end

  private

  def parse_hash(str)
    str.split
       .map { |pair| pair.split(':') }
       .to_h
       .transform_keys(&:to_sym)
  end

  def are_all_fields_present?
    REQUIRED_KEYS.all? do |key|
      @passport.keys.include?(key)
    end
  end

  def are_north_pole_creds?
    REQUIRED_KEYS.all? do |key|
      @passport.keys.include?(key) || key == :cid
    end
  end

  def validate_data
    valid? :byr, integer: true, range: {min: 1920, max: 2002}
    valid? :iyr, integer: true, range: {min: 2010, max: 2020}
    valid? :eyr, integer: true, range: {min: 2020, max: 2030}
    valid? :hgt, or: [{suffix: 'cm', range: {min: 150, max: 193}}, {suffix: 'in', range: {min: 59, max: 76}}]
    valid? :hcl, prefix: '#', contains_only: (0..9).to_a + ('a'..'f').to_a
    valid? :ecl, equals_only: %w[amb blu brn gry grn hzl oth]
    valid? :pid, contains_only: (0..9).to_a, length: 9
  end
end

result = input
  .split("\n\n")
  .map { |passport| PassportProcessor.new(passport).validate }
  .count(true)

puts result
