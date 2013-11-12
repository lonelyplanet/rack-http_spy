rack-http_spy [![travis-ci](https://travis-ci.org/textgoeshere/rack-http_spy.png)](https://travis-ci.org/textgoeshere/rack-http_spy)
==================

Queues for quicker cukes!

[![Code Climate](https://codeclimate.com/github/textgoeshere/rack-http_spy.png)](https://codeclimate.com/github/textgoeshere/rack-http_spy)

## Requirements

* Rails > 3
* Ruby > 1.9

## Usage

Don't use this in production - but you won't learn anything interesting about your app running this in development mode either. Instead, create a production-like environment, e.g. "profile".

For Rails 3, add the following to your Gemfile.

    gem 'rack-perftools_profiler', :require => 'rack/perftools_profiler'

and add the following to config/application.rb

    config.middleware.use ::Rack::GCProfiler

For Sinatra, call `use` inside a configure block, like so:

    configure do
      use ::Rack::GCProfiler
    end

For Rack::Builder, call `use` inside the Builder constructor block

    Rack::Builder.new do
      use ::Rack::GCProfiler
    end

## Options

* `:default_printer` - can be set to 'text', 'json'. Default is text.

## Related projects

* [GC-stats-middleware](https://raw.github.com/mattetti/GC-stats-middleware)
* [rack-perftools_profiler](https://github.com/bhb/rack-perftools_profiler)

## Author

[Dave Nolan](http://kapoq.com) / [lonelyplanet.com](http://www.lonelyplanet.com)
