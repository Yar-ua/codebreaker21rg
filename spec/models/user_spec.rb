require 'spec_helper'

RSpec.describe Codebreaker::User do
  subject(:user) { described_class.new(name) }

  let(:name) { 'username' }

  describe 'after initialize must have name' do
    it 'is instance of User' do
      expect(user).to be_an_instance_of(described_class)
    end

    it 'have name' do
      expect(user.name).to eq(name)
    end
  end

  describe 'test validation' do
    it 'with empty or short name' do
      expect { described_class.new('ab') }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end

    it 'with long name' do
      expect { described_class.new('a' * 31) }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end
  end
end
