# Verboten Keys

Verboten Keys is a last line of defense to help prevent you and your team from accidentally leaking private information via your APIs. It's Rack middleware that seamlessly integrates into any Rails or Sinatra application (or really anything that's based on Rack) and strips out any data that matches your list of forbidden keys.

It's a quick, easy, set-it-and-forget-it way to have the peace-of-mind that nothing's getting out of your API that shouldn't be.

## What it does

Imagine you've got an API endpoint that returns a user's profile, and you've accidentally serialized the user incorrectly and it's now returning your entire user object serialized as JSON:

```
GET /api/v1/users/123
{
  'id': 123,
  'name': 'Jane Doe',
  'email': 'jane.doe@example.com',
  'deepest_secret': 'Framed their sibling for a murder they commited'
}
```

Oh no, this is a disaster!

If only there was a way to automatically filter out accidents like this! This is where Verboten Keys helps out. If you had Verboten Keys in your application, and had `deepest_secret` set as a forbidden key, the exact same response would look like this:

```
GET /api/v1/users/123
{
  'id': 123,
  'name': 'Jane Doe',
  'email': 'jane.doe@example.com'
}
```

Verboten Keys filtered out the leaking `deepest_secret` while leaving the rest of the request intact. When all else fails, we prevent you accidentally leaking sensitive data. Verboten Keys is your last line of defense.

## Installation

To install Verboten Keys in your app, simply add this line to your application's `Gemfile` and run `bundle install`:

```ruby
gem 'verboten_keys'
```

### Rails

If you're using Rails, you don't need to do anything else to install Verboten Keys. The gem will automatically plug itself into Rails when your application boots.

### Sinatra

If your application is using Sinatra, simply add the Verboten Keys middleware into your app the same way you would any other piece of middleware:

```ruby
require 'sinatra'
require 'verboten_keys'

use Rack::Lint
use VerbotenKeys::Middleware

get '/hello' do
  { greeting: 'Hello, world!' }
end
```

You should include it last, so nothing gets missed when the middleware parses and evaluates your application's response.

## Configuration

Every application has its own security needs, and Verboten Keys is designed to be configurable, so you can get it just so. To configure Verboten Keys, simply call its `configure` method, which yields a block with the current configuration:

```ruby
# In config/initializers/verbotten_keys.rb:

VerbotenKeys.configure do |config|
  config.forbidden_keys = [:deepest_secret, :secret_token]
  config.strategy = :remove
end
```

The `forbidden_keys` option lets you set the keys that will be filtered out of the response. It takes an array of symbols, and will raise an error if it's not in the right format. You should include all of the columns and attributes you absolutely do not want to ever leak from your API. The default value is `[]`, which means you need to set this up otherwise Verboten Keys won't do anything.

The `strategy` option lets you pick how Verboten Keys should handle a forbidden key it finds. The default value is `:remove`. Acceptable options are `:remove`, `:nullify`, and `:raise`:

* `:remove` removes the key-value pair from the JSON response body, so it looks like the JSON object never had the key-value pair in the first place.
* `:nullify` leaves the key in the JSON response, but it will nullify the value, so any forbidden values will always appear to be `nil`.
* `:raise` will raise a `VerbotenKeys::ForbiddenKeyError` if a forbidden key is found in the response body.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/tpritc/verboten-keys). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tpritc/verboten-keys/blob/main/CODE_OF_CONDUCT.md) while interacting in the project's codebases, issue trackers, chat rooms, and mailing lists.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). If you or your organization need a custom, commercial license for any reason, [send me an email](mailto:tom@tpritc.com) and I'll be happy to set something up for you.
