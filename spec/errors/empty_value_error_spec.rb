require 'spec_helper'

RSpec.describe EmptyValueError do
  it 'raise EmptyValueError if empty value' do
    expect { Codebreaker::User.new(nil) }.to raise_error(described_class)
  end
end
