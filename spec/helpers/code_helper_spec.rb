require 'spec_helper'

RSpec.describe Codebreaker::ValidationHelper do
  let(:game) { Codebreaker::Game.new }
  let(:code) { game.generate }

  before do
    game.user_set('Benny')
    game.difficulty_set('hell')
  end

  describe 'code helper' do
    describe 'generate' do
      it { expect(code.size).to eq(4) }
      it { expect(code).to be_match(/[1-6]/) }
    end

    describe 'check secret code 6543' do
      code = '6543'
      it {
        expect(game.check_code(code,
                               '5643')).to eq([Codebreaker::Game::PLUS, Codebreaker::Game::PLUS,
                                               Codebreaker::Game::MINUS, Codebreaker::Game::MINUS].join)
      }

      it { expect(game.check_code(code, '6411')).to eq([Codebreaker::Game::PLUS, Codebreaker::Game::MINUS].join) }

      it {
        expect(game.check_code(code,
                               '6544')).to eq([Codebreaker::Game::PLUS, Codebreaker::Game::PLUS,
                                               Codebreaker::Game::PLUS].join)
      }

      it {
        expect(game.check_code(code,
                               '3456')).to eq([Codebreaker::Game::MINUS, Codebreaker::Game::MINUS,
                                               Codebreaker::Game::MINUS, Codebreaker::Game::MINUS].join)
      }

      it { expect(game.check_code(code, '6666')).to eq([Codebreaker::Game::PLUS].join) }
      it { expect(game.check_code(code, '2666')).to eq([Codebreaker::Game::MINUS].join) }
      it { expect(game.check_code(code, '2222')).to eq('') }
    end

    describe 'check secret code 6666' do
      code = '6666'
      it { expect(game.check_code(code, '1661')).to eq([Codebreaker::Game::PLUS, Codebreaker::Game::PLUS].join) }
    end

    describe 'check secret code 1234' do
      code = '1234'
      it {
        expect(game.check_code(code,
                               '3124')).to eq([Codebreaker::Game::PLUS, Codebreaker::Game::MINUS,
                                               Codebreaker::Game::MINUS, Codebreaker::Game::MINUS].join)
      }

      it {
        expect(game.check_code(code,
                               '1524')).to eq([Codebreaker::Game::PLUS, Codebreaker::Game::PLUS,
                                               Codebreaker::Game::MINUS].join)
      }

      it {
        expect(game.check_code(code,
                               '1234')).to eq([Codebreaker::Game::PLUS, Codebreaker::Game::PLUS,
                                               Codebreaker::Game::PLUS, Codebreaker::Game::PLUS].join)
      }
    end
  end
end
