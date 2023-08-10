class Token
  BOOLEAN = 'boolean'
  COMMA = 'comma'.freeze
  CONDITIONAL = 'conditional'
  FUNCTION = 'function'.freeze
  LEFT_PARENTHESIS = 'left_parenthesis'.freeze
  NUMBER = 'number'.freeze
  OPERATOR = 'operator'.freeze
  RIGHT_PARENTHESIS = 'right_parenthesis'.freeze
  VARIABLE = 'variable'.freeze

  ASSOC_LEFT = 'left'.freeze
  ASSOC_RIGHT = 'right'.freeze

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

  def reset_type(new_type)
    @type = new_type
  end
end
