# frozen_string_literal: true

# https://en.wikipedia.org/wiki/Shunting_yard_algorithm

class Expression
  def self.process(tokens)
    @output_queue = []
    @operator_stack = []

    while tokens.any?
      token = tokens.shift

      case token.type
      when Token::FLOAT, Token::FLOAT_VARIABLE
        @output_queue << token
      when Token::FUNCTION
        @operator_stack << token
      when Token::MATH
        @output_queue << @operator_stack.pop while @operator_stack.any? && long_winded(token, @operator_stack.last)
        @operator_stack << token
      when Token::COMMA
        while @operator_stack.any? @operator_stack.last.type != Token::LEFT_PARENTHESIS
          @output_queue << @operator_stack.pop
        end
      when Token::LEFT_PARENTHESIS
        @operator_stack << token
      when Token::RIGHT_PARENTHESIS
        while @operator_stack.any? && @operator_stack.last.type != Token::LEFT_PARENTHESIS
          @output_queue << @operator_stack.pop
        end
        if @operator_stack.last.type != Token::LEFT_PARENTHESIS
          puts "Missing '('"
          exit 1
        end
        @operator_stack.pop
        @output_queue << @operator_stack.pop if @operator_stack.any? && @operator_stack.last.type == Token::FUNCTION
      else
        puts "How to handle token #{token}"
        exit 1
      end
    end

    while @operator_stack.any?
      if @operator_stack.last.type == Token::LEFT_PARENTHESIS
        puts "Too many '('"
        exit 1
      end

      @output_queue << @operator_stack.pop
    end

    @output_queue
  end

  def self.long_winded(o1, o2)
    o2.type != Token::LEFT_PARENTHESIS && (o2.precedence > o1.precedence || (o1.precedence == o2.precedence && o1.associativity == Token::LEFT))
  end
end
