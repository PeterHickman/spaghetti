# REQUIRED = { '--host' => '=', '--source' => '=', '--dest' => '=', '--match' => '[]', '--ignore' => '[]' }

class OptsSelected
  def initialize
    @data = {}
  end

  def []=(k, v)
    @data[k[2..-1]] = v
  end

  def method_missing(m, *args, &block)
    s = m.to_s
    if @data.include?(s)
      @data[s]
    else
      false
    end
  end
end

class Opts
  def self.options(cmd, valid)
    args = []
    opts = OptsSelected.new

    valid.each do |k, v|
      case v
      when '!'
        opts[k] = false
      when '[]'
        opts[k] = []
      end
    end

    while cmd.any?
      x = cmd.shift

      if valid.key?(x)
        case valid[x]
        when '!' # Is a flag
          opts[x] = true
        when '=' # Single value
          opts[x] = cmd.shift
        when '[]' # Multiple values
          y = cmd.shift
          if y.start_with?('@')
            opts[x] += file_as_list(y[1..-1])
          else
            opts[x] << y
          end
        end
      elsif x.start_with?('--')
        puts "Unknown option [#{x}]".red
        exit 1
      else
        args << x
      end
    end

    [opts, args]
  end

  def self.file_as_list(filename)
    unless File.exist?(filename)
      puts "File [#{filename}] does not exist".red
      exit 1
    end

    l = []

    File.open(filename).each do |line|
      line.chomp!

      next if line.start_with?('#')
      next if line == ''

      l << line
    end

    l
  end
end

# opts, args = Opts.options(ARGV, REQUIRED)
