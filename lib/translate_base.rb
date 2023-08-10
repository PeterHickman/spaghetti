class TranslateBase
  ##
  # This translates the basic into my custom cpu
  ##

  PADDED_CHARS = %w[( ) + - * / ^]

  NOT_UNARY = %w[= ( + - / * > < STEP]

  def initialize(debug = false)
    @debug = debug

    @g = Gensym.new
    @source = []
    @old_ln = -1
    @all_lns = Set.new
    @actions = []
    @for_stack = []
    @while_stack = []
    @repeat_stack = []
    @static_strings = StaticData.new('ss')
    @static_floats = StaticData.new('sf')
    @variable_floats = StaticData.new('vf')
    @ln = nil
  end

  def read(line)
    line.chomp!

    return if line == ''

    x = clean_tokens(line)

    ln = x.shift

    if line_number?(ln)
      @all_lns << ln
      ln = ln.to_i
      panic "Line number [#{ln}] out of order" if ln <= @old_ln
      @old_ln = ln
    end

    cmd = x.shift.upcase

    panic "Unknown command #{cmd} at #{ln}" unless Utils::COMMANDS.include?(cmd)

    @source << [0, line]
    @source << [ln, cmd, x]
  end

  def output(fh)
    raise "You need to implment this"
  end

  private

  def clean_tokens(line)
    string_mode = false

    l = []
    t = ''

    (0...line.size).each do |i|
      c = line[i]

      if string_mode
        t << c

        if c == '"'
          l << t.dup if t.size.positive?
          t.clear
          string_mode = false
        end
      elsif c == '"'
        string_mode = true
        if t.size.positive?
          l << t.dup
        else
          t.clear
          t << c
        end
      elsif c == ' '
        l << pad_chars(t).map(&:upcase) if t.size.positive?
        t.clear
      else
        t << c
      end
    end

    l << pad_chars(t).map(&:upcase) if t.size.positive?

    fuck_unary_minus(l.flatten.reject { |x| x.empty? })
  end

  def pad_chars(args)
    x = args.dup
    PADDED_CHARS.each do |p|
      x.gsub!(p, " #{p} ")
    end
    x.split(/\s+/)
  end

  def fuck_unary_minus(list)
    l = []

    list.each_with_index do |item, i|
      if item == '-'
        if l.empty? || NOT_UNARY.include?(l[-1])
          list[i+1] = '-' + list[i+1]
        else
          l << item
        end
      else
        l << item
      end
    end

    l
  end

  def panic(message)
    if @ln
      puts "#{@ln}: #{message}"
    else
      puts message
    end

    exit 1
  end

  def load
    @actions.clear
    @for_stack.clear
    @while_stack.clear
    @repeat_stack.clear
    @ln = nil

    @source.each do |s|
      @ln, cmd, args = s

      if @ln.zero?
        @actions << [nil, cmd]
        next
      end

      @actions += case cmd
                  when 'END' then    f_end(args)
                  when 'FOR' then    f_for(args)
                  when 'GOTO' then   f_goto(args)
                  when 'NEXT' then   f_next(args)
                  when 'PRINT' then  f_print(args)
                  when 'LET' then    f_let(args)
                  when 'REM' then    f_rem(args)
                  when 'GOSUB' then  f_gosub(args)
                  when 'RETURN' then f_return(args)
                  when 'INPUT' then  f_input(args)
                  when 'IF' then     f_if(args)
                  when 'WHILE' then  f_while(args)
                  when 'WEND' then   f_wend(args)
                  when 'REPEAT' then f_repeat(args)
                  when 'UNTIL' then  f_until(args)
                  else
                    panic("Dont know how to handle [#{cmd}] at #{@ln}")
                  end
    end
  end

  def line_number?(text)
    text =~ /^\d+$/
  end

  def text?(text)
    text.start_with?('"') && text.end_with?('"')
  end

  def match?(actual, expected)
    actual.upcase == expected.upcase
  end

  def should_be(text, expected)
    panic "Expected [#{expected}] got [#{text}] at #{@ln}" unless match?(text, expected)
  end

  def should_be_one_of(text, expected)
    expected.each do |pattern|
      return pattern if match?(pattern, text)
    end

    panic "Expected one of #{expected} got [#{text}]"
  end

  def should_be_float(text)
    panic "Expected a float not [#{text}] at #{@ln}" unless Utils.float?(text)

    text.to_f
  end

  def should_be_var(text)
    panic "Not a suitable variable name [#{text}] at #{@ln}" unless Utils.var?(text.upcase)

    text.upcase
  end

  def handle_expression(args)
    raise "You need to implment this"
  end

  def handle_conditions(args)
    raise "You need to implment this"
  end

  def read_upto(args, stop_words)
    l = []
    while args.any?
      break if stop_words.include?(args.first.upcase)
      l << args.shift
    end
    l
  end

  def f_print(args)
    raise "Implement PRINT"
  end

  def f_goto(args)
    raise "Implement GOTO"
  end

  def f_end(_args)
    raise "Implement END"
  end

  def f_for(args)
    raise "Implement FOR"
  end

  def f_next(args)
    raise "Implement NEXT"
  end

  def f_let(args)
    raise "Implement LET"
  end

  def f_rem(_args)
    raise "Implement REM"
  end

  def f_gosub(args)
    raise "Implement GOSUB"
  end

  def f_return(_args)
    raise "Implement RETURN"
  end

  def f_input(args)
    raise "Implement INPUT"
  end

  def f_if(args)
    raise "Implement IF"
  end

  def f_while(args)
    raise "Implement WHILE"
  end

  def f_wend(args)
    raise "Implement WEND"
  end

  def f_repeat(args)
    raise "Implement REPEAT"
  end

  def f_until(args)
    raise "Implement UNTIL"
  end
end
