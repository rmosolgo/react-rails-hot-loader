# React::Rails::HotLoader

Reload React.js components with Ruby on Rails & [`react-rails`](http://github.com/reactjs/react-rails).

When you edit components, they'll be reloaded by the client & re-mounted in the page.

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

- Add an initializer (eg, `app/config/initializers/react_rails_hot_loader.rb`):

  ```ruby
  if Rails.env.development?
    React::Rails::HotLoader.start()
  end
  ```

- Include the Javascript (eg, in `app/assets/javascripts/application.js`):

  ```js
  //= require react_rails_hot_loader
  ```

  (When not `Rails.env.development?`, this requires an empty file, so don't worry about leaving it in production deploys.)

- Restart your development server

- Edit files in `/app/assets/javascripts` -- they'll be reloaded in the client and React components will be remounted.

## Doeses & Doesn'ts

`react-rails-hot-loader` ...

- __does__ set up a WebSocket server & client
- __does__ reload JS assets when they change (from `/app/assets/javascripts/*.js*`)
- __does__ remount components (via `ReactRailsUJS`) after reloading assets
- __does__ preserve state & props (because `React.render` does that out of the box)
- __doesn't__ reload Rails view files (`html`, `erb`, `slim`, etc)
- __doesn't__ reload CSS (although that could be fixed)

## TODO

- Handle Passenger occasionally killing background threads :(
- Replace pinging with file watching
- Test `HotLoader::Server` in some way
- Add `rails g react-rails-hot-loader:install` to add initializer and JS

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
