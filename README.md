[![Build Status](https://travis-ci.org/tmlee/gitlab_ruby.svg?branch=master)](https://travis-ci.org/tmlee/gitlab_ruby)

# GitlabRuby

GitlabRuby is a Gitlab library for Ruby supporting the [Gitlab API](https://docs.gitlab.com/ce/api/README.html).
GitlabRuby aims to be adaptive to the Gitlab API and simple to use.

* Adaptive: Gitlab project is open sourced and new features are added frequently. GitlabRuby should be able to automatically parse all endpoints from that project.
* Simple: GitlabRuby should be simple that you will only have to refer to the Gitlab API official documentation to make any calls you intended to.

## Installation

Install from rubygems:

```
    gem install gitlab_ruby
```

Or add this line to your application's Gemfile:

```ruby
    gem 'gitlab_ruby'
```

And then execute:

    $ bundle

## Getting Started

```ruby
    API_KEY   = 'USER_TOKEN'                                            # OBTAIN API KEY FROM GITLAB.com
    client    = GitlabRuby::Client.new(token: API_KEY, version: 'v4')
    projects  = client.get.projects.execute                             # List all projects

    # Returned API objects are accessible like any Ruby object
    projects.first.name
    projects.last.description
```

## Usage

#### Configurations

```ruby
    client    = GitlabRuby::Client.new(
                    token: API_KEY,                         # user's private token or OAuth2 access token
                    version: 'v4',                          # choose API version, default: v4
                    endpoint: 'https://example.com/api/'    # Custom endpoint for self-hosted Gitlab, default: https://gitlab.com/api/
                )
```

#### Interacting with Gitlab API

GitlabRuby aims to allow interaction with the Gitlab API using method chaining syntax, while also adhering closely to the way the Gitlab API is structured. You should only need to refer to the [Gitlab API documentation](https://docs.gitlab.com/ce/api/README.html) when using GitlabRuby.

#### How it works

Assume the following API endpoint
```
    POST /projects/:id/share

    Attribute       Type            Required    Description
    id              integer/string  yes         The ID of the project or NAMESPACE/PROJECT_NAME
    group_id        integer         yes         The ID of the group to share with
    group_access    integer         yes         The permissions level to grant the group
    expires_at      string          no          Share expiration date in ISO 8601 format: 2016-09-26
```

You would call it with

```ruby
    client.post.projects.id(project_id).share.execute(
        group_id: group_id, 
        group_access: access
    )
```

Start the query with a `get`, `post`, `put`, or `delete`.

Pass any additional parameters in `execute` to make the API call.

## More Examples

#### [List Projects](https://docs.gitlab.com/ce/api/projects.html#projects)
```
    GET /projects
```
Translates to
```ruby
    client.get.projects.execute
```

#### [Get Single Project](https://docs.gitlab.com/ce/api/projects.html##get-single-project)
```
    GET /projects/:id

    # /projects/'gitlab-org%2Fgitlab-ce'
```
Translates to
```ruby
    client.get.projects.id('gitlab-org%2Fgitlab-ce').execute
```
URL parameters works like calling a method

#### [Create Project](https://docs.gitlab.com/ce/api/projects.html#create-project)
```
    POST /projects
    
    # with params
    {
      name: 'New Gitlab Project'
    }
```
Translates to
```ruby
    client.post.projects.execute(name: 'New Gitlab Project')
```
Query parameters are passed into the `execute` method

#### Pagination
```ruby
    projects.next_page?     # returns true or false
    projects.prev_page?     # returns true or false
    projects.next_page      # make API call to fetch next page
    projects.prev_page      # make API call to fetch prev page
    projects.first_page     # make API call to fetch first page
    projects.last_page      # make API call to fetch last page
```

#### Complete API

Refer to the complete [https://docs.gitlab.com/ce/api/](documentation) endpoints.

## Development

Since the [Gitlab](https://gitlab.com/gitlab-org/gitlab-ce) codebase is open source, GitlabRuby attempts to use Ruby metaprogramming to generate an intuitive API library from the list of possible endpoints which Gitlab supports.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gitlab_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## TODO

- [] Script to automatically update API routes from Gitlab CE project
- [] Support sudo
- [/] Support pagination
- [] Support more versions of Rubies (by dropping some gem dependencies)
- [] Refactor and reduce coupling within classes

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

