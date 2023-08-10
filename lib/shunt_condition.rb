require 'utils'

class ShuntCondition
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
      if Utils.boolean?(t)        then Token.new(Token::BOOLEAN, t.upcase)
      elsif Utils.float?(t)       then Token.new(Token::NUMBER, t.to_f)
      elsif Utils.var?(t)         then Token.new(Token::VARIABLE, t)
      elsif Utils.conditional?(t) then Token.new(Token::CONDITIONAL, t)
      elsif t == '('              then Token.new(Token::LEFT_PARENTHESIS, t)
      elsif t == ')'              then Token.new(Token::RIGHT_PARENTHESIS, t)
      else
        raise "What is this [#{t}]"
      end
    end
  end
end
