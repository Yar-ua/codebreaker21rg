# frozen_string_literal: true

module Codebreaker
  class Game
    include CodeHelper
    include ValidationHelper

    attr_reader :user, :level, :attempts, :hints

    LEVELS = { easy: { attempts: 15, hints: 2 },
               medium: { attempts: 10, hints: 1 },
               hard: { attempts: 5, hints: 1 } }.freeze

    def initialize(user, level = 'easy')
      validate(user, level)
      @user = user
      @code = generate
      @hints_array = @code.split('')
      @level = level
      @attempts = LEVELS[@level.to_sym][:attempts]
      @hints = LEVELS[@level.to_sym][:hints]
      @guess = ''
    end

    def run(guess)
      @guess = guess
      @attempts.positive? ? play_game : response(:lose)
    end

    def play_game
      @attempts -= 1
      case @guess
      when @code
        response(:win)
      when 'hint'
        response(:hint, show_hint)
      else
        validate_and_check_code
      end
    end

    # ##TODO return user stata if winner

    private

    def validate(user, level)
      validate_presence(user, level)
      validate_type(User, user)
      validate_type(String, level)
      validate_level(level, LEVELS)
    end

    def validate_and_check_code
      validate_code(@guess)
      response(:ok, check_code(@code, @guess))
    end

    def show_hint
      return :no_hint if @hints.zero?

      @hints -= 1
      @hints_array.delete(@hints_array.sample)
    end

    def response(status, message = '')
      { status: status, message: message }
    end
  end
end
