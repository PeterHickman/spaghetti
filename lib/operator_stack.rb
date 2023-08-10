class OperatorStack
  def initialize
    @data = []
  end

  def <<(value)
    @data << value
  end

  def any?
    @data.any?
  end

  def empty?
    @data.empty?
  end

  def pop
    @data.pop
  end

  def type
    return nil if @data.empty?

    @data.last.type
  end

  def precedence
    return nil if @data.empty?

    @data.last.precedence
  end
end
