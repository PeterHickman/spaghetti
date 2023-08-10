class ShuntCondition
  BOOLEANS = %w[AND OR].freeze
  CONDITIONALS = %w[< > <= >= = <>].freeze

  def self.parse(tokens)
    output_queue = []
    operator_stack = OperatorStack.new

    labeled_tokens = label_tokens(tokens)

    labeled_tokens.each do |e|
      case e.type
      when Token::BOOLEAN
        output_queue << operator_stack.pop if operator_stack.any? && operator_stack.type == Token::CONDITIONAL
        operator_stack << e
      when Token::NUMBER, Token::VARIABLE
        output_queue << e
      when Token::CONDITIONAL
        operator_stack << e
      when Token::LEFT_PARENTHESIS
        operator_stack << e
      when Token::RIGHT_PARENTHESIS
        output_queue << operator_stack.pop while operator_stack.type != Token::LEFT_PARENTHESIS

        operator_stack.pop
      end
    end

    output_queue << operator_stack.pop while operator_stack.any?

    output_queue
  end

  def self.label_tokens(tokens)
    tokens.map do |t|
      if booleans(t) then       Token.new(Token::BOOLEAN, t.upcase)
      elsif number(t) then      Token.new(Token::NUMBER, t.to_f)
      elsif variable(t) then    Token.new(Token::VARIABLE, t)
      elsif conditional(t) then Token.new(Token::CONDITIONAL, t)
      elsif t == '(' then       Token.new(Token::LEFT_PARENTHESIS, t)
      elsif t == ')' then       Token.new(Token::RIGHT_PARENTHESIS, t)
      else
        raise "What is this [#{t}]"
      end
    end
  end

  def self.conditional(text)
    CONDITIONALS.include?(text)
  end

  def self.booleans(text)
    BOOLEANS.include?(text.upcase)
  end

  def self.number(text)
    text =~ /^-?\d+$/ || text =~ /^-?\d+\.\d+$/
  end

  def self.variable(text)
    return false if booleans(text)

    text.upcase =~ /^[A-Z]+$/
  end
end
