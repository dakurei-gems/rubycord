require "rubycord/events/message"

module Rubycord::Commands
  # Extension of MessageEvent for commands that contains the command called and makes the bot readable
  class CommandEvent < Rubycord::Events::MessageEvent
    attr_reader :bot
    attr_accessor :command
  end
end
