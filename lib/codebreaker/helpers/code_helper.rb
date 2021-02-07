module Codebreaker
  module CodeHelper
    PLUS = '+'.freeze
    MINUS = '-'.freeze

    def generate
      4.times.map { rand(1..6) }.join
    end

    def check_code(code, try)
      not_guess_position = not_guess_position_collect(code, try)
      arr = not_guess_position.transpose
      response = PLUS * (4 - not_guess_position.length)
      not_guess_digit = not_guess_digit_collect(not_guess_position, arr)
      response << (MINUS * (not_guess_position.length - not_guess_digit.length))
    end

    def not_guess_position_collect(code, try)
      code.chars.zip(try.chars).delete_if { |v| v[0] == v[1] }
    end

    def not_guess_digit_collect(not_guess_position, arr)
      not_guess_digit = ''
      (0..not_guess_position.length - 1).each do |index|
        not_guess_digit = arr[0].delete_if do |val|
          arr[1][index] == val
        end
      end
      not_guess_digit
    end
  end
end
