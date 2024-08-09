require "rubycord/data"

module Rubycord::Light
  # Represents the bot account used for the light bot, but without any methods to change anything.
  class LightProfile
    include Rubycord::IDObject
    include Rubycord::UserAttributes

    # @!visibility private
    def initialize(data, bot)
      @bot = bot

      @username = data["username"]
      @id = data["id"].resolve_id
      @discriminator = data["discriminator"]
      @avatar_id = data["avatar"]

      @bot_account = false
      @bot_account = true if data["bot"]

      @verified = data["verified"]

      @email = data["email"]
    end
  end

  # A server that only has an icon, a name, and an ID associated with it, like for example an integration's server.
  class UltraLightServer
    include Rubycord::IDObject
    include Rubycord::ServerAttributes

    # @!visibility private
    def initialize(data, bot)
      @bot = bot

      @id = data["id"].resolve_id

      @name = data["name"]
      @icon_id = data["icon"]
    end
  end

  # Represents a light server which only has a fraction of the properties of any other server.
  class LightServer < UltraLightServer
    # @return [true, false] whether or not the LightBot this server belongs to is the owner of the server.
    attr_reader :bot_is_owner
    alias_method :bot_is_owner?, :bot_is_owner

    # @return [Rubycord::Permissions] the permissions the LightBot has on this server
    attr_reader :bot_permissions

    # @!visibility private
    def initialize(data, bot)
      super

      @bot_is_owner = data["owner"]
      @bot_permissions = Rubycord::Permissions.new(data["permissions"])
    end
  end
end
