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

module ActionDispatch
  class IntegrationTest
    def sign_in_as(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:github, {
        uid: user.uid,
        info: {
          email: user.email,
          name: user.name
        }
      })

      get "/auth/github/callback"
      follow_redirect!
    end
  end
end
