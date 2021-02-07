module Codebreaker
  module ValidationHelper
    MUST_BE_STRING = 'Code must be string'.freeze
    MUST_BE_ONLY_DIGITS = 'allowed only digits'.freeze
    MUST_BE_1_6 = 'Code must contain only digits from 1 to 6'.freeze
    TOO_LONG = 'Code is too long, must have only 4 digits'.freeze
    TOO_SHORT = 'Code is too short, must have only 4 digits'.freeze
    INCORRECT_LEVEL = 'Incorrect level value, try again!'.freeze
    NAME_SIZE = 'Name size must be between 3 and 20'.freeze
    EMPTY_VALUE = 'Value is empty'.freeze
    WRONG_TYPE = 'Wrong type of argument!'.freeze

    def validate_code(code)
      validate_presence(code)
      raise GameError, MUST_BE_STRING unless code.is_a? String
      raise GameError, MUST_BE_ONLY_DIGITS if code.match?(/\D/)
      raise GameError, MUST_BE_1_6 if code.match?(/[0789]+/)
      raise GameError, TOO_LONG if code.length > 4
      raise GameError, TOO_SHORT if code.length < 4
    end

    def validate_level(level, levels)
      validate_presence(level)
      raise GameError, INCORRECT_LEVEL unless levels.include?(level.to_sym)
    end

    def validate_name(name)
      raise UserError, NAME_SIZE if name.length < 3 || name.length > 20
    end

    def validate_presence(*args)
      raise EmptyValueError, EMPTY_VALUE if args.any?(&:nil?)
    end

    def validate_type(type, *args)
      args.each { |item| raise WrongTypeError, WRONG_TYPE unless item.instance_of?(type) }
    end
  end
end
