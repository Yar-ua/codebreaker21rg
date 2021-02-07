require 'spec_helper'

RSpec.describe Codebreaker::Game do
  let(:user) { Codebreaker::User.new(name) }
  let(:name) { 'Benny Hil' }
  let(:game) { described_class.new(user, level) }
  let(:level) { 'easy' }

  describe 'after initialize game must be valid with valid attributes' do
    it { expect(user).to be_truthy }
    it { expect(level).to be_truthy }
    it { expect(user).to be_an_instance_of(Codebreaker::User) }
    it { expect(game).to be_an_instance_of(described_class) }
  end

  describe 'game validation' do
    it 'with empty user class' do
      expect do
        described_class.new(nil, 'easy')
      end.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
    end

    it 'with incorrect user class' do
      expect do
        described_class.new('user', 'easy')
      end.to raise_error(WrongTypeError, Codebreaker::ValidationHelper::WRONG_TYPE)
    end

    it 'with wrong level' do
      expect do
        described_class.new(user, 'middle')
      end.to raise_error(GameError, Codebreaker::ValidationHelper::INCORRECT_LEVEL)
    end
  end

  describe 'game have correct values depends on game level' do
    describe 'when easy level' do
      it 'have easy level' do
        expect(game.level).to eq('easy')
      end

      it 'have easy attempts' do
        expect(game.attempts).to eq(Codebreaker::Game::LEVELS[:easy][:attempts])
      end

      it 'have easy hints' do
        expect(game.hints).to eq(Codebreaker::Game::LEVELS[:easy][:hints])
      end
    end

    describe 'when medium level' do
      let(:level) { 'medium' }

      it 'have medium level' do
        expect(game.level).to eq('medium')
      end

      it 'have medium attempts' do
        expect(game.attempts).to eq(Codebreaker::Game::LEVELS[:medium][:attempts])
      end

      it 'have medium hints' do
        expect(game.hints).to eq(Codebreaker::Game::LEVELS[:medium][:hints])
      end
    end

    describe 'when hard level' do
      let(:level) { 'hard' }

      it 'have hard level' do
        expect(game.level).to eq('hard')
      end

      it 'have hard attenpts' do
        expect(game.attempts).to eq(Codebreaker::Game::LEVELS[:hard][:attempts])
      end

      it 'have hard hints' do
        expect(game.hints).to eq(Codebreaker::Game::LEVELS[:hard][:hints])
      end
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
      expect(game.hint).to include(status: :hint, message: /[1-6]/)
    end

    it 'not available if attempts are finished' do
      game.hints.times { game.hint }
      expect(game.hint).to include(status: :hint, message: :no_hint)
    end
  end

  describe 'game win' do
    it 'if code was guessed' do
      expect(game.run(game.code)).to include(status: :win)
    end
  end

  describe 'universal game response' do
    it { expect(game.send(:response, :test, :testmsg)).to eq({ status: :test, message: :testmsg }) }
  end
end
