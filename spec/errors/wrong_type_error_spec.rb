require 'spec_helper'

RSpec.describe WrongTypeError do
  it 'raise WrongTypeError if wrong type of value' do
    expect { Codebreaker::Game.new(354) }.to raise_error(described_class)
  end
end
