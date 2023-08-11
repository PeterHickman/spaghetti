class Utils
  FUNCTIONS = %w[
    MAX
    MIN
    SIN
    INT
    RND
    ABS
    COS
    TAN
    SQR
  ].freeze

  BOOLEANS = %w[AND OR].freeze

  CONDITIONALS = %w[< > <= >= = <>].freeze

  COMMANDS = %w[
    END
    FOR
    GOSUB
    GOTO
    LET
    NEXT
    IF
    PRINT
    REM
    RETURN
    INPUT
    WHILE
    WEND
    REPEAT
    UNTIL
  ].freeze

  def self.var?(x)
    y = unary?(x) ? x[1..-1] : x

    return false if FUNCTIONS.include?(y)
    return false if BOOLEANS.include?(y)

    y =~ /^[a-zA-Z]+\d*$/
  end

  def self.float_var?(x)
    # This assumes that we know this is a variable
    string_var?(x) == false
  end

  def self.string_var?(text)
    # This assumes that we know this is a variable
    text.end_width?('$')
  end

  def self.unary?(text)
    text.start_with?('-')
  end

  def self.function?(x)
    y = unary?(x) ? x[1..-1] : x

    return FUNCTIONS.include?(y.upcase)
  end

  def self.float?(text)
    (text =~ /^-?\d+$/) || (text =~ /^-?\d+\.\d+$/)
  end

  def self.text?(text)
    text.start_with?('"') && text.end_with?('"')
  end

  def self.boolean?(text)
    BOOLEANS.include?(text.upcase)
  end

  def self.conditional?(text)
    CONDITIONALS.include?(text)
  end
end
