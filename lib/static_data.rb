# frozen_string_literal: true

class StaticData
  def initialize(prefix)
    @prefix = prefix

    @data = {}
    @index = 1
  end

  def add(text)
    unless @data.key?(text)
      k = format('%s_%04d', @prefix, @index)
      @index += 1
      @data[text] = k
    end

    @data[text]
  end

  def each(suffix = '')
    @data.each do |k, v|
      yield k, v + suffix
    end
  end
end
