# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Codebreaker::Game do
  let(:user) { Codebreaker::User.new(name) }
  let(:name) { 'Benny Hil' }
  let(:game) { Codebreaker::Game.new(user, level) }
  let(:level) { 'easy' }

  describe 'after initialize game must be valid with valid attributes' do
    it { expect(user).to be }
    it { expect(level).to be }
    it { expect(user).to be_an_instance_of(Codebreaker::User) }
    it { expect(game).to be_an_instance_of(Codebreaker::Game) }
  end

  describe 'game validation' do
    it 'with empty or incorrect user class' do
      expect { Codebreaker::Game.new(nil) }.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
      expect { Codebreaker::Game.new('user') }.to raise_error(WrongTypeError, Codebreaker::ValidationHelper::WRONG_TYPE)
    end

    it 'with wrong level' do
      expect do
        Codebreaker::Game.new(user, 'middle')
      end.to raise_error(GameError, Codebreaker::ValidationHelper::INCORRECT_LEVEL)
    end
  end

  describe 'game level' do
    it 'easy by default' do
      expect(Codebreaker::Game.new(user).level).to eq('easy')
    end
  end

  describe 'game have correct values depends on game level' do
    it 'when easy level' do
      game = Codebreaker::Game.new(user, 'easy')
      expect(game.level).to eq('easy')
      expect(game.attempts).to eq(Codebreaker::Game::LEVELS[:easy][:attempts])
      expect(game.hints).to eq(Codebreaker::Game::LEVELS[:easy][:hints])
    end

    it 'when medium level' do
      game = Codebreaker::Game.new(user, 'medium')
      expect(game.level).to eq('medium')
      expect(game.attempts).to eq(Codebreaker::Game::LEVELS[:medium][:attempts])
      expect(game.hints).to eq(Codebreaker::Game::LEVELS[:medium][:hints])
    end

    it 'when easy hard' do
      game = Codebreaker::Game.new(user, 'hard')
      expect(game.level).to eq('hard')
      expect(game.attempts).to eq(Codebreaker::Game::LEVELS[:hard][:attempts])
      expect(game.hints).to eq(Codebreaker::Game::LEVELS[:hard][:hints])
    end
  end

  describe 'validate and check code' do
    it 'raise error if empty value' do
      expect { game.run(nil) }.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
    end

    it 'raise error if value not string' do
      expect { game.run(1234) }.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_STRING)
    end

    it 'raise error if value have letters' do
      expect { game.run('1zj4') }.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_ONLY_DIGITS)
    end

    it 'raise error if value have digits 7..9 or 0' do
      expect { game.run('1780') }.to raise_error(GameError, Codebreaker::ValidationHelper::MUST_BE_1_6)
    end
    it 'raise error if value shorter than 4 digits' do
      expect { game.run('123') }.to raise_error(GameError, Codebreaker::ValidationHelper::TOO_SHORT)
    end

    it 'raise error if value longer than 4 digits' do
      expect { game.run('12345') }.to raise_error(GameError, Codebreaker::ValidationHelper::TOO_LONG)
    end

    it 'get response with + and - if game process are ok' do
      expect(game.run('1234')).to include(status: :ok)
    end
  end

  describe 'loose game' do
    it 'wrong if attempts are not finished' do
      expect(game.run('6666')[:status]).not_to eq(:lose)
    end

    it 'if attempts are finished' do
      game.attempts.times { game.run('6666') }
      expect(game.run('6666')[:status]).to eq(:lose)
    end
  end

  describe 'game hint' do
    it 'available if hints not finished' do
      expect(game.run('hint')).to include(status: :hint, message: /[1-6]/)
    end

    it 'not available if attempts are finished' do
      game.hints.times { game.run('hint') }
      expect(game.run('hint')).to include(status: :hint, message: :no_hint)
    end
  end

  describe 'game win' do
    it 'if code was guessed' do
      expect(game.run(game.instance_eval { @code })).to include(status: :win)
    end
  end

  describe 'universal game response' do
    it { expect(game.send(:response, :test, :testmsg)).to eq({ status: :test, message: :testmsg }) }
  end
end
