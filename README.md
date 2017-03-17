# GitlabRuby

GitlabRuby is a Ruby API wrapper for the [Gitlab API](https://docs.gitlab.com/ce/api/README.html).

Note: Not Production Ready

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlab_ruby', github: 'tmlee/gitlab_ruby'
```

And then execute:

    $ bundle

## Getting Started

```ruby
    API_KEY   = "OBTAIN API KEY FROM GITLAB.com"
    client    = GitlabRuby::Client.new(token: API_KEY)
    projects  = client.get.version("v4").projects.execute # List all projects

    # Returned API objects are accessible like any Ruby object
    projects.first.name
    projects.last.description
```

## Usage

GitlabRuby uses method chaining to construct an API call.

[List Projects](https://docs.gitlab.com/ce/api/projects.html#projects)
```
    GET /projects
```
Translates to
```ruby
    client.get.version('v4').projects.execute
```

[Get Single Project](https://docs.gitlab.com/ce/api/projects.html##get-single-project)
```
    GET /projects/:id
```
Translates to
```ruby
    client.get.version('v4').projects.id('gitlab-org%2Fgitlab-ce').execute
```
URL parameters works like calling a method

[Create Project](https://docs.gitlab.com/ce/api/projects.html#create-project)
```
    POST /projects
```
Translates to
```ruby
    client.post.version('v4').projects.execute(name: 'New Gitlab Project')
```
Query parameters are passed into the `execute` method


Refer to the complete [https://docs.gitlab.com/ce/api/](API endpoints).

## Development

Since the [Gitlab](https://gitlab.com/gitlab-org/gitlab-ce) codebase is open source, GitlabRuby attempts to use Ruby metaprogramming to generate an intuitive API library from the list of possible endpoints which Gitlab supports.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gitlab_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

