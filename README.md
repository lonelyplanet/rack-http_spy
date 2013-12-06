rack-http_spy [![travis-ci](https://travis-ci.org/textgoeshere/rack-http_spy.png)](https://travis-ci.org/textgoeshere/rack-http_spy)
==================

Trace and report all HTTP requests made by your app.
Built on WebMock so works with many HTTP adapters

[![Code Climate](https://codeclimate.com/github/textgoeshere/rack-http_spy.png)](https://codeclimate.com/github/textgoeshere/rack-http_spy)

## Requirements

* Rails > 3
* Ruby > 1.9

## Usage

Add this to your Gemfile:

    gem 'rack-http_spy', :require => 'rack/http_spy'

Don't use `Rack::HTTPSpy` in production. You'll get cleaner results
and your app will be safer if you create a dedicated profile
environment.

For Rails, add this to `config/environments/profile.rb`:

    config.middleware.use ::Rack::HTTPSpy

For Sinatra, call `use` inside a configure block, like so:

    configure do
      use ::Rack::HTTPSpy
    end

For Rack::Builder, call `use` inside the Builder constructor block:

    Rack::Builder.new do
      use ::Rack::HTTPSpy
    end

## TODO

### Features

* Add json and html printers
* Add different log levels

### Tech debt

* DRY-up request body matching in reports_spec

## Related projects

* [GC-stats-middleware](https://raw.github.com/mattetti/GC-stats-middleware)
* [rack-perftools_profiler](https://github.com/bhb/rack-perftools_profiler)

## Author

[Dave Nolan](http://kapoq.com) / [lonelyplanet.com](http://www.lonelyplanet.com)
