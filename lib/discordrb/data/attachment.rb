module Discordrb
  # Mixin for the attributes attachments should have
  module AttachmentAttributes
    # Types of attachment's flags mapped to their API value.
    #   List of flags available here: https://discord.com/developers/docs/resources/message#attachment-object-attachment-flags
    FLAGS = {
      remix: 1 << 2,  # IS_REMIX : this attachment has been edited using the remix feature on mobile
      spoiler: 1 << 3 #          : this attachment has been set to spoiler mode (not officially listed in doc, but seems to be the case after several tests)
    }.freeze

    # @return [Integer] attachment flags combined as a bitfield.
    attr_reader :flags

    # @!method remix?
    #   @return [true, false] whether this file has flag IS_REMIX.
    # @!method spoiler?
    #   @note Unofficial flag
    #   @return [true, false] whether this file has flag IS_SPOILER.
    FLAGS.each do |name, value|
      define_method(:"#{name}?") do
        (@flags & value).positive?
      end
    end
  end

  # An attachment to a message
  class Attachment
    include IDObject
    include AttachmentAttributes

    # @return [Message] the message this attachment belongs to.
    attr_reader :message

    # @return [String] the attachment's filename.
    attr_reader :filename

    # @return [String, nil] the attachment's title.
    attr_reader :title

    # @return [String, nil] the attachment's description.
    attr_reader :description

    # @return [String, nil] the attachment's media type.
    attr_reader :content_type

    # @return [Integer] the attachment's file size in bytes.
    attr_reader :size

    # @return [String] the CDN URL this attachment can be downloaded at.
    attr_reader :url

    # @return [String] the attachment's proxy URL - I'm not sure what exactly this does, but I think it has something to
    #   do with CDNs.
    attr_reader :proxy_url

    # @return [Integer, nil] the height of an image file, in pixels, or `nil` if the file is not an image.
    attr_reader :height

    # @return [Integer, nil] the width of an image file, in pixels, or `nil` if the file is not an image.
    attr_reader :width

    # @return [Float, nil] the duration of the audio file (currently for voice messages).
    attr_reader :duration_secs

    # @return [String, nil] base64 encoded bytearray representing a sampled waveform (currently for voice messages).
    attr_reader :waveform

    # @return [true, false] whether this attachment is ephemeral.
    attr_reader :ephemeral
    alias_method :ephemeral?, :ephemeral

    # @!visibility private
    def initialize(data, message, bot)
      @bot = bot
      @message = message

      @id = data["id"].resolve_id

      @filename = data["filename"]
      @title = data["title"]
      @description = data["description"]

      @content_type = data["content_type"]
      @size = data["size"]

      @url = data["url"]
      @proxy_url = data["proxy_url"]

      @height = data["height"]
      @width = data["width"]
      @duration_secs = data["duration_secs"]
      @waveform = data["waveform"]

      @flags = data["flags"].to_i
      @ephemeral = data["ephemeral"]
    end

    # @return [true, false] whether this file is an image file.
    def image?
      !(@width.nil? || @height.nil?)
    end

    # @return [true, false] whether this file is an audio file.
    def audio?
      !@duration_secs.nil?
    end
  end
end
