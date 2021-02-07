require 'spec_helper'

RSpec.describe Codebreaker::User do
  let(:user) { described_class.new(name) }
  let(:name) { 'Benny Hill' }

  describe 'after initialize user must be valid with valid attributes' do
    it { expect(:name).to be_truthy }
    it { expect(user.name).to eq(name) }
    it { expect(user).to be_truthy }
    it { expect(user).to be_an_instance_of(described_class) }
  end

  describe 'test validation' do
    it 'with empty name' do
      expect { described_class.new(nil) }.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
    end

    it 'with wrong name type' do
      expect { described_class.new(123) }.to raise_error(WrongTypeError, Codebreaker::ValidationHelper::WRONG_TYPE)
    end

    it 'with too short name' do
      expect { described_class.new('ab') }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end

    it 'with too long name' do
      expect { described_class.new('a' * 21) }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end

    it 'with correct parameters' do
      expect { described_class.new('Benny') }.not_to raise_error
    end
  end
end
