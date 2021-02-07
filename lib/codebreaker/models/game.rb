module Codebreaker
  class Game
    include CodeHelper
    include ValidationHelper

    attr_reader :user, :level, :attempts, :hints, :code

    LEVELS = { easy: { attempts: 15, hints: 2 },
               medium: { attempts: 10, hints: 1 },
               hard: { attempts: 5, hints: 1 } }.freeze

    def initialize(user, level)
      validate(user, level)
      @user = user
      @code = generate
      @hints_array = @code.split('')
      @level = level
      @attempts = LEVELS[@level.to_sym][:attempts]
      @hints = LEVELS[@level.to_sym][:hints]
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

    def validate(user, level)
      validate_presence(user, level)
      validate_type(User, user)
      validate_type(String, level)
      validate_level(level, LEVELS)
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
        name: @user.name,
        level: @level,
        attempts_total: LEVELS[@level.to_sym][:attempts],
        attempts_used: LEVELS[@level.to_sym][:attempts] - @attempts,
        hints_total: LEVELS[@level.to_sym][:hints],
        hints_used: LEVELS[@level.to_sym][:hints] - @hints
      }
    end

    def response(status, message = '')
      { status: status, message: message }
    end
  end
end
