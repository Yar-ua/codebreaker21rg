# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Codebreaker::ValidationHelper do
  let(:user) { Codebreaker::User.new('Billy Kid') }
  let(:game) { Codebreaker::Game.new(user, 'easy') }

  describe 'code helper' do
    it 'generate' do
      code = game.generate
      expect(code.size).to eq(4)
      expect(code.match?(/[1-6]/)).to be_truthy
    end

    describe 'check secret code 6543' do
      code = '6543'
      it { expect(game.check_code(code, '5643')).to eq('++--') }
      it { expect(game.check_code(code, '6411')).to eq('+-') }
      it { expect(game.check_code(code, '6544')).to eq('+++') }
      it { expect(game.check_code(code, '3456')).to eq('----') }
      it { expect(game.check_code(code, '6666')).to eq('+') }
      it { expect(game.check_code(code, '2666')).to eq('-') }
      it { expect(game.check_code(code, '2222')).to eq('') }
    end

    describe 'check secret code 6666' do
      code = '6666'
      it { expect(game.check_code(code, '1661')).to eq('++') }
    end

    describe 'check secret code 1234' do
      code = '1234'
      it { expect(game.check_code(code, '3124')).to eq('+---') }
      it { expect(game.check_code(code, '1524')).to eq('++-') }
      it { expect(game.check_code(code, '1234')).to eq('++++') }
    end
  end
end
