# frozen_string_literal: true

class SplitLine
  SPLITABLE = ['=', ';', '(', ')', '[', ']', '=', '-', '+', '>', '<', '*', '/', ':', ',', '^'].freeze

  NOT_UNARY = %w[= ( + - / * > <].freeze

  def self.process(line)
    text = line.chomp

    x = split_strings(text)
    y = cleanup(x)
    z = label_tokens(y)
    r = clean_unary(z)
  end

  def self.split_other(text)
    l = []

    t = String.new

    (0...text.size).each do |i|
      if SPLITABLE.include?(text[i])
        l << t.dup.split(/\s+/)
        l << text[i]
        t.clear
      else
        t << text[i]
      end
    end

    l << t.dup.split(/\s+/)

    l.flatten.reject { |x| x == '' }
  end

  def self.split_strings(text)
    l = []

    t = String.new

    string_mode = false
    (0...text.size).each do |i|
      if string_mode
        t << text[i]

        if text[i] == '"'
          l << t.dup
          t.clear
          string_mode = false
        end
      elsif text[i] == '"'
        l << split_other(t.dup)
        t = text[i]
        string_mode = true
      else
        t << text[i]
      end
    end

    l << split_other(t.dup)

    l.flatten
  end

  def self.cleanup(list)
    l = []

    (0...list.size).each do |i|
      case list[i]
      when '='
        if l[-1] == '<' || l[-1] == '>'
          l[-1] << list[i]
        else
          l << list[i]
        end
      when '>'
        if l[-1] == '<'
          l[-1] << list[i]
        else
          l << list[i]
        end
      when '-'
        if Token.maths?(l[-1])
          list[i + 1] = '-' + list[i + 1]
        else
          l << list[i]
        end
      when ''
        # Lose this one
      else
        l << list[i]
      end
    end

    l
  end

  def self.label_tokens(list)
    list.map { |item| Token.new(item) }
  end

  def self.clean_unary(list)
    l = []

    list.each_with_index do |item, i|
      if item.type == Token::MATH && item.value == '-'
        if l.empty?
          list[i + 1].reset_value(list[i + 1].value * -1)
        elsif NOT_UNARY.include?(l[-1].value)
          if list[i + 1].type == Token::FLOAT_VARIABLE
            list[i + 1].negated
          else
            list[i + 1].reset_value(list[i + 1].value * -1)
          end
        elsif l[-1].type == Token::KEYWORD
          list[i + 1].reset_value(list[i + 1].value * -1)
        else
          l << item
        end
      else
        l << item
      end
    end

    l
  end
end
