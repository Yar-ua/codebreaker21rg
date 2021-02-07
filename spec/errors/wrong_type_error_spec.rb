# frozen_string_literal: true

require 'spec_helper'

RSpec.describe WrongTypeError do
  it 'raise WrongTypeError if wrong type of value' do
    expect { Codebreaker::User.new(354) }.to raise_error(described_class)
  end
end
