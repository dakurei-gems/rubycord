module Rubycord
  # Mixin for the attributes messages should have
  module MessageAttributes
    # Types of message's flags mapped to their API value.
    #   List of flags available here: https://discord.com/developers/docs/resources/message#message-object-message-flags
    FLAGS = {
      crossposted: 1 << 0,             # this message has been published to subscribed channels (via Channel Following)
      is_crosspost: 1 << 1,            # this message originated from a message in another channel (via Channel Following)
      suppress_embeds: 1 << 2,         # do not include any embeds when serializing this message
      source_message_deleted: 1 << 3,  # the source message for this crosspost has been deleted (via Channel Following)
      urgent: 1 << 4,                  # this message came from the urgent message system
      has_thread: 1 << 5,              # this message has an associated thread, with the same id as the message
      ephemeral: 1 << 6,               # this message is only visible to the user who invoked the Interaction
      loading: 1 << 7,                 # this message is an Interaction Response and the bot is "thinking"
      failed_mention_roles: 1 << 8,    # this message failed to mention some roles and add their members to the thread
      suppress_notifications: 1 << 12, # this message will not trigger push and desktop notifications
      is_voice_message: 1 << 13        # this message is a voice message
    }.freeze

    # @return [Integer] message flags combined as a bitfield.
    attr_reader :flags

    # @!method crossposted?
    #   @return [true, false] whether this message has flag CROSSPOSTED.
    # @!method is_crosspost?
    #   @return [true, false] whether this message has flag IS_CROSSPOST.
    # @!method suppress_embeds?
    #   @return [true, false] whether this message has flag SUPPRESS_EMBEDS.
    # @!method source_message_deleted?
    #   @return [true, false] whether this message has flag SOURCE_MESSAGE_DELETED.
    # @!method urgent?
    #   @return [true, false] whether this message has flag URGENT.
    # @!method has_thread?
    #   @return [true, false] whether this message has flag HAS_THREAD.
    # @!method ephemeral?
    #   @return [true, false] whether this message has flag EPHEMERAL.
    # @!method loading?
    #   @return [true, false] whether this message has flag LOADING.
    # @!method failed_mention_roles?
    #   @return [true, false] whether this message has flag FAILED_TO_MENTION_SOME_ROLES_IN_THREAD.
    # @!method suppress_notifications?
    #   @return [true, false] whether this message has flag SUPPRESS_NOTIFICATIONS.
    # @!method is_voice_message?
    #   @return [true, false] whether this message has flag IS_VOICE_MESSAGE.
    FLAGS.each do |name, value|
      define_method(:"#{name}?") do
        (@flags & value).positive?
      end
    end

    # Types of message's types mapped to their API value.
    #   List of types available here: https://discord.com/developers/docs/resources/message#message-object-message-types
    TYPES = {
      default: 0,                                        # Deletable
      recipient_add: 1,                                  # Not Deletable
      recipient_remove: 2,                               # Not Deletable
      call: 3,                                           # Not Deletable
      channel_name_change: 4,                            # Not Deletable
      channel_icon_change: 5,                            # Not Deletable
      channel_pinned_message: 6,                         # Deletable
      user_join: 7,                                      # Deletable
      server_boost: 8,                                   # Deletable
      server_boost_tier_1: 9,                            # Deletable
      server_boost_tier_2: 10,                           # Deletable
      server_boost_tier_3: 11,                           # Deletable
      channel_follow_add: 12,                            # Deletable
      server_discovery_disqualified: 14,                 # Deletable
      server_discovery_requalified: 15,                  # Deletable
      server_discovery_grace_period_initial_warning: 16, # Deletable
      server_discovery_grace_period_final_warning: 17,   # Deletable
      thread_created: 18,                                # Deletable
      reply: 19,                                         # Deletable
      chat_input_command: 20,                            # Deletable
      thread_starter_message: 21,                        # Not Deletable
      server_invite_reminder: 22,                        # Deletable
      context_menu_command: 23,                          # Deletable
      auto_moderation_action: 24,                        # Deletable (Only with MANAGE_MESSAGES permission)
      role_subscription_purchase: 25,                    # Deletable
      interaction_premium_upsell: 26,                    # Deletable
      stage_start: 27,                                   # Deletable
      stage_end: 28,                                     # Deletable
      stage_speaker: 29,                                 # Deletable
      stage_topic: 31,                                   # Deletable
      server_application_premium_subscription: 32,       # Deletable
      server_incident_alert_mode_enabled: 36,            # Deletable
      server_incident_alert_mode_disabled: 37,           # Deletable
      server_incident_report_raid: 38,                   # Deletable
      server_incident_report_false_alarm: 39,            # Deletable
      purchase_notification: 44                          # Deletable
    }

    # @return [Integer] type of message
    attr_reader :type

    # @!method is_default?
    #   @return [true, false] whether this message is a DEFAULT type.
    # @!method is_recipient_add?
    #   @return [true, false] whether this message is a RECIPIENT_ADD type.
    # @!method is_recipient_remove?
    #   @return [true, false] whether this message is a RECIPIENT_REMOVE type.
    # @!method is_call?
    #   @return [true, false] whether this message is a CALL type.
    # @!method is_channel_name_change?
    #   @return [true, false] whether this message is a CHANNEL_NAME_CHANGE type.
    # @!method is_channel_icon_change?
    #   @return [true, false] whether this message is a CHANNEL_ICON_CHANGE type.
    # @!method is_channel_pinned_message?
    #   @return [true, false] whether this message is a CHANNEL_PINNED_MESSAGE type.
    # @!method is_user_join?
    #   @return [true, false] whether this message is a USER_JOIN type.
    # @!method is_server_boost?
    #   @return [true, false] whether this message is a GUILD_BOOST type.
    # @!method is_server_boost_tier_1?
    #   @return [true, false] whether this message is a GUILD_BOOST_TIER_1 type.
    # @!method is_server_boost_tier_2?
    #   @return [true, false] whether this message is a GUILD_BOOST_TIER_2 type.
    # @!method is_server_boost_tier_3?
    #   @return [true, false] whether this message is a GUILD_BOOST_TIER_3 type.
    # @!method is_channel_follow_add?
    #   @return [true, false] whether this message is a CHANNEL_FOLLOW_ADD type.
    # @!method is_server_discovery_disqualified?
    #   @return [true, false] whether this message is a GUILD_DISCOVERY_DISQUALIFIED type.
    # @!method is_server_discovery_requalified?
    #   @return [true, false] whether this message is a GUILD_DISCOVERY_REQUALIFIED type.
    # @!method is_server_discovery_grace_period_initial_warning?
    #   @return [true, false] whether this message is a GUILD_DISCOVERY_GRACE_PERIOD_INITIAL_WARNING type.
    # @!method is_server_discovery_grace_period_final_warning?
    #   @return [true, false] whether this message is a GUILD_DISCOVERY_GRACE_PERIOD_FINAL_WARNING type.
    # @!method is_thread_created?
    #   @return [true, false] whether this message is a THREAD_CREATED type.
    # @!method is_reply?
    #   @return [true, false] whether this message is a REPLY type.
    # @!method is_chat_input_command?
    #   @return [true, false] whether this message is a CHAT_INPUT_COMMAND type.
    # @!method is_thread_starter_message?
    #   @return [true, false] whether this message is a THREAD_STARTER_MESSAGE type.
    # @!method is_server_invite_reminder?
    #   @return [true, false] whether this message is a GUILD_INVITE_REMINDER type.
    # @!method is_context_menu_command?
    #   @return [true, false] whether this message is a CONTEXT_MENU_COMMAND type.
    # @!method is_auto_moderation_action?
    #   @return [true, false] whether this message is a AUTO_MODERATION_ACTION type.
    # @!method is_role_subscription_purchase?
    #   @return [true, false] whether this message is a ROLE_SUBSCRIPTION_PURCHASE type.
    # @!method is_interaction_premium_upsell?
    #   @return [true, false] whether this message is a INTERACTION_PREMIUM_UPSELL type.
    # @!method is_stage_start?
    #   @return [true, false] whether this message is a STAGE_START type.
    # @!method is_stage_end?
    #   @return [true, false] whether this message is a STAGE_END type.
    # @!method is_stage_speaker?
    #   @return [true, false] whether this message is a STAGE_SPEAKER type.
    # @!method is_stage_topic?
    #   @return [true, false] whether this message is a STAGE_TOPIC type.
    # @!method is_server_application_premium_subscription?
    #   @return [true, false] whether this message is a GUILD_APPLICATION_PREMIUM_SUBSCRIPTION type.
    # @!method is_server_incident_alert_mode_enabled?
    #   @return [true, false] whether this message is a GUILD_INCIDENT_ALERT_MODE_ENABLED type.
    # @!method is_server_incident_alert_mode_disabled?
    #   @return [true, false] whether this message is a GUILD_INCIDENT_ALERT_MODE_DISABLED type.
    # @!method is_server_incident_report_raid?
    #   @return [true, false] whether this message is a GUILD_INCIDENT_REPORT_RAID type.
    # @!method is_server_incident_report_false_alarm?
    #   @return [true, false] whether this message is a GUILD_INCIDENT_REPORT_FALSE_ALARM type.
    # @!method is_purchase_notification?
    #   @return [true, false] whether this message is a PURCHASE_NOTIFICATION type.
    TYPES.each do |name, value|
      define_method(:"is_#{name}?") do
        @type == value
      end
    end
  end

  # A message on Discord that was sent to a text channel
  class Message
    include IDObject
    include MessageAttributes

    # @return [String] the content of this message.
    attr_reader :content
    alias_method :text, :content
    alias_method :to_s, :content

    # @return [Member, User] the user that sent this message. (Will be a {Member} most of the time, it should only be a
    #   {User} for old messages when the author has left the server since then)
    attr_reader :author
    alias_method :user, :author
    alias_method :writer, :author

    # @return [Channel] the channel in which this message was sent.
    attr_reader :channel

    # @return [Time] the timestamp at which this message was sent.
    attr_reader :timestamp

    # @return [Time] the timestamp at which this message was edited. `nil` if the message was never edited.
    attr_reader :edited_timestamp
    alias_method :edit_timestamp, :edited_timestamp

    # @return [Array<User>] the users that were mentioned in this message.
    attr_reader :mentions

    # @return [Array<Role>] the roles that were mentioned in this message.
    attr_reader :role_mentions

    # @return [Array<Attachment>] the files attached to this message.
    attr_reader :attachments

    # @return [Array<Embed>] the embed objects contained in this message.
    attr_reader :embeds

    # @return [Array<Reaction>] the reaction objects contained in this message.
    attr_reader :reactions

    # @return [true, false] whether the message used Text-To-Speech (TTS) or not.
    attr_reader :tts
    alias_method :tts?, :tts

    # @return [String] used for validating a message was sent.
    attr_reader :nonce

    # @return [true, false] whether the message was edited or not.
    attr_reader :edited
    alias_method :edited?, :edited

    # @return [true, false] whether the message mentioned everyone or not.
    attr_reader :mention_everyone
    alias_method :mention_everyone?, :mention_everyone
    alias_method :mentions_everyone?, :mention_everyone

    # @return [true, false] whether the message is pinned or not.
    attr_reader :pinned
    alias_method :pinned?, :pinned

    # @return [Server, nil] the server in which this message was sent.
    attr_reader :server

    # @return [Integer, nil] the webhook ID that sent this message, or `nil` if it wasn't sent through a webhook.
    attr_reader :webhook_id

    # @return [Array<Component>]
    attr_reader :components

    # @!visibility private
    def initialize(data, bot)
      @bot = bot
      @content = data["content"]
      @channel = bot.channel(data["channel_id"].to_i)
      @pinned = data["pinned"]
      @type = data["type"]
      @tts = data["tts"]
      @nonce = data["nonce"]
      @mention_everyone = data["mention_everyone"]

      @referenced_message = Message.new(data["referenced_message"], bot) if data["referenced_message"]
      @message_reference = data["message_reference"]

      @server = @channel.server

      @webhook_id = data["webhook_id"]&.to_i

      @author = if data["author"]
        if @webhook_id
          # This is a webhook user! It would be pointless to try to resolve a member here, so we just create
          # a User and return that instead.
          Rubycord::LOGGER.debug("Webhook user: #{data["author"]["id"]}")
          User.new(data["author"].merge({"_webhook" => true}), @bot)
        elsif @channel.private?
          # Turn the message user into a recipient - we can't use the channel recipient
          # directly because the bot may also send messages to the channel
          Recipient.new(bot.user(data["author"]["id"].to_i), @channel, bot)
        else
          member = @channel.server.member(data["author"]["id"].to_i)

          if member
            member.update_data(data["member"]) if data["member"]
            member.update_global_name(data["author"]["global_name"]) if data["author"]["global_name"]
          else
            Rubycord::LOGGER.debug("Member with ID #{data["author"]["id"]} not cached (possibly left the server).")
            member = if data["member"]
              member_data = data["author"].merge(data["member"])
              Member.new(member_data, @server, bot)
            else
              @bot.ensure_user(data["author"])
            end
          end

          member
        end
      end

      @timestamp = Time.parse(data["timestamp"]) if data["timestamp"]
      @edited_timestamp = data["edited_timestamp"].nil? ? nil : Time.parse(data["edited_timestamp"])
      @edited = !@edited_timestamp.nil?
      @id = data["id"].to_i

      @emoji = []

      @reactions = []

      data["reactions"]&.each do |element|
        @reactions << Reaction.new(element)
      end

      @mentions = []

      data["mentions"]&.each do |element|
        @mentions << bot.ensure_user(element)
      end

      @role_mentions = []

      # Role mentions can only happen on public servers so make sure we only parse them there
      if @channel.text?
        data["mention_roles"]&.each do |element|
          @role_mentions << @channel.server.role(element.to_i)
        end
      end

      @attachments = []
      @attachments = data["attachments"].map { |e| Attachment.new(e, self, @bot) } if data["attachments"]

      @embeds = []
      @embeds = data["embeds"].map { |e| Embed.new(e, self) } if data["embeds"]

      @components = []
      @components = data["components"].map { |component_data| Components.from_data(component_data, @bot) } if data["components"]

      @flags = data["flags"].to_i
    end

    # Replies to this message with the specified content.
    # @deprecated Please use {#respond}.
    # @param content [String] The content to send. Should not be longer than 2000 characters or it will result in an error.
    # @return (see #respond)
    # @see Channel#send_message
    def reply(content)
      @channel.send_message(content)
    end

    # Responds to this message as an inline reply.
    # @param content [String] The content to send. Should not be longer than 2000 characters or it will result in an error.
    # @param tts [true, false] Whether or not this message should be sent using Discord text-to-speech.
    # @param embed [Hash, Rubycord::Webhooks::Embed, nil] The rich embed to append to this message.
    # @param attachments [Array<File>] Files that can be referenced in embeds via `attachment://file.png`
    # @param allowed_mentions [Hash, Rubycord::AllowedMentions, false, nil] Mentions that are allowed to ping on this message. `false` disables all pings
    # @param mention_user [true, false] Whether the user that is being replied to should be pinged by the reply.
    # @param components [View, Array<Hash>] Interaction components to associate with this message.
    # @return (see #respond)
    def reply!(content, tts: false, embed: nil, attachments: nil, allowed_mentions: {}, mention_user: false, components: nil)
      allowed_mentions = {parse: []} if allowed_mentions == false
      allowed_mentions = allowed_mentions.to_hash.transform_keys(&:to_sym)
      allowed_mentions[:replied_user] = mention_user

      respond(content, tts, embed, attachments, allowed_mentions, self, components)
    end

    # (see Channel#send_message)
    def respond(content, tts = false, embed = nil, attachments = nil, allowed_mentions = nil, message_reference = nil, components = nil)
      @channel.send_message(content, tts, embed, attachments, allowed_mentions, message_reference, components)
    end

    # Edits this message to have the specified content instead.
    # You can only edit your own messages.
    # @param new_content [String] the new content the message should have.
    # @param new_embeds [Hash, Rubycord::Webhooks::Embed, Array<Hash>, Array<Rubycord::Webhooks::Embed>, nil] The new embeds the message should have. If `nil` the message will be changed to have no embeds.
    # @param new_components [View, Array<Hash>] The new components the message should have. If `nil` the message will be changed to have no components.
    # @return [Message] the resulting message.
    def edit(new_content, new_embeds = nil, new_components = nil)
      new_embeds = (new_embeds.instance_of?(Array) ? new_embeds.map(&:to_hash) : [new_embeds&.to_hash]).compact
      new_components = new_components.to_a

      response = API::Channel.edit_message(@bot.token, @channel.id, @id, new_content, [], new_embeds, new_components)
      Message.new(JSON.parse(response), @bot)
    end

    # Deletes this message.
    def delete(reason = nil)
      API::Channel.delete_message(@bot.token, @channel.id, @id, reason)
      nil
    end

    # Pins this message
    def pin(reason = nil)
      API::Channel.pin_message(@bot.token, @channel.id, @id, reason)
      @pinned = true
      nil
    end

    # Unpins this message
    def unpin(reason = nil)
      API::Channel.unpin_message(@bot.token, @channel.id, @id, reason)
      @pinned = false
      nil
    end

    # Add an {Await} for a message with the same user and channel.
    # @see Bot#add_await
    # @deprecated Will be changed to blocking behavior in v4.0. Use {#await!} instead.
    def await(key, attributes = {}, &)
      @bot.add_await(key, Rubycord::Events::MessageEvent, {from: @author.id, in: @channel.id}.merge(attributes), &)
    end

    # Add a blocking {Await} for a message with the same user and channel.
    # @see Bot#add_await!
    def await!(attributes = {}, &)
      @bot.add_await!(Rubycord::Events::MessageEvent, {from: @author.id, in: @channel.id}.merge(attributes), &)
    end

    # Add an {Await} for a reaction to be added on this message.
    # @see Bot#add_await
    # @deprecated Will be changed to blocking behavior in v4.0. Use {#await_reaction!} instead.
    def await_reaction(key, attributes = {}, &)
      @bot.add_await(key, Rubycord::Events::ReactionAddEvent, {message: @id}.merge(attributes), &)
    end

    # Add a blocking {Await} for a reaction to be added on this message.
    # @see Bot#add_await!
    def await_reaction!(attributes = {}, &)
      @bot.add_await!(Rubycord::Events::ReactionAddEvent, {message: @id}.merge(attributes), &)
    end

    # @return [true, false] whether this message was sent by the current {Bot}.
    def from_bot?
      @author&.current_bot?
    end

    # @return [true, false] whether this message has been sent over a webhook.
    def webhook?
      !@webhook_id.nil?
    end

    # @return [Array<Emoji>] the emotes that were used/mentioned in this message.
    def emoji
      return if @content.nil?
      return @emoji unless @emoji.empty?

      @emoji = @bot.parse_mentions(@content).select { |el| el.is_a? Rubycord::Emoji }
    end

    # Check if any emoji were used in this message.
    # @return [true, false] whether or not any emoji were used
    def emoji?
      emoji&.empty?
    end

    # Check if any reactions were used in this message.
    # @return [true, false] whether or not this message has reactions
    def reactions?
      !@reactions.empty?
    end

    # Returns the reactions made by the current bot or user.
    # @return [Array<Reaction>] the reactions
    def my_reactions
      @reactions.select(&:me)
    end

    # Reacts to a message.
    # @param reaction [String, #to_reaction] the unicode emoji or {Emoji}
    def create_reaction(reaction)
      reaction = reaction.to_reaction if reaction.respond_to?(:to_reaction)
      API::Channel.create_reaction(@bot.token, @channel.id, @id, reaction)
      nil
    end

    alias_method :react, :create_reaction

    # Returns the list of users who reacted with a certain reaction.
    # @param reaction [String, #to_reaction] the unicode emoji or {Emoji}
    # @param limit [Integer] the limit of how many users to retrieve. `nil` will return all users
    # @example Get all the users that reacted with a thumbs up.
    #   thumbs_up_reactions = message.reacted_with("\u{1F44D}")
    # @return [Array<User>] the users who used this reaction
    def reacted_with(reaction, limit: 100)
      reaction = reaction.to_reaction if reaction.respond_to?(:to_reaction)
      reaction = reaction.to_s if reaction.respond_to?(:to_s)

      get_reactions = proc do |fetch_limit, after_id = nil|
        resp = API::Channel.get_reactions(@bot.token, @channel.id, @id, reaction, nil, after_id, fetch_limit)
        return JSON.parse(resp).map { |d| User.new(d, @bot) }
      end

      # Can be done without pagination
      return get_reactions.call(limit) if limit && limit <= 100

      paginator = Paginator.new(limit, :down) do |last_page|
        if last_page && last_page.count < 100
          []
        else
          get_reactions.call(100, last_page&.last&.id)
        end
      end

      paginator.to_a
    end

    # Returns a hash of all reactions to a message as keys and the users that reacted to it as values.
    # @param limit [Integer] the limit of how many users to retrieve per distinct reaction emoji. `nil` will return all users
    # @example Get all the users that reacted to a message for a giveaway.
    #   giveaway_participants = message.all_reaction_users
    # @return [Hash<String => Array<User>>] A hash mapping the string representation of a
    #   reaction to an array of users.
    def all_reaction_users(limit: 100)
      all_reactions = @reactions.map { |r| {r.to_s => reacted_with(r, limit: limit)} }
      all_reactions.reduce({}, :merge)
    end

    # Deletes a reaction made by a user on this message.
    # @param user [User, String, Integer] the user or user ID who used this reaction
    # @param reaction [String, #to_reaction] the reaction to remove
    def delete_reaction(user, reaction)
      reaction = reaction.to_reaction if reaction.respond_to?(:to_reaction)
      API::Channel.delete_user_reaction(@bot.token, @channel.id, @id, reaction, user.resolve_id)
    end

    # Deletes this client's reaction on this message.
    # @param reaction [String, #to_reaction] the reaction to remove
    def delete_own_reaction(reaction)
      reaction = reaction.to_reaction if reaction.respond_to?(:to_reaction)
      API::Channel.delete_own_reaction(@bot.token, @channel.id, @id, reaction)
    end

    # Removes all reactions from this message.
    def delete_all_reactions
      API::Channel.delete_all_reactions(@bot.token, @channel.id, @id)
    end

    # The inspect method is overwritten to give more useful output
    def inspect
      "<Message content=\"#{@content}\" id=#{@id} timestamp=#{@timestamp} author=#{@author} channel=#{@channel}>"
    end

    # @return [String] a URL that a user can use to navigate to this message in the client
    def link
      "https://discord.com/channels/#{@server&.id || "@me"}/#{@channel.id}/#{@id}"
    end

    alias_method :jump_link, :link

    # @return [Message, nil] the Message this Message was sent in reply to.
    def referenced_message
      return @referenced_message if @referenced_message
      return nil unless @message_reference

      referenced_channel = @bot.channel(@message_reference["channel_id"])
      @referenced_message = referenced_channel.message(@message_reference["message_id"])
    end

    # @return [Array<Components::Button>]
    def buttons
      results = @components.collect do |component|
        case component
        when Components::Button
          component
        when Components::ActionRow
          component.buttons
        end
      end

      results.flatten.compact
    end

    # to_message -> self or message
    # @return [Rubycord::Message]
    def to_message
      self
    end

    alias_method :message, :to_message
  end
end
