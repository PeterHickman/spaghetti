# frozen_string_literal: true

class Translate
  attr :fv, :fs, :ss

  def initialize
    @g = Gensym.new
    @fv = Variables.new('fv')
    @fs = Variables.new('fs', true)
    @ss = Variables.new('ss', true)
  end

  def process(line_number, tokens)
    @line_number = line_number

    t = tokens.shift

    panic "The first token after the line number should be a keyword not #{t}" if t.type != Token::KEYWORD

    handle_keyword(t, tokens)
  end

  private

  def handle_keyword(kw, tokens)
    actions = []

    case kw.value
    when 'REM'    then actions += kw_rem(tokens)
    when 'LET'    then actions += kw_let(tokens)
    when 'PRINT'  then actions += kw_print(tokens)
    when 'END'    then actions += kw_end(tokens)
    when 'IF'     then actions += kw_if(tokens)
    when 'GOTO'   then actions += kw_goto(tokens)
    when 'GOSUB'  then actions += kw_gosub(tokens)
    when 'RETURN' then actions += kw_return(tokens)
    when 'INPUT'  then actions += kw_input(tokens)
    else
      panic "How to handle the keyword #{kw.value}"
    end

    actions
  end

  def kw_input(tokens)
    actions = []

    x = tokens.shift
    if x.type == Token::STRING
      actions << [@g.get(@line_number), 'prints', @ss[x.value]]
      x = tokens.shift
    end

    actions << [@g.get(@line_number), 'inputf', @fv[x.value]]

    actions
  end

  def kw_if(tokens)
    c = []
    loop do
      break if tokens.first.type == Token::KEYWORD

      c << tokens.shift
    end

    actions = []
    Condition.parse(c).each do |t|
      case t.type
      when Token::FLOAT
        actions << [@g.get(@line_number), 'pushf', @fs[t.value]]
      when Token::FLOAT_VARIABLE
        actions << [@g.get(@line_number), 'pushf', @fv[t.value]]
        if t.negative
          actions << [@g.get(@line_number), 'pushf', @fs[-1.0]]
          actions << [@g.get(@line_number), '*']
        end
      when Token::COMPARISON, Token::EQUAL
        actions << [@g.get(@line_number), t.value]
      else
        panic t
      end
    end
    actions << [@g.get(@line_number), 'pushf', @fs[1.0]]
    actions << [@g.get(@line_number), 'cmp']

    next_label = @g.get(@line_number)

    actions << [@g.get(@line_number), 'jf', next_label]

    kw = tokens.shift
    actions += handle_keyword(kw, tokens)

    actions << [next_label, 'nop']

    actions
  end

  def kw_goto(tokens)
    target_label = @g.label(tokens.first.value, 1)
    [[@g.get(@line_number), 'jump', target_label]]
  end

  def kw_gosub(tokens)
    target_label = @g.label(tokens.first.value, 1)
    current_label = @g.get(@line_number)

    [
      [current_label, 'pushr', current_label],
      [@g.get(@line_number), 'jump', target_label]
    ]
  end

  def kw_return(tokens)
    [[@g.get(@line_number), 'popr']]
  end

  def kw_end(_tokens)
    [[@g.get(@line_number), 'exit']]
  end

  def kw_print(tokens)
    actions = []

    last_index = tokens.size - 1
    add_newline = true

    tokens.each_with_index do |x, i|
      case x.type
      when Token::STRING
        @ss << x.value
        actions << [@g.get(@line_number), 'prints', @ss[x.value]]
      when Token::FLOAT
        actions << [@g.get(@line_number), 'printf', @fs[x.value]]
      when Token::FLOAT_VARIABLE
        actions << [@g.get(@line_number), 'printf', @fv[x.value]]
      when Token::SEMI_COLON
        if i != last_index
          panic 'PRINT can only have ; at the end'
        else
          add_newline = false
        end
      else
        panic "PRINT needs to handle #{x.type}"
      end
    end

    actions << [@g.get(@line_number), 'printnl'] if add_newline

    actions
  end

  def kw_rem(_tokens)
    [[@g.get(@line_number), 'nop']]
  end

  def kw_let(tokens)
    actions = []

    # The first is a variable (waiting for string variables and arrays)
    v = tokens.shift
    panic "LET requires a variable as the first argument at #{@line_number}" if v.type != Token::FLOAT_VARIABLE

    # The next things should be =
    e = tokens.shift
    panic "LET requires a = after the variable at #{@line_number}" if e.type != Token::EQUAL

    # Here comes the expression
    Expression.process(tokens).each do |x|
      case x.type
      when Token::FLOAT
        actions << [@g.get(@line_number), 'pushf', @fs[x.value]]
      when Token::FLOAT_VARIABLE
        actions << [@g.get(@line_number), 'pushf', @fv[x.value]]
        if x.negative
          actions << [@g.get(@line_number), 'pushf', @fs[-1.0]]
          actions << [@g.get(@line_number), '*']
        end
      when Token::MATH, Token::FUNCTION
        actions << [@g.get(@line_number), x.value]
      else
        panic "How should LET handle #{x.type}"
      end
    end

    # Pop the result off the stack and into a variable
    actions << [@g.get(@line_number), 'popf', @fv[v.value]]

    actions
  end

  def panic(text)
    puts "ERROR: #{text}"
    exit 1
  end
end
