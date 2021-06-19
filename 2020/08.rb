script = [
  'nop +0',
  'acc +1',
  'jmp +4',
  'acc +3',
  'jmp -3',
  'acc -99',
  'acc +1',
  'jmp -4',
  'acc +6'
]

class LineInterpreter
  attr_reader :instruction, :operation, :operator, :value

  def initialize(command)
    @instruction, @operation = command.split(' ')
    @operator = @operation[0]
    @value = @operation[1..-1].to_i
  end
end

class ProgramState
  attr_accessor :accumulator

  def initialize
    @accumulator = 0
  end

  def to_s
    "accumulator: #{@accumulator}"
  end
end

module Accumulator
  private

  def accumulate
    state.accumulator = state.accumulator.send(@command.operator, @command.value)
  end
end

module Jumper
  private

  def jump
    @new_pointer = @pointer.send(@command.operator, @command.value)
  end
end

module NoOperationer
  private

  def no_op; end
end

class ProgramInterpreter
  include Accumulator
  include Jumper
  include NoOperationer

  INSTRUCTION_METHODS = {
    'acc' => 'accumulate',
    'jmp' => 'jump',
    'nop' => 'no_op'
  }

  attr_reader :state

  def initialize(program)
    @program = program
    @state = ProgramState.new
    @executed_lines = []
    @pointer = 0
    @exit = false
  end

  def execute
    line = @program[@pointer]
    @command = LineInterpreter.new(line)
    method = INSTRUCTION_METHODS[@command.instruction]

    before_command
    send(method)
    after_command

    execute unless @exit
  end

  private

  def before_command
    puts "Running line #{@pointer} - #{@command.instruction}"
    @new_pointer = nil

    raise LoopProgramError.new(state) if @executed_lines.include?(@pointer)
  end

  def after_command
    @executed_lines << @pointer
    @pointer = @new_pointer || @pointer + 1

    @exit = true if @pointer > @program.length - 1
  end
end

class LoopProgramError < StandardError
  def initialize(state)
    @state = state
    super
  end

  def message
    "Loop detected. Stopping execution. State: #{@state}"
  end
end

interpreter = ProgramInterpreter.new(script)
interpreter.execute
puts interpreter.state
