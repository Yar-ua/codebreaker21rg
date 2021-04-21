require 'simplecov'
SimpleCov.start do
  minimum_coverage 95
  add_filter '/spec/'
end

require 'codebreaker'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
