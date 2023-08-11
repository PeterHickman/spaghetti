# frozen_string_literal: true

require 'translate_base'

class TranslateLinuxAmd64 < TranslateBase
  ##
  # This translates the basic into my custom cpu
  ##

  def output(fh)
    if @debug
      @source.each do |line|
        p line
      end
    end

    @externals = Set.new
    @referenced_labels = Set.new

    load

    fh.puts '; nasm -felf64 fred.asm -o fred.o'
    fh.puts '; gcc -no-pie fred.o -o fred'
    fh.puts '; ./fred'
    fh.puts

    fh.puts '           section .data'
    @static_strings.each(':') do |v, l|
      fh.puts format('%-10s db %s,0', l, v)
    end
    @static_floats.each(':') do |v, l|
      fh.puts format('%-10s dq %f', l, v)
    end
    fh.puts '           section .bss'
    @variable_floats.each(':') do |_, l|
      fh.puts '%-10s resq 1' % l
    end
    fh.puts

    fh.puts '           global main'
    @externals.sort.each do |e|
      fh.puts "           extern #{e}"
    end
    fh.puts

    fh.puts '           section .text'
    fh.puts 'main:'
    @actions.each do |row|
      if row[0].nil?
        fh.puts "           ; #{row[1]}"
      else
        l = @referenced_labels.include?(row[0]) || ''
        fh.puts format('%-10s %s', l, row[1..-1].join(' '))
      end
    end
    fh.puts
  end

  private

  def handle_expression(args)
    actions = []

    ShuntExpression.parse(args).each do |e|
      case e.type
      when 'number'
        fl = @static_floats.add(e.value)
        actions << [@g.get(@ln), 'pushq', fl]
      when 'variable'
        vl = @variable_floats.add(e.value[1..-1])

        if Utils.unary?(e.value)
          fl = @static_floats.add(-1.0)
          actions << [@g.get(@ln), 'pushq', fl]
          actions << [@g.get(@ln), 'pushq', "[#{vl}]"]
          actions << [@g.get(@ln), '*']
        else
          actions << [@g.get(@ln), 'pushq', "[#{vl}]"]
        end
      when 'operator'
        actions << [@g.get(@ln), e.value]
      when 'function'
        # actions << [@g.get(@ln), e.value]
      else
        panic "Unknown expression type #{e.type}"
      end
    end

    actions
  end

  def f_print_string(s)
    l = @static_strings.add(s)

    @externals << 'printf'

    actions = []

    actions << [@g.get(@ln), 'mov rdi,', l]
    actions << [@g.get(@ln), 'xor rax, rax']
    actions << [@g.get(@ln), 'call printf']

    actions
  end

  def f_print_float(f)
    @externals << 'printf'

    fl = @static_floats.add(f)
    actions = []

    fmt = @static_strings.add('"%f"')

    actions << [@g.get(@ln), 'mov rdi,', fmt]
    actions << [@g.get(@ln), 'movq xmm0, qword', "[#{fl}]"]
    actions << [@g.get(@ln), 'mov rax, 1']

    actions << [@g.get(@ln), 'call printf']

    actions
  end

  def f_print(args)
    actions = []

    last_index = args.size - 1

    args.each_with_index do |a, i|
      if var?(a)
        # @variables << a.upcase
        # actions << [@g.get(@ln), 'printv', a.upcase]
      elsif Utils.float?(a)
        actions += f_print_float(a)
      elsif Utils.text?(a)
        actions += f_print_string(a)
      elsif match?(a, ';')
        panic "PRINT only uses ; at the end of the list at #{@ln}" unless i == last_index
      else
        panic "Dont know how to print [#{a}]"
      end

      actions += f_print_string('" "') if i != last_index
    end

    actions += f_print_string('10') unless match?(args.last, ';')

    actions
  end

  def f_end(_args)
    [[@g.get(@ln), 'ret']]
  end

  def f_let(args)
    actions = []

    variable_to_set = should_be_var(args.shift)

    vl = @variable_floats.add(variable_to_set)
    should_be(args.shift, '=')

    actions += handle_expression(args)

    actions << [@g.get(@ln), 'popq', variable_to_set]

    actions
  end
end
