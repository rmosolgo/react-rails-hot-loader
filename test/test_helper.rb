require 'simplecov'
SimpleCov.start
require 'minitest/autorun'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def touch_asset(asset_name)
  folder = asset_name["js"] ? "javascripts" : "stylesheets"
  FileUtils.touch(Rails.root.join("app/assets/#{folder}/#{asset_name}"))
end
