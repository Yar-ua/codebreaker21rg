module Constants
  DIFFICULTY = { easy: { attempts: 15, hints: 2 },
                 medium: { attempts: 10, hints: 1 },
                 hell: { attempts: 5, hints: 1 } }.freeze
  PLUS = '+'.freeze
  MINUS = '-'.freeze
  MUST_BE_STRING = 'Code must be string'.freeze
  MUST_BE_ONLY_DIGITS = 'allowed only digits'.freeze
  MUST_BE_1_6 = 'Code must contain only digits from 1 to 6'.freeze
  TOO_LONG = 'Code is too long, must have only 4 digits'.freeze
  TOO_SHORT = 'Code is too short, must have only 4 digits'.freeze
  INCORRECT_DIFFICULTY = 'Incorrect difficulty value, try again!'.freeze
  EMPTY_VALUE = 'Value is empty'.freeze
  WRONG_TYPE = 'Wrong type of argument!'.freeze
  NAME_SIZE = 'Name size must be between 3 and 30'.freeze

  WIN = :win
  LOSE = :lose
  OK = :ok
  HINT = :hint
  NO_HINT = :no_hint
end
