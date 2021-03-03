require 'spec_helper'
require 'pry'

RSpec.describe Codebreaker::Game do
  let(:game) { described_class.new }
  let(:name) { 'Benny' }
  let(:difficulty) { 'easy' }

  before do
    game.user_set(name)
    game.difficulty_set(difficulty)
  end

  describe 'after initialize game must be' do
    it { expect(game).to be_an_instance_of(described_class) }
  end

  describe 'game validation' do
    it 'with empty difficulty value' do
      expect do
        game.user_set(nil)
      end.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
    end

    it 'with wrong difficulty' do
      expect do
        game.difficulty_set('unknown')
      end.to raise_error(GameError, Codebreaker::ValidationHelper::INCORRECT_DIFFICULTY)
    end
  end

  describe 'game have correct values depends on game difficulty' do
    describe 'when easy difficulty' do
      it 'have easy difficulty' do
        expect(game.difficulty.type).to eq('easy')
      end

      it 'have easy attempts' do
        expect(game.attempts).to eq(Codebreaker::Game::DIFFICULTY[:easy][:attempts])
      end

      it 'have easy hints' do
        expect(game.hints).to eq(Codebreaker::Game::DIFFICULTY[:easy][:hints])
      end
    end

    describe 'when medium difficulty' do
      let(:difficulty) { 'medium' }

      it 'have medium difficulty' do
        expect(game.difficulty.type).to eq('medium')
      end

      it 'have medium attempts' do
        expect(game.attempts).to eq(Codebreaker::Game::DIFFICULTY[:medium][:attempts])
      end

      it 'have medium hints' do
        expect(game.hints).to eq(Codebreaker::Game::DIFFICULTY[:medium][:hints])
      end
    end

    describe 'when hard difficulty' do
      let(:difficulty) { 'hell' }

      it 'have hard difficulty' do
        expect(game.difficulty.type).to eq('hell')
      end

      it 'have hard attenpts' do
        expect(game.attempts).to eq(Codebreaker::Game::DIFFICULTY[:hell][:attempts])
      end

      it 'have hard hints' do
        expect(game.hints).to eq(Codebreaker::Game::DIFFICULTY[:hell][:hints])
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
      expect(game.run('1234')).to include(status: Codebreaker::Game::OK)
    end
  end

  describe 'loose game' do
    it 'wrong if attempts are not finished' do
      expect(game.run('6666')[:status]).not_to eq(Codebreaker::Game::LOSE)
    end

    it 'if attempts are finished' do
      game.attempts.times { game.run('6666') }
      expect(game.run('6666')[:status]).to eq(Codebreaker::Game::LOSE)
    end
  end

  describe 'game hint' do
    it 'available if hints not finished' do
      expect(game.hint).to include(status: Codebreaker::Game::HINT, message: /[1-6]/)
    end

    it 'not available if attempts are finished' do
      game.hints.times { game.hint }
      expect(game.hint).to include(status: Codebreaker::Game::HINT, message: Codebreaker::Game::NO_HINT)
    end
  end

  describe 'game win' do
    it 'if code was guessed' do
      expect(game.run(game.code)).to include(status: Codebreaker::Game::WIN)
    end
  end

  describe 'universal game response' do
    it { expect(game.send(:response, :test, :testmsg)).to eq({ status: :test, message: :testmsg }) }
  end
end
