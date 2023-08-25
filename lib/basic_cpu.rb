# frozen_string_literal: true

class BasicCPU
  def initialize(debug = false)
    @debug = debug

    @source = []
    @labels = {}
    @variables_float = {}
    @static_strings = {}
  end

  def load(filename)
    File.open(filename, 'r').each do |line|
      load_line(line)
    end
  end

  def run
    @index = 0

    ##
    # The guts of the basic cpu
    ##
    @stack = []
    @flags = { eq: false, lt: false, gt: false }

    show_state

    loop do
      row = @source[@index]

      p row if @debug

      # Run off the end of the program
      break if row.nil?

      cmd = row[0]

      case cmd
      when 'printf'  then print_float(@variables_float[row[1]])
      when 'printnl' then puts
      when 'prints'  then print(@static_strings[row[1]])

      when 'jump'    then @index = @labels[row[1]] - 1
      when 'exit'    then break
      when 'pushr'   then @stack << row[1]
      when 'popr'    then @index = @labels[@stack.pop] + 1
      # when 'jlt'     then @index = @labels[row[1]] - 1 if @flags[:lt]
      # when 'jle'     then @index = @labels[row[1]] - 1 if @flags[:lt] || @flags[:eq]
      # when 'jgt'     then @index = @labels[row[1]] - 1 if @flags[:gt]
      # when 'jge'     then @index = @labels[row[1]] - 1 if @flags[:gt] || @flags[:eq]
      when 'jt'      then @index = @labels[row[1]] - 1 if @flags[:eq]
      when 'jf'      then @index = @labels[row[1]] - 1 unless @flags[:eq]

      when 'cmp'     then cmp
      when 'nop' # Do nothing
      when 'inputf'  then @variables_float[row[1]] = get_float
      when 'pushf'   then @stack << @variables_float[row[1]]
      when 'popf'    then @variables_float[row[1]] = @stack.pop
        ##
        # These are the available mathematial operations from BASIC
        # They operate take values off the stack and push the result
        ##
      when '*'       then math(cmd)
      when '/'       then math(cmd)
      when '+'       then math(cmd)
      when '-'       then math(cmd)
      when '^'       then math(cmd)
        ##
        # These are the available comparison operation from BASIC
        # They operate take values off the stack and push the result
        # with 1.0 being true and 0.0 being false. There is no
        # boolean datatype even internally
        ##
      when '<'       then comp(cmd)
      when '>'       then comp(cmd)
      when '<='      then comp(cmd)
      when '>='      then comp(cmd)
      when '='       then comp(cmd)
      when '<>'      then comp(cmd)
        ##
        # Condiditionaly
        ##
      when 'OR'
        a = @stack.pop
        b = @stack.pop
        r = a == 1 || b == 1
        @stack << (r ? 1 : 0)
      when 'AND'
        a = @stack.pop
        b = @stack.pop
        r = a == b && a == 1
        @stack << (r ? 1 : 0)

        ##
        # The functions that we support
        ##
      when 'RND'
        v = @stack.pop
        @stack << (v <= 1.0 ? rand(0) : (rand(v) + 1))
      when 'INT'
        @stack << @stack.pop.to_i.to_f
      when 'SGN'
        @stack << (@stack.pop <=> 0)
      when 'ABS'
        @stack << @stack.pop.abs
      when 'LOG'
        @stack << Math.log(@stack.pop)
      when 'COS'
        @stack << Math.cos(@stack.pop)
      when 'SIN'
        @stack << Math.sin(@stack.pop)
      when 'TAN'
        @stack << Math.tan(@stack.pop)
      when 'MAX'
        @stack << [@stack.pop, @stack.pop].max
      when 'MIN'
        @stack << [@stack.pop, @stack.pop].min
      when 'SQR'
        @stack << Math.sqrt(@stack.pop)
      else
        puts "BasicCPU: Unknown opt [#{cmd}] [#{row}]"
        exit 1
      end

      show_state

      @index += 1
    end
  end

  private

  def load_line(line)
    line.chomp!

    if line.include?('; $FLOAT_VARIABLE')
      populate_float_variable(line)
    elsif line.include?('; $STRING_STATIC')
      populate_static_string(line)
    elsif line.include?('; $FLOAT_STATIC')
      populate_float_static(line)
    elsif line =~ /^\s*;/ || line == ''
      # A comment or blank line
    else
      x = line.split(/\s+/).map { |i| float?(i) ? i.to_f : i }
      @labels[x.first] = @source.size
      @source << x[1..-1]
    end
  end

  def math(op)
    a = @stack.pop
    b = @stack.pop

    case op
    when '*' then @stack << b * a
    when '/' then @stack << b / a
    when '+' then @stack << b + a
    when '-' then @stack << b - a
    when '^' then @stack << b**a
    end
  end

  def comp(op)
    a = @stack.pop
    b = @stack.pop

    r = case op
        when '<'  then b < a
        when '>'  then b > a
        when '<=' then b <= a
        when '>=' then b >= a
        when '='  then b == a
        when '<>' then b != a
        end

    @stack << (r ? 1 : 0)
  end

  def cmp
    a = @stack.pop
    b = @stack.pop
    c = a <=> b

    @flags[:eq] = c.zero?
    @flags[:lt] = c.positive?
    @flags[:gt] = c.negative?
  end

  def get_float
    i = 0
    loop do
      s = STDIN.gets
      if float?(s)
        i = s.to_f
        break
      end
      puts 'Input not an number!'
    end

    i
  end

  def print_float(v)
    if v.to_i.to_f == v
      print(v.to_i)
    else
      print(v)
    end
  end

  def show_state
    return unless @debug

    puts
    puts "I: #{@index} #{@source[@index]}"
    puts "F: #{@flags}"
    puts "S: #{@stack}"
    puts "V: #{@variables_float}"
    puts
  end

  def populate_float_variable(text)
    x = text.split('$FLOAT_VARIABLE').last.strip
    @variables_float[x] = 0.0
  end

  def populate_float_static(text)
    k, v = text.split('$FLOAT_STATIC').last.strip.split(/\s+/, 2)
    @variables_float[k] = v.to_f
  end

  def populate_static_string(text)
    k, v = text.split('$STRING_STATIC').last.strip.split(/\s+/, 2)
    @static_strings[k] = v[1..-2]
  end

  def float?(text)
    text =~ /^-?\d+$/ || text =~ /^-?\d*\.\d*$/ || text =~ /^-?\d+\.\d+[Ee]\-\d+$/ || text =~ /^-?\d+\.\d+[Ee]\+\d+$/ || text =~ /^-?\d+[Ee]\-\d+$/ || text =~ /^-?\d+[Ee]\+\d+$/
  end
end
