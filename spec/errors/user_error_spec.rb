require 'spec_helper'

RSpec.describe UserError do
  it 'raise UserError if wrong type of value' do
    expect { Codebreaker::User.new('a') }.to raise_error(described_class)
  end
end
