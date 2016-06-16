require 'simplecov'
SimpleCov.start('rails') if ENV["COVERAGE"]
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'factory_girl_rails'
require 'mocha/api'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

Capybara.javascript_driver = :poltergeist

