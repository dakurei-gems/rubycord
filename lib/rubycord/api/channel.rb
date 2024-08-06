# API calls for Channel
module Rubycord::API::Channel
  module_function

  # Get a channel's data
  # https://discord.com/developers/docs/resources/channel#get-channel
  def resolve(token, channel_id)
    Rubycord::API.request(
      :channels_cid,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}",
      nil,
      authorization: token
    )
  end

  # Update a channel's data
  # https://discord.com/developers/docs/resources/channel#modify-channel
  def update(token, channel_id, name, topic, position, bitrate, user_limit, nsfw, permission_overwrites = nil, parent_id = nil, rate_limit_per_user = nil, reason = nil)
    data = {name: name, position: position, topic: topic, bitrate: bitrate, user_limit: user_limit, nsfw: nsfw, parent_id: parent_id, rate_limit_per_user: rate_limit_per_user}
    data[:permission_overwrites] = permission_overwrites unless permission_overwrites.nil?
    Rubycord::API.request(
      :channels_cid,
      channel_id,
      :patch,
      "#{Rubycord::API.api_base}/channels/#{channel_id}",
      data.to_json,
      authorization: token,
      content_type: "application/json",
      x_audit_log_reason: reason
    )
  end

  # Delete a channel
  # https://discord.com/developers/docs/resources/channel#deleteclose-channel
  def delete(token, channel_id, reason = nil)
    Rubycord::API.request(
      :channels_cid,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}",
      nil,
      authorization: token,
      x_audit_log_reason: reason
    )
  end

  # Get a list of messages from a channel's history
  # https://discord.com/developers/docs/resources/channel#get-channel-messages
  def messages(token, channel_id, amount, before = nil, after = nil, around = nil)
    Rubycord::API.request(
      :channels_cid_messages,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages",
      {limit: amount, before: before, after: after, around: around}.compact,
      authorization: token
    )
  end

  # Get a single message from a channel's history by id
  # https://discord.com/developers/docs/resources/channel#get-channel-message
  def message(token, channel_id, message_id)
    Rubycord::API.request(
      :channels_cid_messages_mid,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}",
      nil,
      authorization: token
    )
  end

  # Send a message to a channel
  # https://discord.com/developers/docs/resources/channel#create-message
  # @param attachments [Array<File>, nil] Attachments to use with `attachment://` in embeds. See
  #   https://discord.com/developers/docs/resources/channel#create-message-using-attachments-within-embeds
  def create_message(token, channel_id, message, tts = false, embeds = nil, nonce = nil, attachments = nil, allowed_mentions = nil, message_reference = nil, components = nil)
    files = [attachments].flatten.compact

    headers = {authorization: token}

    payload_json = {
      content: message, tts: tts, embeds: embeds, nonce: nonce, allowed_mentions: allowed_mentions,
      message_reference: message_reference, components: components&.to_a
    }.to_json

    payload = if files.size > 0
      multipart_payload = {}

      files.each.with_index { |e, i| multipart_payload[i.to_s] = Faraday::Multipart::FilePart.new(e, "application/octet-stream") }

      multipart_payload[:payload_json] = Faraday::Multipart::ParamPart.new(payload_json, "application/json")

      multipart_payload
    else
      headers[:content_type] = "application/json"

      payload_json
    end

    Rubycord::API.request(
      :channels_cid_messages_mid,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages",
      payload,
      **headers
    )
  rescue Faraday::BadRequestError => e
    parsed = JSON.parse(e.response.body)
    raise Rubycord::Errors::MessageTooLong, "Message over the character limit (#{message.length} > 2000)" if parsed["content"].is_a?(Array) && parsed["content"].first == "Must be 2000 or fewer in length."

    raise
  end

  # Send a file as a message to a channel
  # https://discord.com/developers/docs/resources/channel#upload-file
  def upload_file(token, channel_id, file, caption: nil, tts: false, filename: nil)
    payload = {
      0 => Faraday::Multipart::FilePart.new(file, "application/octet-stream", filename)
    }

    if caption || tts
      payload[:payload_json] = Faraday::Multipart::ParamPart.new({content: caption, tts: tts}.to_json, "application/json")
    end

    Rubycord::API.request(
      :channels_cid_messages_mid,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages",
      payload,
      authorization: token
    )
  end

  # Edit a message
  # https://discord.com/developers/docs/resources/channel#edit-message
  def edit_message(token, channel_id, message_id, message, mentions = [], embeds = nil, components = nil)
    Rubycord::API.request(
      :channels_cid_messages_mid,
      channel_id,
      :patch,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}",
      {content: message, mentions: mentions, embeds: embeds, components: components}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Delete a message
  # https://discord.com/developers/docs/resources/channel#delete-message
  def delete_message(token, channel_id, message_id, reason = nil)
    Rubycord::API.request(
      :channels_cid_messages_mid,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}",
      nil,
      authorization: token,
      x_audit_log_reason: reason
    )
  end

  # Delete messages in bulk
  # https://discord.com/developers/docs/resources/channel#bulk-delete-messages
  def bulk_delete_messages(token, channel_id, messages = [], reason = nil)
    Rubycord::API.request(
      :channels_cid_messages_bulk_delete,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/bulk-delete",
      {messages: messages}.to_json,
      authorization: token,
      content_type: "application/json",
      x_audit_log_reason: reason
    )
  end

  # Create a reaction on a message using this client
  # https://discord.com/developers/docs/resources/channel#create-reaction
  def create_reaction(token, channel_id, message_id, emoji)
    emoji = URI.encode_www_form_component(emoji) unless emoji.ascii_only?
    Rubycord::API.request(
      :channels_cid_messages_mid_reactions_emoji_me,
      channel_id,
      :put,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}/@me",
      nil,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Delete this client's own reaction on a message
  # https://discord.com/developers/docs/resources/channel#delete-own-reaction
  def delete_own_reaction(token, channel_id, message_id, emoji)
    emoji = URI.encode_www_form_component(emoji) unless emoji.ascii_only?
    Rubycord::API.request(
      :channels_cid_messages_mid_reactions_emoji_me,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}/@me",
      nil,
      authorization: token
    )
  end

  # Delete another client's reaction on a message
  # https://discord.com/developers/docs/resources/channel#delete-user-reaction
  def delete_user_reaction(token, channel_id, message_id, emoji, user_id)
    emoji = URI.encode_www_form_component(emoji) unless emoji.ascii_only?
    Rubycord::API.request(
      :channels_cid_messages_mid_reactions_emoji_uid,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}/#{user_id}",
      nil,
      authorization: token
    )
  end

  # Get a list of clients who reacted with a specific reaction on a message
  # https://discord.com/developers/docs/resources/channel#get-reactions
  def get_reactions(token, channel_id, message_id, emoji, before_id, after_id, limit = 100)
    emoji = URI.encode_www_form_component(emoji) unless emoji.ascii_only?
    Rubycord::API.request(
      :channels_cid_messages_mid_reactions_emoji,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}",
      {limit: limit || 100, before: before_id, after: after_id}.compact,
      authorization: token
    )
  end

  # Deletes all reactions on a message from all clients
  # https://discord.com/developers/docs/resources/channel#delete-all-reactions
  def delete_all_reactions(token, channel_id, message_id)
    Rubycord::API.request(
      :channels_cid_messages_mid_reactions,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions",
      nil,
      authorization: token
    )
  end

  # Deletes all the reactions for a given emoji on a message
  # https://discord.com/developers/docs/resources/channel#delete-all-reactions-for-emoji
  def delete_all_emoji_reactions(token, channel_id, message_id, emoji)
    emoji = URI.encode_www_form_component(emoji) unless emoji.ascii_only?

    Rubycord::API.request(
      :channels_cid_messages_mid_reactions_emoji,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}",
      nil,
      authorization: token
    )
  end

  # Update a channels permission for a role or member
  # https://discord.com/developers/docs/resources/channel#edit-channel-permissions
  def update_permission(token, channel_id, overwrite_id, allow, deny, type, reason = nil)
    Rubycord::API.request(
      :channels_cid_permissions_oid,
      channel_id,
      :put,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/permissions/#{overwrite_id}",
      {type: type, id: overwrite_id, allow: allow, deny: deny}.to_json,
      authorization: token,
      content_type: "application/json",
      x_audit_log_reason: reason
    )
  end

  # Get a channel's invite list
  # https://discord.com/developers/docs/resources/channel#get-channel-invites
  def invites(token, channel_id)
    Rubycord::API.request(
      :channels_cid_invites,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/invites",
      nil,
      authorization: token
    )
  end

  # Create an instant invite from a server or a channel id
  # https://discord.com/developers/docs/resources/channel#create-channel-invite
  def create_invite(token, channel_id, max_age = 0, max_uses = 0, temporary = false, unique = false, reason = nil)
    Rubycord::API.request(
      :channels_cid_invites,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/invites",
      {max_age: max_age, max_uses: max_uses, temporary: temporary, unique: unique}.to_json,
      authorization: token,
      content_type: "application/json",
      x_audit_log_reason: reason
    )
  end

  # Delete channel permission
  # https://discord.com/developers/docs/resources/channel#delete-channel-permission
  def delete_permission(token, channel_id, overwrite_id, reason = nil)
    Rubycord::API.request(
      :channels_cid_permissions_oid,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/permissions/#{overwrite_id}",
      nil,
      authorization: token,
      x_audit_log_reason: reason
    )
  end

  # Start typing (needs to be resent every 5 seconds to keep up the typing)
  # https://discord.com/developers/docs/resources/channel#trigger-typing-indicator
  def start_typing(token, channel_id)
    Rubycord::API.request(
      :channels_cid_typing,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/typing",
      nil,
      authorization: token
    )
  end

  # Get a list of pinned messages in a channel
  # https://discord.com/developers/docs/resources/channel#get-pinned-messages
  def pinned_messages(token, channel_id)
    Rubycord::API.request(
      :channels_cid_pins,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/pins",
      nil,
      authorization: token
    )
  end

  # Pin a message
  # https://discord.com/developers/docs/resources/channel#add-pinned-channel-message
  def pin_message(token, channel_id, message_id, reason = nil)
    Rubycord::API.request(
      :channels_cid_pins_mid,
      channel_id,
      :put,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/pins/#{message_id}",
      nil,
      authorization: token,
      x_audit_log_reason: reason
    )
  end

  # Unpin a message
  # https://discord.com/developers/docs/resources/channel#delete-pinned-channel-message
  def unpin_message(token, channel_id, message_id, reason = nil)
    Rubycord::API.request(
      :channels_cid_pins_mid,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/pins/#{message_id}",
      nil,
      authorization: token,
      x_audit_log_reason: reason
    )
  end

  # Create an empty group channel.
  # @deprecated Discord no longer supports bots in group DMs, this endpoint was repurposed and no longer works as implemented here.
  # https://discord.com/developers/docs/resources/user#create-group-dm
  def create_empty_group(token, bot_user_id)
    Rubycord::API.request(
      :users_uid_channels,
      nil,
      :post,
      "#{Rubycord::API.api_base}/users/#{bot_user_id}/channels",
      {}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Create a group channel.
  # @deprecated Discord no longer supports bots in group DMs, this endpoint was repurposed and no longer works as implemented here.
  # https://discord.com/developers/docs/resources/channel#group-dm-add-recipient
  def create_group(token, pm_channel_id, user_id)
    response = Rubycord::API.request(
      :channels_cid_recipients_uid,
      nil,
      :put,
      "#{Rubycord::API.api_base}/channels/#{pm_channel_id}/recipients/#{user_id}",
      {}.to_json,
      authorization: token,
      content_type: "application/json"
    )
    raise("Attempted to create a group channel with the PM channel recipient!") if response.status == 204
  rescue Faraday::ServerError
    raise "Attempted to add self as a new group channel recipient!"
  rescue Faraday::ForbiddenError
    raise "Attempted to add a user to group channel without permission!"
  end

  # Add a user to a group channel.
  # @deprecated Discord no longer supports bots in group DMs, this endpoint was repurposed and no longer works as implemented here.
  # https://discord.com/developers/docs/resources/channel#group-dm-add-recipient
  def add_group_user(token, group_channel_id, user_id)
    Rubycord::API.request(
      :channels_cid_recipients_uid,
      nil,
      :put,
      "#{Rubycord::API.api_base}/channels/#{group_channel_id}/recipients/#{user_id}",
      {}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Remove a user from a group channel.
  # @deprecated Discord no longer supports bots in group DMs, this endpoint was repurposed and no longer works as implemented here.
  # https://discord.com/developers/docs/resources/channel#group-dm-remove-recipient
  def remove_group_user(token, group_channel_id, user_id)
    Rubycord::API.request(
      :channels_cid_recipients_uid,
      nil,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{group_channel_id}/recipients/#{user_id}",
      nil,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Leave a group channel.
  # @deprecated Discord no longer supports bots in group DMs, this endpoint was repurposed and no longer works as implemented here.
  # https://discord.com/developers/docs/resources/channel#deleteclose-channel
  def leave_group(token, group_channel_id)
    Rubycord::API.request(
      :channels_cid,
      nil,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{group_channel_id}",
      nil,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Create a webhook
  # https://discord.com/developers/docs/resources/webhook#create-webhook
  def create_webhook(token, channel_id, name, avatar = nil, reason = nil)
    Rubycord::API.request(
      :channels_cid_webhooks,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/webhooks",
      {name: name, avatar: avatar}.to_json,
      authorization: token,
      content_type: "application/json",
      x_audit_log_reason: reason
    )
  end

  # Get channel webhooks
  # https://discord.com/developers/docs/resources/webhook#get-channel-webhooks
  def webhooks(token, channel_id)
    Rubycord::API.request(
      :channels_cid_webhooks,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/webhooks",
      nil,
      authorization: token
    )
  end

  # Start a thread based off a channel message.
  # https://discord.com/developers/docs/resources/channel#start-thread-with-message
  def start_thread_with_message(token, channel_id, message_id, name, auto_archive_duration)
    Rubycord::API.request(
      :channels_cid_messages_mid_threads,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/messages/#{message_id}/threads",
      {name: name, auto_archive_duration: auto_archive_duration}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Start a thread without an associated message.
  # https://discord.com/developers/docs/resources/channel#start-thread-without-message
  def start_thread_without_message(token, channel_id, name, auto_archive_duration, type = 11)
    Rubycord::API.request(
      :channels_cid_threads,
      channel_id,
      :post,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/threads",
      {name: name, auto_archive_duration: auto_archive_duration, type: type}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Add the current user to a thread.
  # https://discord.com/developers/docs/resources/channel#join-thread
  def join_thread(token, channel_id)
    Rubycord::API.request(
      :channels_cid_thread_members_me,
      channel_id,
      :put,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/thread-members/@me",
      nil,
      authorization: token
    )
  end

  # Add a user to a thread.
  # https://discord.com/developers/docs/resources/channel#add-thread-member
  def add_thread_member(token, channel_id, user_id)
    Rubycord::API.request(
      :channels_cid_thread_members_uid,
      channel_id,
      :put,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/thread-members/#{user_id}",
      nil,
      authorization: token
    )
  end

  # Remove the current user from a thread.
  # https://discord.com/developers/docs/resources/channel#leave-thread
  def leave_thread(token, channel_id)
    Rubycord::API.request(
      :channels_cid_thread_members_me,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/thread-members/#{user_id}",
      nil,
      authorization: token
    )
  end

  # Remove a user from a thread.
  # https://discord.com/developers/docs/resources/channel#remove-thread-member
  def remove_thread_member(token, channel_id, user_id)
    Rubycord::API.request(
      :channels_cid_thread_members_uid,
      channel_id,
      :delete,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/thread-members/#{user_id}",
      nil,
      authorization: token
    )
  end

  # Get the members of a thread.
  # https://discord.com/developers/docs/resources/channel#list-thread-members
  def list_thread_members(token, channel_id, before, limit)
    Rubycord::API.request(
      :channels_cid_thread_members,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/thread-members",
      {before: before, limit: limit}.compact,
      authorization: token
    )
  end

  # List active threads
  # https://discord.com/developers/docs/resources/channel#list-active-threads
  def list_active_threads(token, channel_id)
    Rubycord::API.request(
      :channels_cid_threads_active,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/threads/active",
      nil,
      authorization: token
    )
  end

  # List public archived threads.
  # https://discord.com/developers/docs/resources/channel#list-public-archived-threads
  def list_public_archived_threads(token, channel_id, before = nil, limit = nil)
    Rubycord::API.request(
      :channels_cid_threads_archived_public,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/threads/archived/public",
      {before: before, limit: limit}.compact,
      authorization: token
    )
  end

  # List private archived threads.
  # https://discord.com/developers/docs/resources/channel#list-private-archived-threads
  def list_private_archived_threads(token, channel_id, before = nil, limit = nil)
    Rubycord::API.request(
      :channels_cid_threads_archived_private,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/threads/archived/private",
      {before: before, limit: limit}.compact,
      authorization: token
    )
  end

  # List joined private archived threads.
  # https://discord.com/developers/docs/resources/channel#list-joined-private-archived-threads
  def list_joined_private_archived_threads(token, channel_id, before = nil, limit = nil)
    Rubycord::API.request(
      :channels_cid_users_me_threads_archived_private,
      channel_id,
      :get,
      "#{Rubycord::API.api_base}/channels/#{channel_id}/users/@me/threads/archived/private",
      {before: before, limit: limit}.compact,
      authorization: token
    )
  end
end
