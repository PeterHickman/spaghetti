require 'token'
require 'expression'
require 'line_of_code'
require 'split_line'

def compare(actual, expected)
  expect(actual.map(&:value)).to eq(expected)
end

def code(line)
  Expression.process(LineOfCode.new(line).code.first[3..-1])
end

RSpec.describe Expression do
  context 'single value' do
    it 'pushed one item' do
      actual = code('10 LET A = 1')
      compare(actual, [1])
    end

    it 'add two value' do
      actual = code('10 LET A = 1 + 2')
      compare(actual, [1, 2, '+'])
    end

    it 'with parenthesis' do
      actual = code('10 LET A = (1 * 2) + (7 / 3)')
      compare(actual, [1, 2, '*', 7, 3, '/', '+'])
    end

    it 'complex' do
      actual = code('10 LET A = 3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3')
      compare(actual, [3, 4, 2, '*', 1, 5, '-', 2, 3, '^', '^', '/', '+'])
    end

    it 'with functions' do
      actual = code('10 LET A = sin(max(2,3) / 3 * PI)')
      compare(actual, [2, 3, 'MAX', 3, '/', 'PI', '*', 'SIN'])
    end

    it 'unary check 1' do
      actual = code('10 LET A = (-3 * 2) / 2')
      compare(actual, [-3.0, 2.0, '*', 2.0, '/'])
    end

    it 'unary check 2' do
      actual = code('10 LET A = 1 + -1')
      compare(actual, [1.0, -1.0, '+'])
    end

    it 'function with two arguments' do
      actual = code('10 LET A = MAX(1,2)')
      compare(actual, [1.0, 2.0, "MAX"])
    end
  end
end
