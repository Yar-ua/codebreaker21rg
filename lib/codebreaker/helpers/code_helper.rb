# frozen_string_literal: true

module Codebreaker
  module CodeHelper
    def generate
      4.times.map { rand(1..6) }.join
    end

    def check_code(code, try)
      code = code.chars
      try = try.chars
      mark = code.zip(try).delete_if { |v| v[0] == v[1] }
      arr = mark.transpose
      plus = '+' * (4 - mark.length)
      res = ''
      (0..mark.length - 1).each { |index| res = arr[0].delete_if { |val| arr[1][index] == val } }
      minus = '-' * (mark.length - res.length)
      plus << minus
    end
  end
end
