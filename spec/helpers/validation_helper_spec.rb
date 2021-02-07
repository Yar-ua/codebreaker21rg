require 'spec_helper'

RSpec.describe Codebreaker::ValidationHelper do
  let(:user) { Codebreaker::User.new('Billy Kid') }
  let(:game) { Codebreaker::Game.new(user, 'easy') }

  describe 'validate_name' do
    it 'with correct name' do
      expect { user.validate_name('Billy') }.not_to raise_error
    end

    it 'with short name' do
      expect { user.validate_name('Mo') }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end

    it 'with long name' do
      expect { user.validate_name('a' * 21) }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end
  end

  describe 'validate_presence' do
    it 'with string value' do
      expect { user.validate_presence('nil') }.not_to raise_error
    end

    it 'with nil value' do
      expect do
        user.validate_presence(nil)
      end.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
    end
  end

  describe 'validate_type' do
    it 'with correct value' do
      expect { user.validate_type(String, 'Billy') }.not_to raise_error
    end

    it 'with wrong value' do
      expect do
        user.validate_type(String, 59)
      end.to raise_error(WrongTypeError, Codebreaker::ValidationHelper::WRONG_TYPE)
    end
  end

  describe 'validate_level' do
    it 'with correct level' do
      expect { game.validate_level('easy', Codebreaker::Game::LEVELS) }.not_to raise_error
    end

    it 'with wrong level' do
      expect do
        game.validate_level('unknown',
                            Codebreaker::Game::LEVELS)
      end.to raise_error(GameError, Codebreaker::ValidationHelper::INCORRECT_LEVEL)
    end
  end

  describe 'validate_code' do
    it 'with correct value' do
      expect { game.validate_code('1234') }.not_to raise_error
    end

    it 'with integer value' do
      expect { game.validate_code(1234) }.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_STRING)
    end

    it 'with letters in code' do
      expect do
        game.validate_code('1a34')
      end.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_ONLY_DIGITS)
    end

    it 'with digits 0, 7-9' do
      expect { game.validate_code('1347') }.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_1_6)
    end

    it 'with long value' do
      expect { game.validate_code('1111111') }.to raise_error(GameError, Codebreaker::ValidationHelper::TOO_LONG)
    end

    it 'with short value' do
      expect { game.validate_code('123') }.to raise_error(GameError, Codebreaker::ValidationHelper::TOO_SHORT)
    end
  end
end
