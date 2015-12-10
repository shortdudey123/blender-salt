# Blender::Salt

[![Build Status](https://travis-ci.org/shortdudey123/blender-salt.svg?branch=master)](https://travis-ci.org/shortdudey123/blender-salt)
[![Gem Version](http://img.shields.io/gem/v/blender-salt.svg)](https://rubygems.org/gems/blender-salt)
[![Coverage Status](https://img.shields.io/coveralls/shortdudey123/blender-salt/master.svg)](https://coveralls.io/r/shortdudey123/blender-salt?branch=master)
[![Code Climate](https://codeclimate.com/github/shortdudey123/blender-salt/badges/gpa.svg)](https://codeclimate.com/github/shortdudey123/blender-salt)
[![Dependency Status](https://img.shields.io/gemnasium/shortdudey123/blender-salt.svg)](https://gemnasium.com/shortdudey123/blender-salt)

Provides [Salt](https://saltstack.com/) command execution for [Blender](https://github.com/PagerDuty/blender)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blender-salt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blender-salt

## Usage

### Config

Blender-salt uses the salt-api interface to remotely execute salt commands.  This requires that salt-api be installed and running on the salt master.

- host (salt master)
- port (port that salt-api is listening on)
- username (PAM user that can execute salt commands)
- password (password for specified user)

Example
```ruby
config(:salt, host: 'localhost', port: 12345, username: 'foo', password: 'bar')
```

### Using Salt for command execution

```ruby
require 'blender/salt'
extend Blender::SaltDSL
config(:salt, host: 'localhost', port: 12345, username: 'foo', password: 'bar')
members(['node1', 'node2', 'node3'])
salt_task 'test.ping'
```

```ruby
require 'blender/salt'
extend Blender::SaltDSL
config(:salt, host: 'localhost', port: 12345, username: 'foo', password: 'bar')

salt_task 'system.shutdown' do
  arguments 5
  members ['node1', 'node2', 'node3']
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shortdudey123/blender-salt.


## License

The gem is available as open source under the terms of the [Apache 2 License](http://opensource.org/licenses/Apache-2.0).

