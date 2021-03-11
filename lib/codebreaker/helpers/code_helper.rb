module Codebreaker
  module CodeHelper
    include Constants

    def generate
      4.times.map { rand(1..6) }.join
    end

    def check_code(code, guess)
      code = code.split('')
      guess = guess.split('')
      resp = []
      code, guess, resp = collect_pluses(code, guess, resp)
      resp = collect_minuses(code, guess, resp)
      resp.join
    end

    def collect_pluses(code, guess, resp)
      code.map.with_index do |_, i|
        next if code[i] != guess[i]

        resp << '+'
        guess[i] = nil
        code[i] = nil
      end
      guess.delete(nil)
      code.delete(nil)
      [code, guess, resp]
    end

    def collect_minuses(code, guess, resp)
      code.each do |item|
        next unless guess.include?(item)

        guess[guess.index(item)] = nil
        code[code.index(item)] = nil
        resp << '-'
      end
      resp
    end
  end
end
