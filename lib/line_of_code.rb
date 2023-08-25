# frozen_string_literal: true

class LineOfCode
  attr_reader :source, :line_number, :code

  def initialize(text)
    @source = text

    tokens = SplitLine.process(text)

    raise 'No tokens in the line of code' if tokens.empty?

    token = tokens.shift

    unless token.type == Token::FLOAT && token.value.positive?
      raise "The first token needs to be a line number, not #{token}"
    end

    @line_number = token.value

    ##
    # The oddness of parsing basic. Most parsers use a different style of
    # tokenizing and can parse '10FORN=1TO10STEP3' without error. Thus
    # the statement for a comment, REM, can merge with the rest of the text
    # so we need to check for this too
    ##
    if tokens.first.type == Token::KEYWORD && tokens.first.value == 'REM'
      tokens = [Token.new('REM')]
    elsif tokens.first.value.upcase.start_with?('REM')
      tokens = [Token.new('REM')]
    end

    ##
    # The next issue is that basic can have multiple statements one a line
    # that are seperated with a colon
    ##
    @code = []

    x = []
    tokens.each do |t|
      if t.type == Token::COLON
        @code << x.dup
        x.clear
      else
        x << t
      end
    end

    @code << x
  end
end
