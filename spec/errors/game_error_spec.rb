require 'spec_helper'

RSpec.describe GameError do
  describe 'raise GameError if something wrong' do
    it { expect { Codebreaker::Game.new('unexpected') }.to raise_error(described_class) }
  end
end
