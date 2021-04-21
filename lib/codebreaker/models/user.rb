module Codebreaker
  class User
    include ValidationHelper
    attr_accessor :name

    def initialize(name)
      validate(name)
      @name = name
    end

    private

    def validate(name)
      validate_presence(name)
      validate_type(String, name)
      validate_name(name)
    end
  end
end
