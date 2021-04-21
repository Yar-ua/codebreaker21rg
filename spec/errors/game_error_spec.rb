require 'spec_helper'

RSpec.describe GameError do
  let(:game) { Codebreaker::Game.new }

  before do
    game.user_set('Benny')
    game.difficulty_set('hell')
  end

  describe 'raise GameError if something wrong' do
    it { expect { game.run('unexpected') }.to raise_error(described_class) }
  end
end
