# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-08-12
[1.0.0]: https://github.com/dakurei-gems/rubycord/releases/tag/v1.0.0

### Summary

Initial release, based on release [3.5.0](https://github.com/shardlab/discordrb/releases/tag/v3.5.0) of the [Discordrb](https://github.com/shardlab/discordrb) project, with a few tweaks applied on top before the gem was renamed to be pushed on [Rubygems](https://rubygems.org), among the most notable:

- Add ability to apply a custom status to the bot (_[Doc](https://dakurei-gems.github.io/rubycord/v1.0.0/Rubycord/Bot.html#custom_status=-instance_method), [more infos](https://discord.com/developers/docs/change-log#aug-8-2023)_)
- Migrating from CircleCI to GitHub Actions
- Drop support to Ruby version prior to 3.1.3
- Add dependencies & development dependencies
- Migrating from Rubocop to Standard
- **(breaking change)** Added missings permissions flags & Update permissions names ([#2](https://github.com/dakurei-gems/rubycord/pull/2))
- **(breaking change)** Added missings intents & Update intents names ([#3](https://github.com/dakurei-gems/rubycord/pull/3))
- **(breaking change)** Added missings errors & Update errors names ([#4](https://github.com/dakurei-gems/rubycord/pull/4))
- Overwrite Discordrb::Bot#inspect to reduce superfluous data printing ([#7](https://github.com/dakurei-gems/rubycord/pull/7))
- **(breaking change)** Update Discordrb::Attachment ([#8](https://github.com/dakurei-gems/rubycord/pull/8))
- **(breaking change)** Change gem name from "discordrb" to "rubycord" ([#9](https://github.com/dakurei-gems/rubycord/pull/9))
