# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EmptyValueError do
  it 'raise EmptyValueError if empty value' do
    expect { Codebreaker::User.new(nil) }.to raise_error(EmptyValueError)
  end
end
