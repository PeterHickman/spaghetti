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
end
