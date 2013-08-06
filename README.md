# Jeapie

This is a wrapper for http://jeapie.com RESTful API. 
It allows to send push notifications to your Android and Apple devices.

## Installation
Add this line to your application's Gemfile:

    $ gem 'jeapie', '~> 0.2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jeapie

## Usage
optional:
```ruby
require 'jeapie'
```

To send with the very minimum amount of information.

```ruby
# sending to myself
Jeapie.notify(message: 'message', title: 'title', token: 'APP_TOKEN')
#sending to all subscribers of your application (providers)
Jeapie.notify_all(message: 'message', title: 'title', token: 'APP_TOKEN')
#sending to some subscribers of your application
Jeapie.notify_multiple(message: 'message', title: 'title', token: 'APP_TOKEN', emails:'user1@mail.com, user2@mail.com')
```

Optional you can place in /config/application.rb
```ruby
Jeapie.configure do |config|
  config.token='APP_TOKEN' # you can take from http://dashboard.jeapie.com on section "Providers"
  config.device='Nexus7' #optional
  config.priority=0 #or 1(high) or -1(low, not sound when receive). By default is 0
end

Jeapie.notify(message: 'message')
#or
Jeapie.notify(message: 'message', title: 'title', priority:Jeapie::PRIORITY_LOW)
```
Method `notify` returns true or false. If it returns false you can check `Jeapie.errors` for error message.
Or you can use method `notify!`, it will raise exception if something goes wrong.

## Migrating from v0.1 to 0.2
Just delete ``config.token`` from ``/config/application.rb``

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
