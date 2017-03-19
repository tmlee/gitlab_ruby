require 'gitlab_ruby/version'
require 'gitlab_ruby/query_chain'
require 'gitlab_ruby/client'
require 'gitlab_ruby/api_object'
require 'gitlab_ruby/errors'
require 'gitlab_ruby/api_errors'
require 'gitlab_ruby/helpers/query_chain'
require 'faraday'
require 'json'
require 'csv'
require 'mustermann'

module GitlabRuby
end

GitlabRuby::QueryChain.generate_methods
