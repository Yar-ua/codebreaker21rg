module Codebreaker
  class Game
    include Constants
    include CodeHelper
    include ValidationHelper

    attr_reader :difficulty, :attempts, :hints, :code

    def initialize(difficulty)
      validate(difficulty)
      @code = generate
      @hints_array = @code.split('')
      @difficulty = difficulty
      @attempts = DIFFICULTY[@difficulty.to_sym][:attempts]
      @hints = DIFFICULTY[@difficulty.to_sym][:hints]
      @guess = ''
    end

    def hint
      response(:hint, show_hint)
    end

    def run(guess)
      @guess = guess
      @attempts -= 1
      validate_code(@guess)
      return response(:win, results) if win?

      check = check_code(@code, @guess)
      return response(:lose) if lose?

      response(:ok, check)
    end

    private

    def validate(difficulty)
      validate_presence(difficulty)
      validate_type(String, difficulty)
      validate_difficulty(difficulty, DIFFICULTY)
    end

    def show_hint
      return :no_hint if @hints.zero?

      @hints -= 1
      @hints_array.delete(@hints_array.sample)
    end

    def win?
      @guess == @code
    end

    def lose?
      @attempts.zero? || @attempts.negative?
    end

    def results
      {
        difficulty: @difficulty,
        attempts_total: DIFFICULTY[@difficulty.to_sym][:attempts],
        attempts_used: DIFFICULTY[@difficulty.to_sym][:attempts] - @attempts,
        hints_total: DIFFICULTY[@difficulty.to_sym][:hints],
        hints_used: DIFFICULTY[@difficulty.to_sym][:hints] - @hints
      }
    end

    def response(status, message = '')
      { status: status, message: message }
    end
  end
end
