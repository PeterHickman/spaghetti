# frozen_string_literal: true

class Token
  attr_reader :type, :value, :precedence, :associativity

  KEYWORDS = %w[
    END
    GOSUB
    GOTO
    IF
    INPUT
    LET
    PRINT
    REM
    RETURN
  ].freeze

  FUNCTIONS = %w[
    ABS
    COS
    INT
    LOG
    MAX
    MIN
    RND
    SGN
    SIN
    SQR
    TAN
  ].freeze

  MATHS = %w[
    +
    -
    /
    *
    ^
  ].freeze

  COMP = %w[
    <
    <=
    >
    >=
    <>
  ].freeze

  BOOL = %w[
    AND
    OR
  ].freeze

  UNKNOWN = 'unknown'
  FLOAT = 'float'
  STRING = 'string'
  KEYWORD = 'keyword'
  FUNCTION = 'function'
  MATH = 'math'
  COMPARISON = 'comparison'
  BOOLEAN = 'boolean'
  FLOAT_VARIABLE = 'float_variable'
  STRING_VARIABLE = 'string_variable'
  LEFT_PARENTHESIS = 'left_parenthesis'
  RIGHT_PARENTHESIS = 'right_parenthesis'
  COLON = 'colon'
  SEMI_COLON = 'semi_colon'
  COMMA = 'comma'
  EQUAL = 'equal'

  LEFT = 'left'
  RIGHT = 'right'

  def initialize(value)
    @value = String.new(value)

    @precedence = nil
    @associativity = nil
    @type = UNKNOWN

    set_type

    extras if @type == Token::MATH
  end

  def inspect
    x = [@type, @value, @precedence, @associativity].compact
    "<#{x.join(' ')} >"
  end

  def to_s
    inspect
  end

  def reset_value(value)
    @value = value
  end

  def self.float?(text)
    text =~ /^-?\d+$/ || text =~ /^-?\d*\.\d*$/ || text =~ /^-?\d+\.\d+[Ee]\-\d+$/ || text =~ /^-?\d+\.\d+[Ee]\+\d+$/ || text =~ /^-?\d+[Ee]\-\d+$/ || text =~ /^-?\d+[Ee]\+\d+$/
  end

  def self.string?(text)
    text.start_with?('"') && text.end_with?('"')
  end

  def self.string_variable?(text)
    text.upcase =~ /^[A-Z]+\d*\$$/
  end

  def self.float_variable?(text)
    text.upcase =~ /^[A-Z]+\d*$/
  end

  def self.keyword?(text)
    KEYWORDS.include?(text.upcase)
  end

  def self.function?(text)
    FUNCTIONS.include?(text.upcase)
  end

  def self.maths?(text)
    MATHS.include?(text)
  end

  def self.boolean?(text)
    BOOL.include?(text.upcase)
  end

  def self.comparison?(text)
    COMP.include?(text)
  end

  private

  def set_type
    if Token.float?(@value)              then @type = FLOAT; @value = @value.to_f
    elsif Token.string?(@value)          then @type = STRING
    elsif Token.keyword?(@value)         then @type = KEYWORD; @value.upcase!
    elsif Token.function?(@value)        then @type = FUNCTION; @value.upcase!
    elsif Token.maths?(@value)           then @type = MATH
    elsif Token.comparison?(@value)      then @type = COMPARISON
    elsif Token.boolean?(@value)         then @type = BOOLEAN; @value.upcase!
    elsif Token.string_variable?(@value) then @type = STRING_VARIABLE; @value.upcase!
    elsif Token.float_variable?(@value)  then @type = FLOAT_VARIABLE; @value.upcase!
    elsif @value == '('                  then @type = LEFT_PARENTHESIS
    elsif @value == ')'                  then @type = RIGHT_PARENTHESIS
    elsif @value == ':'                  then @type = COLON
    elsif @value == ';'                  then @type = SEMI_COLON
    elsif @value == ','                  then @type = COMMA
    elsif @value == '='                  then @type = EQUAL
    end
  end

  def extras
    case @value
    when '^'
      @precedence = 4
      @associativity = RIGHT
    when '*', '/'
      @precedence = 3
      @associativity = LEFT
    when '+', '-'
      @precedence = 2
      @associativity = LEFT
    else
      puts "Cannot set precedence or associativity for #{@value}"
    end
  end
end
