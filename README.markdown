### Rake Notifier send a notification to your email address whenever a Rake task in your application fails.


#### Usage
1. Add to Gemfile
```ruby
gem 'rake_notifier'
```

2. If you had already setup exception_notification_rails3.gem, rake_notifier.gem will read your email configurations from it.

3. If your dont use exception_notification_rails3.gem, you can setup it
   customly, just
```ruby
Rake.email_from  = 'your@email.com'
Rake.email_to    = 'another@email.com'
```

#### And then you're ready to go.
