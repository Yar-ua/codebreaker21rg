module Codebreaker
  class Difficulty
    include Constants
    include ValidationHelper
    attr_accessor :type

    def initialize(type)
      validate(type)
      @type = type
    end

    def attempts
      DIFFICULTY[@type.to_sym][:attempts]
    end

    def hints
      DIFFICULTY[@type.to_sym][:hints]
    end

    private

    def validate(type)
      validate_presence(type)
      validate_type(String, type)
      validate_difficulty(type, DIFFICULTY)
    end
  end
end
