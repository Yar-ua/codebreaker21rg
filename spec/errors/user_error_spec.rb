# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UserError do
  describe 'raise UserError if something wrong' do
    it { expect { Codebreaker::User.new('as') }.to raise_error(UserError) }
  end
end
