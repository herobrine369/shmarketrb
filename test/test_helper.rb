ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# For Minitest (test/test_helper.rb)
require "simplecov"
SimpleCov.start "rails" do
  add_filter "/vendor/"
  coverage_dir "coverage/minitest"
  # minimum_coverage 80
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
