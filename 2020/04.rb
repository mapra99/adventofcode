# https://adventofcode.com/2020/day/4

input = "\
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"

class PassportProcessor
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
    are_all_fields_present? || are_north_pole_creds?
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

  private

  def parse_hash(str)
    str.split
       .map { |pair| pair.split(':') }
       .to_h
       .transform_keys(&:to_sym)
  end
end

result = input
  .split("\n\n")
  .map { |passport| PassportProcessor.new(passport).validate }
  .count(true)

puts result
