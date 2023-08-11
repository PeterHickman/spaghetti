# frozen_string_literal: true

class Token
  BOOLEAN = 'boolean'
  COMMA = 'comma'
  CONDITIONAL = 'conditional'
  FUNCTION = 'function'
  LEFT_PARENTHESIS = 'left_parenthesis'
  NUMBER = 'number'
  OPERATOR = 'operator'
  RIGHT_PARENTHESIS = 'right_parenthesis'
  VARIABLE = 'variable'

  ASSOC_LEFT = 'left'
  ASSOC_RIGHT = 'right'

  attr_reader :type, :value, :precedence, :associativity

  def initialize(type, value, precedence = 0, associativity = nil)
    @type = type
    @value = value
    @precedence = precedence
    @associativity = associativity
  end

  def inspect
    l = [@type, @value]
    l << @precedence if @precedence.positive?
    l << @associativity if @associativity

    "<#{l.join(' ')}>"
  end

  def to_s
    inspect
  end

  def reset_type(new_type)
    @type = new_type
  end
end
