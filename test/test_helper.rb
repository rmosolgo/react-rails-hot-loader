require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'minitest/autorun'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def touch_asset(asset_name)
  FileUtils.touch(Rails.root.join("app/assets/javascripts/#{asset_name}"))
end
