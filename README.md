# ActiveUseCase

[![GitHub license](https://img.shields.io/github/license/jbox-web/active_use_case.svg)](https://github.com/jbox-web/active_use_case/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/active_use_case.svg)](https://github.com/jbox-web/active_use_case/releases/latest)
[![CI](https://github.com/jbox-web/active_use_case/workflows/CI/badge.svg)](https://github.com/jbox-web/active_use_case/actions)
[![Code Climate](https://codeclimate.com/github/jbox-web/active_use_case/badges/gpa.svg)](https://codeclimate.com/github/jbox-web/active_use_case)
[![Test Coverage](https://codeclimate.com/github/jbox-web/active_use_case/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/active_use_case/coverage)

UseCase are enhanced Service objects :

* UseCase are created by passing an object into (usually an ActiveRecord model)
* UseCase are executed by calling the ```call``` method on it
* The ```call``` method actually calls the ```execute``` method
* The ```call``` method returns the UseCase object itself

You can then call ```success?``` on the UseCase object and a bunch of other methods :

* ```message_on_success``` to get success message (with I18n)
* ```message_on_errors``` to get failure message (with I18n)
* ```message_on_start``` to get job start message (with I18n)
* ```errors``` to get an array of errors

## Installation

Put this in your `Gemfile` :

```ruby
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }

gem 'active_use_case', github: 'jbox-web/active_use_case', tag: '1.4.0'
```

then run `bundle install`.

## Usage

```ruby
class Post < ApplicationRecord
  include ActiveUseCase::Model
  add_use_cases [:send_email, :send_sms]
end
```

In ```app/use_cases/posts/send_email``` :

```ruby
module Posts
  class SendEmail
    def execute(email)
      if job success
        # Do what you want
      else
        # Store the error
        error_message('Error while sending email!')
      end
    end
  end
end
```

In ```app/use_cases/posts/send_sms``` :

```ruby
module Posts
  class SendSms
    def execute(phone_number)
      if job success
        # Do what you want
      else
        # Store the error
        error_message('Error while sending sms!')
      end
    end
  end
end
```

Wherever you want :

```ruby
task = post.send_email!('foo@bar.com')
puts task.success?
puts task.message_on_success?
puts task.message_on_errors?
puts task.message_on_start?
puts task.errors (=> ['Error while sending email!'])

task = post.send_sms!('0123456789')
puts task.success?
puts task.message_on_success?
puts task.message_on_errors?
puts task.message_on_start?
puts task.errors (=> ['Error while sending sms!'])
```

You can pass any parameters you want and even blocks :

```ruby
module Posts
  class DoSomething
    def execute(arg1, arg2, opts = {}, &block)
      if job success
        # Do what you want
      else
        # Store the error
        error_message('Error while doing something!')
      end
    end
  end
end
```

```ruby
task = post.do_something!('foo@bar.com', 'baz', force: true) do
  puts 'Foo!'
end

puts task.success?
puts task.message_on_success?
puts task.message_on_errors?
puts task.message_on_start?
puts task.errors (=> ['Error while doing something!'])
```
