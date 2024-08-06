require "faraday"
require "faraday/multipart"
require "json"
require "base64"

require "rubycord/webhooks/builder"

module Rubycord::Webhooks
  # A client for a particular webhook added to a Discord channel.
  class Client
    # Create a new webhook
    # @param url [String] The URL to post messages to.
    # @param id [Integer] The webhook's ID. Will only be used if `url` is not
    #   set.
    # @param token [String] The webhook's authorisation token. Will only be used
    #   if `url` is not set.
    def initialize(url: nil, id: nil, token: nil)
      @url = url || generate_url(id, token)
    end

    # @return [Faraday::Connection] the Faraday connection to make HTTP requests with configured Faraday
    def client
      @client ||= Faraday.new do |faraday|
        faraday.request :multipart
      end
    end

    # Executes the webhook this client points to with the given data.
    # @param builder [Builder, nil] The builder to start out with, or nil if one should be created anew.
    # @param wait [true, false] Whether Discord should wait for the message to be successfully received by clients, or
    #   whether it should return immediately after sending the message.
    # @param components [View, Array<Hash>, nil] The view or hash to create components on message, if defined replace
    #   the yield param view.
    # @yield [builder] Gives the builder to the block to add additional steps, or to do the entire building process.
    # @yieldparam builder [Builder] The builder given as a parameter which is used as the initial step to start from.
    # @yield [view] Gives the view to the block to do the entire view process.
    # @yieldparam view [View] The view given as a parameter which is used as the initial step to start from.
    # @example Execute the webhook with an already existing builder
    #   builder = Rubycord::Webhooks::Builder.new # ...
    #   client.execute(builder)
    # @example Execute the webhook by building a new message
    #   client.execute do |builder, view|
    #     builder.content = 'Testing'
    #     builder.username = 'rubycord'
    #     builder.add_embed do |embed|
    #       embed.timestamp = Time.now
    #       embed.title = 'Testing'
    #       embed.image = Rubycord::Webhooks::EmbedImage.new(url: 'https://i.imgur.com/PcMltU7.jpg')
    #     end
    #     view.row do |row|
    #       row.button(style: :success, label: "Hello", custom_id: "hello")
    #     end
    #   end
    # @return [Faraday::Response] the response returned by Discord.
    def execute(builder = nil, wait = false, components = nil)
      raise TypeError, "builder needs to be nil or like a Rubycord::Webhooks::Builder!" if
        !(builder.respond_to?(:file) && builder.respond_to?(:to_payload)) && !builder.respond_to?(:to_json_hash) && !builder.nil?

      builder ||= Builder.new
      view = View.new

      yield(builder, view) if block_given?

      builder.components = components || view

      headers = {}
      headers[:content_type] = "application/json" unless builder.file

      client.send(
        :post,
        "#{@url}#{wait ? "?wait=true" : ""}",
        builder.to_payload,
        **headers
      )
    end

    # Modify this webhook's properties.
    # @param name [String, nil] The default name.
    # @param avatar [String, #read, nil] The new avatar, in base64-encoded JPG format.
    # @param channel_id [String, Integer, nil] The channel to move the webhook to.
    # @return [Faraday::Response] the response returned by Discord.
    def modify(name: nil, avatar: nil, channel_id: nil)
      client.send(
        :patch,
        @url,
        {name: name, avatar: avatarise(avatar), channel_id: channel_id}.compact.to_json,
        content_type: "application/json"
      )
    end

    # Delete this webhook.
    # @param reason [String, nil] The reason this webhook was deleted.
    # @return [Faraday::Response] the response returned by Discord.
    # @note This is permanent and cannot be undone.
    def delete(reason: nil)
      client.send(
        :delete,
        @url,
        nil,
        x_audit_log_reason: reason
      )
    end

    # Edit a message from this webhook.
    # @param message_id [String, Integer] The ID of the message to edit.
    # @param builder [Builder, nil] The builder to start out with, or nil if one should be created anew.
    # @param content [String, nil] The message content.
    # @param attachments [Array, nil]
    # @param embeds [Array<Embed, Hash>, nil]
    # @param allowed_mentions [Hash, nil]
    # @return [Faraday::Response] the response returned by Discord.
    # @example Edit message content
    #   client.edit_message(message_id, content: 'goodbye world!')
    # @example Edit a message via builder
    #   client.edit_message(message_id) do |builder|
    #     builder.add_embed do |e|
    #       e.description = 'Hello World!'
    #     end
    #   end
    # @note Not all builder options are available when editing.
    def edit_message(message_id, builder: nil, content: nil, attachments: nil, embeds: nil, allowed_mentions: nil)
      builder ||= Builder.new

      yield builder if block_given?

      builder.content = content if content
      builder.attachments = attachments if attachments
      builder.embeds = embeds if embeds
      builder.allowed_mentions = allowed_mentions if allowed_mentions

      headers = {}
      headers[:content_type] = "application/json" unless builder.file

      client.send(
        :patch,
        "#{@url}/messages/#{message_id}",
        builder.to_payload,
        **headers
      )
    end

    # Delete a message created by this webhook.
    # @param message_id [String, Integer] The ID of the message to delete.
    # @return [Faraday::Response] the response returned by Discord.
    def delete_message(message_id)
      client.send(
        :delete,
        "#{@url}/messages/#{message_id}"
      )
    end

    private

    # Convert an avatar to API ready data.
    # @param avatar [String, #read] Avatar data.
    def avatarise(avatar)
      if avatar.respond_to? :read
        "data:image/jpg;base64,#{Base64.strict_encode64(avatar.read)}"
      else
        avatar
      end
    end

    def generate_url(id, token)
      "https://discord.com/api/v9/webhooks/#{id}/#{token}"
    end
  end
end
