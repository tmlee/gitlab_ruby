require "bundler/setup"
require "gitlab_ruby"
require "vcr"
require 'byebug'

TEST_API_KEY = "mP3Wi_Dw5L5MegyGnSqx" # Working API Key of a test account

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
