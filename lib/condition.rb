# frozen_string_literal: true

# https://en.wikipedia.org/wiki/Shunting_yard_algorithm

class Condition
  def self.parse(tokens)
    output_queue = []
    operator_stack = []

    tokens.each do |e|
      case e.type
      when Token::BOOLEAN
        output_queue << operator_stack.pop if operator_stack.any? && operator_stack.last.type == Token::COMPARISON
        operator_stack << e
      when Token::FLOAT, Token::FLOAT_VARIABLE
        output_queue << e
      when Token::COMPARISON, Token::EQUAL
        operator_stack << e
      when Token::LEFT_PARENTHESIS
        operator_stack << e
      when Token::RIGHT_PARENTHESIS
        output_queue << operator_stack.pop while operator_stack.last.type != Token::LEFT_PARENTHESIS

        operator_stack.pop
      end
    end

    output_queue << operator_stack.pop while operator_stack.any?

    output_queue
  end
end
