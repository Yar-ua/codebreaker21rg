# frozen_string_literal: true

module Codebreaker
  module ValidationHelper
    MUST_BE_STRING = 'Code must be string'
    MUST_BE_ONLY_DIGITS = 'allowed only digits'
    MUST_BE_1_6 = 'Code must contain only digits from 1 to 6'
    TOO_LONG = 'Code is too long, must have only 4 digits'
    TOO_SHORT = 'Code is too short, must have only 4 digits'
    INCORRECT_LEVEL = 'Incorrect level value, try again!'
    NAME_SIZE = 'Name size must be between 3 and 30'
    EMPTY_VALUE = 'Value is empty'
    WRONG_TYPE = 'Wrong type of argument!'

    def validate_code(code)
      validate_presence(code)
      if !code.is_a? String
        raise GameError, MUST_BE_STRING
      elsif code.match?(/\D/)
        raise GameError, MUST_BE_ONLY_DIGITS
      elsif code.match?(/[0789]+/)
        raise GameError, MUST_BE_1_6
      elsif code.length > 4
        raise GameError, TOO_LONG
      elsif code.length < 4
        raise GameError, TOO_SHORT
      end
    end

    def validate_level(level, levels)
      raise GameError, INCORRECT_LEVEL unless levels.include?(level.to_sym)
    end

    def validate_name(name)
      raise UserError, NAME_SIZE if name.length < 3 || name.length > 30
    end

    def validate_presence(*args)
      raise EmptyValueError, EMPTY_VALUE if args.any?(&:nil?)
    end

    def validate_type(type, *args)
      args.each { |item| raise WrongTypeError, WRONG_TYPE unless item.instance_of?(type) }
    end
  end
end
