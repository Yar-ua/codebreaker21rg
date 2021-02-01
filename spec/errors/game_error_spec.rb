# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GameError do
  let(:user) { Codebreaker::User.new('newuser') }

  describe 'raise GameError if something wrong' do
    it { expect { Codebreaker::Game.new(user, 'eassy') }.to raise_error(GameError) }
  end
end
