module Codebreaker
  class Game
    include Constants
    include CodeHelper
    include ValidationHelper

    attr_reader :difficulty, :attempts, :hints, :code, :user

    def initialize
      @code = generate
      @hints_array = @code.split('')
      @guess = ''
    end

    def set_user(name)
      @user = Codebreaker::User.new(name)
    end

    def set_difficulty(type)
      @difficulty = Codebreaker::Difficulty.new(type)
      @attempts = @difficulty.attempts
      @hints = @difficulty.hints
    end

    def hint
      response(:hint, show_hint) if validate_user_and_difficulty_presence
    end

    def run(guess)
      validate_user_and_difficulty_presence
      @guess = guess
      @attempts -= 1
      validate_code(@guess)
      return response(:win, results) if win?

      check = check_code(@code, @guess)
      return response(:lose) if lose?

      response(:ok, check)
    end

    private

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
        difficulty: @difficulty.type,
        attempts_total: @difficulty.attempts,
        attempts_used: @difficulty.attempts - @attempts,
        hints_total: @difficulty.hints,
        hints_used: @difficulty.hints - @hints
      }
    end

    def response(status, message = '')
      { status: status, message: message }
    end

    def validate_user_and_difficulty_presence
      validate_user_presence(@user)
      validate_difficulty_presence(@difficulty)
    end
  end
end
