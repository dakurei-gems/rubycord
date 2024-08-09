[![Github Actions Rspec](https://github.com/dakurei-gems/rubycord/actions/workflows/rspec.yml/badge.svg?branch=main&event=push)](https://github.com/dakurei-gems/rubycord/actions/workflows/rspec.yml)
[![Github Actions Standard](https://github.com/dakurei-gems/rubycord/actions/workflows/standard.yml/badge.svg?branch=main&event=push)](https://github.com/dakurei-gems/rubycord/actions/workflows/standard.yml)
[![Github Actions CodeQL](https://github.com/dakurei-gems/rubycord/actions/workflows/codeql.yml/badge.svg?branch=main&event=push)](https://github.com/dakurei-gems/rubycord/actions/workflows/codeql.yml)

[![Release](https://img.shields.io/badge/gem-v3.5.1-007ec6.svg)](https://github.com/dakurei-gems/rubycord/releases/tag/v3.5.1)
[![Release](https://img.shields.io/badge/docs-v3.5.1-979797.svg)](https://dakurei-gems.github.io/rubycord/v3.5.1/)
[![Stable](https://img.shields.io/badge/gem-stable-007ec6.svg)](https://github.com/dakurei-gems/rubycord/tree/stable)
[![Stable](https://img.shields.io/badge/docs-stable-979797.svg)](https://dakurei-gems.github.io/rubycord/stable/)
[![Main (Unreleased)](https://img.shields.io/badge/gem-main-007ec6.svg)](https://github.com/dakurei-gems/rubycord/tree/main)
[![Main (Unreleased)](https://img.shields.io/badge/docs-main-979797.svg)](https://dakurei-gems.github.io/rubycord/main/)

# rubycord

An implementation of the [Discord](https://discord.com/) API using Ruby.

## Quick links to sections

- [Introduction](https://github.com/dakurei-gems/rubycord#introduction)
- [Dependencies](https://github.com/dakurei-gems/rubycord#dependencies)
- [Installation](https://github.com/dakurei-gems/rubycord#installation)
- [Usage](https://github.com/dakurei-gems/rubycord#usage)
- [Webhooks Client](https://github.com/dakurei-gems/rubycord#webhooks-client)
- [Support](https://github.com/dakurei-gems/rubycord#support)
- [Development](https://github.com/dakurei-gems/rubycord#development), [Contributing](https://github.com/dakurei-gems/rubycord#contributing)
- [License](https://github.com/dakurei-gems/rubycord#license)

See also: [Documentation](https://dakurei-gems.github.io/rubycord/v3.5.1/), [Tutorials](https://github.com/dakurei-gems/rubycord/wiki)

## Introduction

`rubycord` aims to meet the following design goals:

1. Full coverage of the public bot API.
2. Expressive, high level abstractions for rapid development of common applications.
3. Friendly to Ruby beginners and beginners of open source contribution.

If you enjoy using the library, consider getting involved with the community to help us improve and meet these goals!

**You should consider using `rubycord` if:**

- You need a bot - and fast - for small or medium sized communities, and don't want to be bogged down with "low level" details. Getting started takes minutes, and utilities like a command parser and tools for modularization make it simple to quickly add or change your bots functionality.
- You like or want to learn Ruby, or want to contribute to a Ruby project. A lot of our users are new to Ruby, and eventually make their first open source contributions with us. We have an active Discord channel with experienced members who will happily help you get involved, either as a user or contributor.
- You want to experiment with Discord's API or prototype concepts for Discord bots without too much commitment.

**You should consider other libraries if:**

- You need to scale to large volumes of servers (>2,500) with lots of members. It's still possible, but it can be difficult to scale Ruby processes, and it requires more in depth knowledge to do so well. Especially if you already have a bot that is on a large amount of servers, porting to Ruby is unlikely to improve your performance in most cases.
- You want full control over the library that you're using. While we expose some "lower level" interfaces, they are unstable, and only exist to serve the more powerful abstractions in the library.

## Dependencies

* Ruby >= 3.1.3 supported
* An installed build system for native extensions (on Windows, make sure you download the "Ruby+Devkit" version of [RubyInstaller](https://rubyinstaller.org/downloads/))

### Voice dependencies

This section only applies to you if you want to use voice functionality.

- [libsodium](https://github.com/dakurei-gems/rubycord/wiki/Installing-libsodium)
- A compiled libopus distribution for your system, anywhere the script can find it. See [here](https://github.com/dakurei-gems/rubycord/wiki/Installing-libopus) for installation instructions.
- [FFmpeg](https://www.ffmpeg.org/download.html) installed and in your PATH

## Installation

### With Bundler

Using [Bundler](https://bundler.io/#getting-started), you can add rubycord to your Gemfile:

```ruby
gem "rubycord", github: "dakurei-gems/rubycord", branch: "stable"
```

And then install via `bundle install`.

_If you want to run a specific release, use this gem line:_
```ruby
gem "rubycord", github: "dakurei-gems/rubycord", tag: "v3.5.1"
```

_If you want to run the latest code instead, use this gem line instead:_
```ruby
gem "rubycord", github: "dakurei-gems/rubycord", branch: "main"
```

⚠️ **Note that `main` may contain breaking changes or other unstable code !**

Run the [ping example](https://github.com/dakurei-gems/rubycord/blob/main/examples/ping.rb) to verify that the installation works (make sure to replace the token and client ID in there with your bots'!):

To run the bot while using bundler:

```sh
bundle exec ruby ping.rb
```

## Usage

You can make a simple bot like this:

```ruby
require 'rubycord'

bot = Rubycord::Bot.new token: '<token here>'

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run
```

This bot responds to every "Ping!" with a "Pong!".

See [additional examples here](https://github.com/dakurei-gems/rubycord/tree/main/examples).

You can find examples of projects that use rubycord by [searching for the rubycord topic on GitHub](https://github.com/topics/rubycord).

If you've made an open source project on GitHub that uses rubycord, consider adding the `rubycord` topic to your repo!

## Webhooks Client

Also included is a webhooks client, which can be used as a separate gem `rubycord-webhooks`. This special client can be used to form requests to Discord webhook URLs in a high-level manner.

- [`rubycord-webhooks` documentation](https://dakurei-gems.github.io/rubycord/v3.5.1/Rubycord/Webhooks.html)
- [More information about webhooks](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)
- [Embed visualizer tool](https://leovoel.github.io/embed-visualizer/)

### Usage

```ruby
require 'rubycord/webhooks'

WEBHOOK_URL = 'https://discord.com/api/webhooks/424070213278105610/yByxDncRvHi02mhKQheviQI2erKkfRRwFcEp0MMBfib1ds6ZHN13xhPZNS2-fJo_ApSw'.freeze

client = Rubycord::Webhooks::Client.new(url: WEBHOOK_URL)
client.execute do |builder|
  builder.content = 'Hello world!'
  builder.add_embed do |embed|
    embed.title = 'Embed title'
    embed.description = 'Embed description'
    embed.timestamp = Time.now
  end
end
```

**Note:** The `rubycord` gem relies on `rubycord-webhooks`. If you already have `rubycord` installed, `require 'rubycord/webhooks'` will include all of the `Webhooks` features as well.

## Support

If you need help or have a question, you can:

1. [Open an issue](https://github.com/dakurei-gems/rubycord/issues). Be sure to read the issue template, and provide as much detail as you can.

## Contributing

Thank you for your interest in contributing!
Bug reports and pull requests are welcome on GitHub at <https://github.com/dakurei-gems/rubycord>.

Be sure to use the search function in our documentation or on GitHub, to see if there are any duplicate issues/PRs before anything else

## Development setup

**This section is for developing rubycord itself! If you just want to make a bot, see the [Installation](https://github.com/dakurei-gems/rubycord#installation) section.**

After checking out the repo, run `bin/setup` to install dependencies. You can then run tests via `bundle exec rspec spec`. Make sure to run standard also: `bundle exec standardrb`. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
