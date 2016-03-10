# React::Rails::HotLoader

Reload React.js components with Ruby on Rails & [`react-rails`](http://github.com/reactjs/react-rails).

When you edit components, they'll be reloaded by the browser & re-mounted in the page.

[![Gem Version](https://badge.fury.io/rb/react-rails-hot-loader.svg)](http://badge.fury.io/rb/react-rails-hot-loader) [![Build Status](https://travis-ci.org/rmosolgo/react-rails-hot-loader.svg)](https://travis-ci.org/rmosolgo/react-rails-hot-loader) [![Code Climate](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader/badges/gpa.svg)](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader) [![Test Coverage](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader/badges/coverage.svg)](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader/coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'react-rails-hot-loader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install react-rails-hot-loader

## Usage

- Add an initializer:

  ```ruby
  # config/initializers/react_rails_hot_loader.rb
  if Rails.env.development?
    # Starts a websocket server to push changes:
    React::Rails::HotLoader.start()
  end
  ```

- Include the JavaScript:

  ```js
  // app/assets/javascripts/application.js
  //= require react-rails-hot-loader
  ```

  (When not `Rails.env.development?`, this requires an empty file, so don't worry about leaving it in production deploys.)

- Restart your development server

- Edit files in `/app/assets/javascripts` & save changes -- they'll be reloaded in the client and React components will be remounted.

## Configuration

If you notice that your assets are not being recompiled and hot loaded, it could be because they aren't being matched by the default asset glob used (`**/*.{js,coffee}*`).  You can modify this asset glob like so:

```ruby
# config/initializers/react_rails_hot_loader.rb
React::Rails::HotLoader::AssetChangeSet.asset_glob = "**/*.{js,rb}*" # I <3 Opal
```

## Doeses & Doesn'ts

`react-rails-hot-loader` ...

- __does__ set up a WebSocket server & client
- __does__ reload JS assets when they change (from `/app/assets/javascripts/*.{js,coffee}*`)
- __does__ remount components (via `ReactRailsUJS`) after reloading assets
- __doesn't__ reload Rails view files (`html`, `erb`, `slim`, etc)
- __doesn't__ reload CSS (although that could be fixed)

## TODO

- Remove need for initializer by automatically starting in `config.after_initialize`?
- Figure out how the "real" React hot-loader preserves state and do that
- Log out when a push fails, or log the JS code if the push succeeds but doesn't get eval'ed
- Declare bankruptcy when you change git branches (lots of changes at once)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
