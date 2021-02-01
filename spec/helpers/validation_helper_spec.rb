# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Codebreaker::ValidationHelper do
  let(:user) { Codebreaker::User.new('Billy Kid') }
  let(:game) { Codebreaker::Game.new(user, 'easy') }

  describe 'validation helper' do
    it 'validate_name' do
      expect { user.validate_name('Billy') }.not_to raise_error
      expect { user.validate_name('Mo') }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
      expect { user.validate_name('a' * 31) }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end

    it 'validate_presence' do
      expect { user.validate_presence('nil') }.not_to raise_error
      expect { user.validate_presence(nil) }.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
    end

    it 'validate_type' do
      expect { user.validate_type(String, 'Billy') }.not_to raise_error
      expect do
        user.validate_type(String, 59)
      end.to raise_error(WrongTypeError, Codebreaker::ValidationHelper::WRONG_TYPE)
    end

    it 'validate_level' do
      expect { game.validate_level('easy', Codebreaker::Game::LEVELS) }.not_to raise_error
      expect do
        game.validate_level('unknown',
                            Codebreaker::Game::LEVELS)
      end.to raise_error(GameError, Codebreaker::ValidationHelper::INCORRECT_LEVEL)
    end

    it 'validate_code' do
      expect { game.validate_code('1234') }.not_to raise_error
      expect { game.validate_code(1234) }.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_STRING)
      expect do
        game.validate_code('1a34')
      end.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_ONLY_DIGITS)
      expect { game.validate_code('1347') }.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_1_6)
      expect { game.validate_code('1111111') }.to raise_error(GameError, Codebreaker::ValidationHelper::TOO_LONG)
      expect { game.validate_code('123') }.to raise_error(GameError, Codebreaker::ValidationHelper::TOO_SHORT)
    end
  end
end
