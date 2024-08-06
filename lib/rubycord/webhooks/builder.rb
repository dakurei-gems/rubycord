require "rubycord/webhooks/embeds"

module Rubycord::Webhooks
  # A class that acts as a builder for a webhook message object.
  class Builder
    def initialize(content: "", username: nil, avatar_url: nil, tts: false, file: nil, attachments: nil, embeds: [], allowed_mentions: nil, components: nil)
      @content = content
      @username = username
      @avatar_url = avatar_url
      @tts = tts
      @file = file
      @attachments = attachments
      @embeds = [embeds].flatten.compact
      @allowed_mentions = allowed_mentions
      @components = components
    end

    # The content of the message. May be 2000 characters long at most.
    # @return [String] the content of the message.
    attr_accessor :content

    # The username the webhook will display as. If this is not set, the default username set in the webhook's settings
    # will be used instead.
    # @return [String, nil] the username.
    attr_accessor :username

    # The URL of an image file to be used as an avatar. If this is not set, the default avatar from the webhook's
    # settings will be used instead.
    # @return [String, nil] the avatar URL.
    attr_accessor :avatar_url

    # Whether this message should use TTS or not. By default, it doesn't.
    # @return [true, false] the TTS status.
    attr_accessor :tts

    # The files to be attached to this message.
    # @return [File, Array<File>, nil] files attached to this message.
    attr_accessor :file

    # Virtual attribute to permit deletion of uploaded files on edit_message.
    # @param value [Array, nil] `nil` to preserve attachments, empty array `[]` to delete attachments.
    # @note Virtual attribute
    attr_writer :attachments

    # Sets embeds to this message.
    # @param embeds [Embed, Array<Embed>] embeds to add.
    def embeds=(embeds)
      [@embeds].flatten.compact
    end

    # Adds an embed to this message.
    # @param embed [Embed] The embed to add.
    def <<(embed)
      @embeds << embed
    end

    # Convenience method to add an embed using a block-style builder pattern
    # @example Add an embed to a message
    #   builder.add_embed do |embed|
    #     embed.title = 'Testing'
    #     embed.image = Rubycord::Webhooks::EmbedImage.new(url: 'https://i.imgur.com/PcMltU7.jpg')
    #   end
    # @param embed [Embed, nil] The embed to start the building process with, or nil if one should be created anew.
    # @return [Embed] The created embed.
    def add_embed(embed = nil)
      embed ||= Embed.new
      yield(embed)
      self << embed
      embed
    end

    # @return [Array<Embed>] the embeds attached to this message.
    attr_reader :embeds

    # @return [Rubycord::AllowedMentions, Hash, nil] Mentions that are allowed to ping in this message.
    # @see https://discord.com/developers/docs/resources/channel#allowed-mentions-object
    attr_accessor :allowed_mentions

    # @return [View, Array<Hash>, nil] Interaction components to associate with this message.
    # @note Only work with webhook owned by your application, otherwise not used on Discord side.
    attr_accessor :components

    # @return [String, Hash] a string or hash to provide to API to create a message.
    def to_payload
      files = [@file].flatten.compact

      payload_json = {
        content: @content, username: @username, avatar_url: @avatar_url, tts: @tts,
        attachments: @attachments, embeds: @embeds.map(&:to_hash),
        allowed_mentions: @allowed_mentions&.to_hash, components: @components.to_a
      }.compact.to_json

      if files.size > 0
        multipart_payload = {}

        files.each.with_index { |e, i| multipart_payload[i.to_s] = Faraday::Multipart::FilePart.new(e, "application/octet-stream") }

        multipart_payload[:payload_json] = Faraday::Multipart::ParamPart.new(payload_json, "application/json")

        multipart_payload
      else
        payload_json
      end
    end

    # @return [Hash] a hash representation of the created message, for JSON format.
    def to_json_hash
      {
        content: @content, username: @username, avatar_url: @avatar_url, tts: @tts,
        attachments: @attachments, embeds: @embeds.map(&:to_hash),
        allowed_mentions: @allowed_mentions&.to_hash, components: @components.to_a
      }.compact
    end
  end
end
