# Codebreaker21rg

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/codebreaker21rg`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'codebreaker21rg'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install codebreaker21rg

## Usage

1. For implementing gem in your aplication add:
```ruby
require 'bundler/setup'
require 'codebreaker'
```

For start new game do:
```ruby
game = Codebreaker::Game.new(difficulty)
```
you could choose between 3 levels of difficulty: 'easy', 'middle', 'hard'. So, you could do next:
```ruby
game = Codebreaker::Game.new(easy)
```
After that game will be initialized.

2. Game process

For taking a hint do:
```ruby
game.hint
```
game should response with hash:
```ruby
{status: :hint, message: '5'}
```
if you have no hints, you will get:
```ruby
{status: :hint, message: :no_hint}
```

For sending guess do:
```ruby
game.run('1234')
```

If you win, you will get:
```ruby
{status: :win, message: results}
```
If you lose, you will get:
```ruby
{status: :lose}
```


results - hash, what looks like:
```ruby
results = {
        difficulty: difficulty,
        attempts_total: attempts_total,
        attempts_used: attempts_used,
        hints_total: hints_total,
        hints_used: hints_used
      }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/codebreaker21rg.
