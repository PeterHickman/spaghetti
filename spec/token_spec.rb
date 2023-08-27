require 'token'

def check_token(given, type, value)
  t = Token.new(given)
  expect(t.type).to eq(type)
  expect(t.value).to eq(value)
end

RSpec.describe Token do
  context Token::FLOAT do
    context 'simple' do
      it '1.' do
        check_token('1.', Token::FLOAT, 1.0)
      end

      it '.1' do
        check_token('.1', Token::FLOAT, 0.1)
      end

      it '-1.' do
        check_token('-1.', Token::FLOAT, -1.0)
      end

      it '-.1' do
        check_token('-.1', Token::FLOAT, -0.1)
      end

      it '0.1' do
        check_token('0.1', Token::FLOAT, 0.1)
      end

      it '-0.1' do
        check_token('-0.1', Token::FLOAT, -0.1)
      end
    end

    context 'scientific - simple' do
      it '1E-3' do
        check_token('1E-3', Token::FLOAT, 0.001)
      end

      it '1E-03' do
        check_token('1E-3', Token::FLOAT, 0.001)
      end

      it '-1E-3' do
        check_token('-1E-3', Token::FLOAT, -0.001)
      end

      it '-1E-03' do
        check_token('-1E-3', Token::FLOAT, -0.001)
      end

      it '1E+3' do
        check_token('1E+3', Token::FLOAT, 1000)
      end

      it '-1E+3' do
        check_token('-1E+3', Token::FLOAT, -1000)
      end
    end

    context 'scientific - fractional' do
      it '1.1E-3' do
        check_token('1.1E-3', Token::FLOAT, 0.0011)
      end

      it '1.1E-03' do
        check_token('1.1E-3', Token::FLOAT, 0.0011)
      end

      it '-1.1E-3' do
        check_token('-1.1E-3', Token::FLOAT, -0.0011)
      end

      it '-1.1E-03' do
        check_token('-1.1E-3', Token::FLOAT, -0.0011)
      end

      it '1.1E+3' do
        check_token('1.1E+3', Token::FLOAT, 1100)
      end

      it '-1.1E+3' do
        check_token('-1.1E+3', Token::FLOAT, -1100)
      end
    end
  end

  context Token::STRING do
    it 'only one type' do
      check_token('"a string"', Token::STRING, '"a string"')
    end
  end

  context Token::FLOAT_VARIABLE do
    it 'single uppercase letter' do
      check_token('A', Token::FLOAT_VARIABLE, 'A')
    end

    it 'single lowercase letter' do
      check_token('a', Token::FLOAT_VARIABLE, 'A')
    end

    it 'multiple uppercase letters' do
      check_token('CATZ', Token::FLOAT_VARIABLE, 'CATZ')
    end

    it 'multiple lowercase letters' do
      check_token('catz', Token::FLOAT_VARIABLE, 'CATZ')
    end

    it 'multiple mixedcase letters' do
      check_token('CaTz', Token::FLOAT_VARIABLE, 'CATZ')
    end

    it 'single uppercase letter with digit' do
      check_token('A1', Token::FLOAT_VARIABLE, 'A1')
    end

    it 'single lowercase letter with digit' do
      check_token('a1', Token::FLOAT_VARIABLE, 'A1')
    end

    it 'multiple uppercase letters with digit' do
      check_token('CATZ1', Token::FLOAT_VARIABLE, 'CATZ1')
    end

    it 'multiple lowercase letters with digit' do
      check_token('catz1', Token::FLOAT_VARIABLE, 'CATZ1')
    end

    it 'multiple mixedcase letters with digit' do
      check_token('CaTz1', Token::FLOAT_VARIABLE, 'CATZ1')
    end

    it 'single uppercase letter with digits' do
      check_token('A123', Token::FLOAT_VARIABLE, 'A123')
    end

    it 'single lowercase letter with digits' do
      check_token('a123', Token::FLOAT_VARIABLE, 'A123')
    end

    it 'multiple uppercase letters with digits' do
      check_token('CATZ123', Token::FLOAT_VARIABLE, 'CATZ123')
    end

    it 'multiple lowercase letters with digits' do
      check_token('catz123', Token::FLOAT_VARIABLE, 'CATZ123')
    end

    it 'multiple mixedcase letters with digits' do
      check_token('CaTz123', Token::FLOAT_VARIABLE, 'CATZ123')
    end

    it 'rejects function names' do
      check_token('RND', Token::FUNCTION, 'RND')
    end

    it 'rejects keywords' do
      check_token('GOTO', Token::KEYWORD, 'GOTO')
    end
  end

  context Token::STRING_VARIABLE do
    it 'single uppercase letter' do
      check_token('A$', Token::STRING_VARIABLE, 'A$')
    end

    it 'single lowercase letter' do
      check_token('a$', Token::STRING_VARIABLE, 'A$')
    end

    it 'multiple uppercase letters' do
      check_token('CATZ$', Token::STRING_VARIABLE, 'CATZ$')
    end

    it 'multiple lowercase letters' do
      check_token('catz$', Token::STRING_VARIABLE, 'CATZ$')
    end

    it 'multiple mixedcase letters' do
      check_token('CaTz$', Token::STRING_VARIABLE, 'CATZ$')
    end

    it 'single uppercase letter with digit' do
      check_token('A1$', Token::STRING_VARIABLE, 'A1$')
    end

    it 'single lowercase letter with digit' do
      check_token('a1$', Token::STRING_VARIABLE, 'A1$')
    end

    it 'multiple uppercase letters with digit' do
      check_token('CATZ1$', Token::STRING_VARIABLE, 'CATZ1$')
    end

    it 'multiple lowercase letters with digit' do
      check_token('catz1$', Token::STRING_VARIABLE, 'CATZ1$')
    end

    it 'multiple mixedcase letters with digit' do
      check_token('CaTz1$', Token::STRING_VARIABLE, 'CATZ1$')
    end

    it 'single uppercase letter with digits' do
      check_token('A123$', Token::STRING_VARIABLE, 'A123$')
    end

    it 'single lowercase letter with digits' do
      check_token('a123$', Token::STRING_VARIABLE, 'A123$')
    end

    it 'multiple uppercase letters with digits' do
      check_token('CATZ123$', Token::STRING_VARIABLE, 'CATZ123$')
    end

    it 'multiple lowercase letters with digits' do
      check_token('catz123$', Token::STRING_VARIABLE, 'CATZ123$')
    end

    it 'multiple mixedcase letters with digits' do
      check_token('CaTz123$', Token::STRING_VARIABLE, 'CATZ123$')
    end
  end

  context Token::KEYWORD do
    it 'lowercase' do
      check_token('gosub', Token::KEYWORD, 'GOSUB')
    end

    it 'uppercase' do
      check_token('GOSUB', Token::KEYWORD, 'GOSUB')
    end

    it 'mixedcase' do
      check_token('gOsUb', Token::KEYWORD, 'GOSUB')
    end
  end

  context Token::FUNCTION do
    context Token::FLOAT do
      it 'lowercase' do
        check_token('int', Token::FUNCTION, 'INT')
      end

      it 'uppercase' do
        check_token('INT', Token::FUNCTION, 'INT')
      end

      it 'mixedcase' do
        check_token('iNT', Token::FUNCTION, 'INT')
      end
    end
  end

  context Token::BOOLEAN do
    it 'lowercase' do
      check_token('and', Token::BOOLEAN, 'AND')
    end

    it 'uppercase' do
      check_token('AND', Token::BOOLEAN, 'AND')
    end

    it 'mixedcase' do
      check_token('And', Token::BOOLEAN, 'AND')
    end
  end

  context 'rubbish' do
    it 'unknown' do
      check_token('12$sdf', Token::UNKNOWN, '12$sdf')
    end
  end
end
