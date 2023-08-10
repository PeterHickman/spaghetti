class ShuntExpression
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

  def self.parse(list_of_tokens)
    tokens = label_tokens(list_of_tokens)
    shunt(tokens)
  end

  def self.shunt(tokens)
    output_queue = []
    operator_stack = OperatorStack.new

    while tokens.any?
      token = tokens.shift

      case token.type
      when Token::NUMBER, Token::VARIABLE
        output_queue << token
      when Token::FUNCTION, Token::LEFT_PARENTHESIS
        operator_stack << token
      when Token::OPERATOR
        while operator_stack.any? && (operator_stack.type != Token::LEFT_PARENTHESIS && (operator_stack.precedence > token.precedence || (operator_stack.precedence == token.precedence && token.associativity == Token::ASSOC_LEFT)))
          output_queue << operator_stack.pop
        end
        operator_stack << token
      when Token::COMMA
        output_queue << operator_stack.pop while operator_stack.type != Token::LEFT_PARENTHESIS
      when Token::RIGHT_PARENTHESIS
        while operator_stack.type != Token::LEFT_PARENTHESIS
          raise 'operator stack is empty, mismatched parentheses' if operator_stack.empty?

          output_queue << operator_stack.pop
        end
        unless operator_stack.type == Token::LEFT_PARENTHESIS
          raise 'there is a left parenthesis at the top of the operator stack'
        end

        operator_stack.pop
        output_queue << operator_stack.pop if operator_stack.any? && operator_stack.type == Token::FUNCTION
      else
        puts "[#{token}]"
        exit 1
      end
    end

    while operator_stack.any?
      raise 'the operator on top of the stack is not a (left) parenthesis' if operator_stack.type == Token::LEFT_PARENTHESIS

      output_queue << operator_stack.pop
    end

    output_queue
  end

  def self.label_tokens(l)
    r = []

    l.each do |item|
      if function?(item)
        r << Token.new(Token::FUNCTION, item.upcase)
      elsif variable?(item)
        r << Token.new(Token::VARIABLE, item.upcase)
      elsif number?(item)
        r << Token.new(Token::NUMBER, item.to_f)
      elsif %w[+ -].include?(item)
        r << Token.new(Token::OPERATOR, item, 2, Token::ASSOC_LEFT)
      elsif %w[/ *].include?(item)
        r << Token.new(Token::OPERATOR, item, 3, Token::ASSOC_LEFT)
      elsif item == '^'
        r << Token.new(Token::OPERATOR, item, 4, Token::ASSOC_RIGHT)
      elsif item == '('
        r.last.reset_type(Token::FUNCTION) if r.any? && r.last.type == Token::VARIABLE
        r << Token.new(Token::LEFT_PARENTHESIS, item)
      elsif item == ')'
        r << Token.new(Token::RIGHT_PARENTHESIS, item)
      elsif item == ','
        r << Token.new(Token::COMMA, item)
      else
        raise "Unknown token [#{item}]"
      end
    end

    r
  end

  def self.function?(x)
    y = unary?(x) ? x[1..-1] : x

    return FUNCTIONS.include?(y.upcase)
  end

  def self.variable?(x)
    y = unary?(x) ? x[1..-1] : x

    return false if FUNCTIONS.include?(y)

    y =~ /^[a-zA-Z]+$/
  end

  def self.number?(x)
    x =~ /^-?\d+$/ || x =~ /^-?\d+\.\d+$/
  end

  def self.unary?(text)
    text.start_with?('-')
  end
end
