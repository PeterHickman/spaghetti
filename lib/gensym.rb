# frozen_string_literal: true

class Gensym
  def initialize
    @index = 1

    @last_ln = -99_999
  end

  def get(ln)
    if ln != @last_ln
      @index = 1
      @last_ln = ln
    end

    x = label(ln, @index)
    @index += 1
    x
  end

  def label(ln, index = 1)
    format('L%04d_%04d', ln, index)
  end
end
