# frozen_string_literal: true

def check_code(code, try)
  answer = []
  try.each_char.each_with_index do |value, index|
    if code[index] == value
      answer << '+'
    elsif code.include? value
      answer << '-'
    end
  end
  answer.sort.join
end
