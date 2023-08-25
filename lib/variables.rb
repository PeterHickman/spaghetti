# frozen_string_literal: true

class Variables
  def initialize(prefix, indexed = false)
    @prefix = prefix
    @indexed = indexed

    @index = 0
    @data = {}
  end

  def <<(name)
    @data[name] = make_key(name) unless @data.key?(name)
  end

  def [](name)
    @data[name] = make_key(name) unless @data.key?(name)

    @data[name]
  end

  def each
    @data.each do |k, v|
      yield k, v
    end
  end

  private

  def make_key(name)
    if @indexed
      @index += 1
      format('%s_%05d', @prefix, @index)
    else
      format('%s_%s', @prefix, name.downcase)
    end
  end
end
