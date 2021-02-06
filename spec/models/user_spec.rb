# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Codebreaker::User do
  let(:user) { Codebreaker::User.new(name) }
  let(:name) { 'Benny Hill' }

  describe 'after initialize user must be valid with valid attributes' do
    it { expect(:name).to be }
    it { expect(user.name).to eq(name) }
    it { expect(user).to be }
    it { expect(user).to be_an_instance_of(Codebreaker::User) }
  end

  describe 'test validation' do
    it 'with empty name' do
      expect { Codebreaker::User.new(nil) }.to raise_error(EmptyValueError, Codebreaker::ValidationHelper::EMPTY_VALUE)
    end

    it 'with wrong name type' do
      expect { Codebreaker::User.new(123) }.to raise_error(WrongTypeError, Codebreaker::ValidationHelper::WRONG_TYPE)
    end

    it 'with too long and too short name' do
      expect { Codebreaker::User.new('ab') }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
      expect { Codebreaker::User.new('a' * 31) }.to raise_error(UserError, Codebreaker::ValidationHelper::NAME_SIZE)
    end

    it 'with correct parameters' do
      expect { Codebreaker::User.new('Benny') }.not_to raise_error
    end
  end
end
