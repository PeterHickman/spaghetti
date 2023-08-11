# frozen_string_literal: true

require 'translate_base'

class TranslateBasicCPU < TranslateBase
  ##
  # This translates the basic into my custom cpu
  ##

  def output(fh)
    if @debug
      @source.each do |line|
        next if line[0] == 0

        p line
      end
    end

    @variables_float = Set.new
    @referenced_labels = Set.new

    load

    fh.puts '           ; Variables:'
    @variables_float.sort.each do |k|
      fh.puts "           ; $FLOAT #{k}"
    end
    fh.puts

    fh.puts '           ; Static Strings:'
    @static_strings.each do |s, k|
      fh.puts "           ; $STATIC_STRING #{k} #{s}"
    end
    fh.puts

    fh.puts '           ; Program:'
    @actions.each do |row|
      if row[0].nil?
        fh.puts "           ; #{row[1]}"
      else
        l = @referenced_labels.include?(row[0]) ? row[0] : ''
        fh.puts format('%-10s %s', l, row[1..-1].join(' '))
      end
    end
    fh.puts
  end

  private

  def handle_expression(args)
    actions = []

    ShuntExpression.parse(args, @debug).each do |e|
      case e.type
      when 'number'
        actions << [@g.get(@ln), 'pushi', e.value]
      when 'variable'
        if Utils.unary?(e.value)
          actions << [@g.get(@ln), 'pushi', -1.0]
          actions << [@g.get(@ln), 'pushv', e.value[1..-1]]
          actions << [@g.get(@ln), '*']
        else
          actions << [@g.get(@ln), 'pushv', e.value]
        end
      when 'operator'
        actions << [@g.get(@ln), e.value]
      when 'function'
        actions << [@g.get(@ln), e.value]
      else
        panic "Unknown expression type #{e.type}"
      end
    end

    actions
  end

  def handle_conditions(args)
    o = ShuntCondition.parse(args, @debug)

    actions = []

    o.each do |e|
      case e.type
      when 'number'
        actions << [@g.get(@ln), 'pushi', e.value]
      when 'variable'
        actions << [@g.get(@ln), 'pushv', e.value.upcase]
      when 'conditional', 'boolean'
        actions << [@g.get(@ln), e.value]
      end
    end

    actions
  end

  def f_print(args)
    actions = []

    last_index = args.size - 1

    args.each_with_index do |a, i|
      if Utils.var?(a)
        @variables_float << a.upcase
        actions << [@g.get(@ln), 'printv', a.upcase]
      elsif Utils.float?(a)
        actions << [@g.get(@ln), 'printi', a]
      elsif Utils.text?(a)
        actions << [@g.get(@ln), 'prints', @static_strings.add(a)]
      elsif match?(a, ';')
        panic "PRINT only uses ; at the end of the list at #{@ln}" unless i == last_index
      else
        panic "Dont know how to print [#{a}]"
      end
      actions << [@g.get(@ln), 'prints', @static_strings.add('" "')] if i != last_index
    end

    actions << [@g.get(@ln), 'printnl'] unless args.any? && match?(args.last, ';')

    actions
  end

  def f_goto(args)
    target_line = args.shift
    panic "Cannot GOTO unknown line [#{target_line}] at #{@ln}" unless @all_lns.include?(target_line)
    target_label = @g.label(target_line)
    @referenced_labels << target_label
    [[@g.get(@ln), 'goto', target_label]]
  end

  def f_end(_args)
    [[@g.get(@ln), 'exit', 0]]
  end

  def f_for(args)
    actions = []
    step_value = 1

    ##
    # The looping variable
    ##
    looping_variable = should_be_var(args.shift)
    @variables_float << looping_variable

    should_be(args.shift, '=')

    ##
    # The start value or variable
    ##
    x = args.shift
    start_is_var = false

    if Utils.var?(x)
      start_value = should_be_var(x)
      start_is_var = true
    elsif Utils.float?(x)
      start_value = should_be_float(x)
    else
      panic "Expected var or float from at #{@ln}"
    end

    should_be(args.shift.upcase, 'TO')

    ##
    # The end value or variable
    ##
    x = args.shift
    end_is_var = false

    if Utils.var?(x)
      end_value = should_be_var(x)
      end_is_var = true
    elsif Utils.float?(x)
      end_value = should_be_float(x)
    else
      panic "Expected var or float to at #{@ln}"
    end

    ##
    # The step value or variable if given
    if args.size == 2
      should_be(args.shift.upcase, 'STEP')

      x = args.shift
      step_is_var = false

      if Utils.var?(x)
        step_value = should_be_var(x)
        step_is_var = true
      elsif Utils.float?(x)
        step_value = should_be_float(x)
      else
        panic "Expected var or float for step at #{@ln}"
      end
    end

    if start_is_var == false && end_is_var == false && step_is_var == false
      ##
      # Without knowing the runtime values we will never know
      ##
      if step_value.zero?
        panic "Cannot have a step of 0 at #{@ln}"
      elsif step_value.positive?
        if start_value > end_value
          panic "Cannot loop from [#{start_value}] to [#{end_value}] with a positive step at #{@ln}"
        end
      elsif end_value > start_value
        panic "Cannot loop from [#{start_value}] to [#{end_value}] with a negative step at #{@ln}"
      end
    end

    actions << if start_is_var
                 [@g.get(@ln), 'setvv', looping_variable, start_value]
               else
                 [@g.get(@ln), 'setvi', looping_variable, start_value]
               end
    content_of_the_loop = @g.get(@ln)
    @referenced_labels << content_of_the_loop
    actions << [content_of_the_loop, 'nop']
    @for_stack << ForData.new(looping_variable, end_value, content_of_the_loop, step_value, end_is_var, step_is_var)

    actions
  end

  def f_next(args)
    d = @for_stack.pop

    looping_variable = should_be_var(args.shift)
    panic "NEXT expected [#{d.variable}] got [#{looping_variable}] at #{@ln}" unless d.variable == looping_variable

    actions = []

    actions << [@g.get(@ln), 'pushv', d.variable]
    actions << if d.step_is_var
                 [@g.get(@ln), 'pushv', d.step]
               else
                 [@g.get(@ln), 'pushi', d.step]
               end
    actions << [@g.get(@ln), '+']
    actions << [@g.get(@ln), 'popv', d.variable]
    actions << [@g.get(@ln), 'pushv', d.variable]

    actions << if d.target_is_var
                 [@g.get(@ln), 'pushv', d.target]
               else
                 [@g.get(@ln), 'pushi', d.target]
               end
    actions << [@g.get(@ln), 'cmp']

    @referenced_labels << d.label
    actions << if d.step_is_var || d.step.positive?
                 [@g.get(@ln), 'jle', d.label]
               else
                 [@g.get(@ln), 'jge', d.label]
               end

    actions
  end

  def f_let(args)
    actions = []

    variable_to_set = should_be_var(args.shift)
    should_be(args.shift, '=')

    actions += handle_expression(args)

    actions << [@g.get(@ln), 'popv', variable_to_set]

    actions
  end

  def f_rem(_args)
    [[@g.get(@ln), 'nop']]
  end

  def f_gosub(args)
    current_ln = @g.get(@ln)
    target_line = args.shift
    panic "Cannot GOSUB unknown line [#{target_line}] at #{@ln}" unless @all_lns.include?(target_line)
    target_label = @g.label(target_line)
    @referenced_labels << target_label
    @referenced_labels << current_ln

    [
      [current_ln, 'rpush', current_ln],
      [@g.get(@ln), 'goto', target_label]
    ]
  end

  def f_return(_args)
    [[@g.get(@ln), 'return']]
  end

  def f_input(args)
    actions = []

    x = args.shift
    if Utils.text?(x)
      # There is a prompt
      actions << [@g.get(@ln), 'prints', @static_strings.add(x)]
      actions << [@g.get(@ln), 'prints', @static_strings.add('" "')]

      x = args.shift
    end

    variable_to_set = should_be_var(x)
    @variables_float << variable_to_set

    actions << [@g.get(@ln), 'inputi', variable_to_set]

    actions
  end

  def f_if(args)
    c_args = read_upto(args, %w[THEN GOTO GOSUB])

    actions = handle_conditions(c_args)
    actions << [@g.get(@ln), 'pushi', 1] # We are using 1 for true and 0 for false
    actions << [@g.get(@ln), 'cmp']

    n = args.shift
    if match?(n, 'THEN') || match?(n, 'GOTO')
      ##
      # The THEN or GOTO action
      ##
      i2 = args.shift
      panic "Cannot GOTO unknown line [#{i2}] at #{@ln}" unless @all_lns.include?(i2)
      target_ln = @g.label(i2)
      @referenced_labels << target_ln
      actions << [@g.get(@ln), 'jt', target_ln]
    elsif match?(n, 'GOSUB')
      ##
      # The GOSUB action
      ##
      current_ln = @g.get(@ln)

      i2 = args.shift
      panic "Cannot GOTO unknown line [#{i2}] at #{@ln}" unless @all_lns.include?(i2)
      target_ln = @g.label(i2)

      next_line = @g.get(@ln)
      @referenced_labels << next_line
      @referenced_labels << current_ln
      @referenced_labels << target_ln

      actions << [@g.get(@ln), 'jf', next_line]
      actions << [current_ln, 'rpush', current_ln]
      actions << [@g.get(@ln), 'goto', target_ln]

      actions << [next_line, 'nop']
    else
      panic "Expection one of THEN or GOTO or GOSUB at #{@ln}"
    end

    actions
  end

  def f_while(args)
    loop_label = @g.get(@ln)
    exit_label = @g.get(@ln)

    @referenced_labels << loop_label
    @referenced_labels << exit_label

    actions = []
    actions << [loop_label, 'nop']
    actions += handle_conditions(args)
    actions << [@g.get(@ln), 'pushi', 1] # We are using 1 for true and 0 for false
    actions << [@g.get(@ln), 'cmp']
    actions << [@g.get(@ln), 'jf', exit_label]

    @while_stack << [exit_label, loop_label]

    actions
  end

  def f_wend(_args)
    actions = []

    exit_label, loop_label = @while_stack.pop

    actions << [@g.get(@ln), 'goto', loop_label]
    actions << [exit_label, 'nop']

    actions
  end

  def f_repeat(_args)
    loop_label = @g.get(@ln)
    @repeat_stack << loop_label

    [[loop_label, 'nop']]
  end

  def f_until(args)
    actions = handle_conditions(args)
    actions << [@g.get(@ln), 'pushi', 1] # We are using 1 for true and 0 for false
    actions << [@g.get(@ln), 'cmp']

    loop_label = @repeat_stack.pop
    @referenced_labels << loop_label

    actions << [@g.get(@ln), 'jf', loop_label]

    actions
  end
end
