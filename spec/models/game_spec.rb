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

  describe 'ruby garage special tests' do
    [
      ['6541', '6541',
       [Codebreaker::Game::PLUS, Codebreaker::Game::PLUS, Codebreaker::Game::PLUS,
        Codebreaker::Game::PLUS]],
      ['1221', '2112',
       [Codebreaker::Game::MINUS, Codebreaker::Game::MINUS, Codebreaker::Game::MINUS,
        Codebreaker::Game::MINUS]],
      ['6235', '2365',
       [Codebreaker::Game::PLUS, Codebreaker::Game::MINUS, Codebreaker::Game::MINUS,
        Codebreaker::Game::MINUS]],
      ['1234', '4321',
       [Codebreaker::Game::MINUS, Codebreaker::Game::MINUS, Codebreaker::Game::MINUS,
        Codebreaker::Game::MINUS]],
      ['1234', '1235',
       [Codebreaker::Game::PLUS, Codebreaker::Game::PLUS, Codebreaker::Game::PLUS]],
      ['1234', '5431',
       [Codebreaker::Game::PLUS, Codebreaker::Game::MINUS, Codebreaker::Game::MINUS]],
      ['1234', '1524',
       [Codebreaker::Game::PLUS, Codebreaker::Game::PLUS, Codebreaker::Game::MINUS]],
      ['1234', '4326',
       [Codebreaker::Game::MINUS, Codebreaker::Game::MINUS, Codebreaker::Game::MINUS]],
      ['1234', '3525', [Codebreaker::Game::MINUS, Codebreaker::Game::MINUS]],
      ['1234', '5612', [Codebreaker::Game::MINUS, Codebreaker::Game::MINUS]],
      ['5566', '5600', [Codebreaker::Game::PLUS, Codebreaker::Game::MINUS]],
      ['1234', '6254', [Codebreaker::Game::PLUS, Codebreaker::Game::PLUS]],
      ['1231', '1111', [Codebreaker::Game::PLUS, Codebreaker::Game::PLUS]],
      ['1115', '1231', [Codebreaker::Game::PLUS, Codebreaker::Game::MINUS]],
      ['1234', '4255', [Codebreaker::Game::PLUS, Codebreaker::Game::MINUS]],
      ['1234', '5635', [Codebreaker::Game::PLUS]],
      ['1234', '6666', []],
      ['1234', '2552', [Codebreaker::Game::MINUS]]
    ].each do |item|
      it "when result is #{item[2]} if code is - #{item[0]} guess is #{item[1]}" do
        game.instance_variable_set(:@attempts, 2)
        game.instance_variable_set(:@code, item[0])
        code = item[0]
        guess = item[1]
        expect(game.check_code(code, guess)).to eq item[2].join
      end
    end
  end
end
