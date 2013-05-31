# Jeapie

This is wrapper for RESTFull API http://jeapie.com
It allow send push notification to your Android and Apple devices

## Installation
Add this line to your application's Gemfile:

    $ gem 'jeapie'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jeapie

## Usage
```ruby
require 'jeapie'
```

To send with the very minimum amount of information.

```ruby
Jeapie.notify(message: 'message', title: 'title', user: 'USER_TOKEN', token: 'APP_TOKEN')
```

Optional you can place in /config/application.rb
```ruby
Jeapie.configure do |config|
  config.user='USER_TOKEN' # you can take from http://dashboard.jeapie.com
  config.token='APP_TOKEN'
  config.device='Nexus7' #optional
  config.priority=0 #or 1(high) or -1(low, not sound when receive). By default is 0
end

Jeapie.notify(message: 'message', title: 'title')
#or just
Jeapie.notify(message: 'message')
```
Method `notify` return true or false. If it return false you can check `Jeapie.errors` for error message.
Or you can use method `notify!`, it raise exception if something going wrong.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
