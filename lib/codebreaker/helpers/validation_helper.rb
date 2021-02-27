module Codebreaker
  module ValidationHelper
    include Constants

    def validate_code(code)
      validate_presence(code)
      raise GameError, MUST_BE_STRING unless code.is_a? String
      raise GameError, MUST_BE_ONLY_DIGITS if code.match?(/\D/)
      raise GameError, MUST_BE_1_6 if code.match?(/[0789]+/)
      raise GameError, TOO_LONG if code.length > 4
      raise GameError, TOO_SHORT if code.length < 4
    end

    def validate_difficulty(difficulty, difficulties)
      validate_presence(difficulty)
      raise GameError, INCORRECT_DIFFICULTY unless difficulties.include?(difficulty.to_sym)
    end

    def validate_presence(*args)
      raise EmptyValueError, EMPTY_VALUE if args.any?(&:nil?)
    end

    def validate_type(type, *args)
      args.each { |item| raise WrongTypeError, WRONG_TYPE unless item.instance_of?(type) }
    end

    def validate_name(name)
      raise UserError, NAME_SIZE if name.length < 3 || name.length > 20
    end

    def validate_user_presence(user)
      raise GameError, USER_NOT_INITIALIZED if !user.instance_of?(Codebreaker::User)
    end

    def validate_difficulty_presence(difficulty)
      raise GameError, DIFFICULTY_NOT_INITIALIZED if !user.instance_of?(Codebreaker::Difficulty)
    end
  end
end
