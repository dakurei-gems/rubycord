# API calls for User object
module Rubycord::API::User
  module_function

  # Get user data
  # https://discord.com/developers/docs/resources/user#get-user
  def resolve(token, user_id)
    Rubycord::API.request(
      :users_uid,
      nil,
      :get,
      "#{Rubycord::API.api_base}/users/#{user_id}",
      authorization: token
    )
  end

  # Get profile data
  # https://discord.com/developers/docs/resources/user#get-current-user
  def profile(token)
    Rubycord::API.request(
      :users_me,
      nil,
      :get,
      "#{Rubycord::API.api_base}/users/@me",
      authorization: token
    )
  end

  # Change the current bot's nickname on a server
  # https://discord.com/developers/docs/resources/user#modify-current-user
  def change_own_nickname(token, server_id, nick, reason = nil)
    Rubycord::API.request(
      :guilds_sid_members_me_nick,
      server_id, # This is technically a guild endpoint
      :patch,
      "#{Rubycord::API.api_base}/guilds/#{server_id}/members/@me/nick",
      {nick: nick}.to_json,
      authorization: token,
      content_type: "application/json",
      x_audit_log_reason: reason
    )
  end

  # Update user data
  # https://discord.com/developers/docs/resources/user#modify-current-user
  def update_profile(token, email, password, new_username, avatar, new_password = nil)
    Rubycord::API.request(
      :users_me,
      nil,
      :patch,
      "#{Rubycord::API.api_base}/users/@me",
      {avatar: avatar, email: email, new_password: new_password, password: password, username: new_username}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Get the servers a user is connected to
  # https://discord.com/developers/docs/resources/user#get-current-user-guilds
  def servers(token)
    Rubycord::API.request(
      :users_me_guilds,
      nil,
      :get,
      "#{Rubycord::API.api_base}/users/@me/guilds",
      authorization: token
    )
  end

  # Leave a server
  # https://discord.com/developers/docs/resources/user#leave-guild
  def leave_server(token, server_id)
    Rubycord::API.request(
      :users_me_guilds_sid,
      nil,
      :delete,
      "#{Rubycord::API.api_base}/users/@me/guilds/#{server_id}",
      authorization: token
    )
  end

  # Get the DMs for the current user
  # https://discord.com/developers/docs/resources/user#get-user-dms
  def user_dms(token)
    Rubycord::API.request(
      :users_me_channels,
      nil,
      :get,
      "#{Rubycord::API.api_base}/users/@me/channels",
      authorization: token
    )
  end

  # Create a DM to another user
  # https://discord.com/developers/docs/resources/user#create-dm
  def create_pm(token, recipient_id)
    Rubycord::API.request(
      :users_me_channels,
      nil,
      :post,
      "#{Rubycord::API.api_base}/users/@me/channels",
      {recipient_id: recipient_id}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Get information about a user's connections
  # https://discord.com/developers/docs/resources/user#get-users-connections
  def connections(token)
    Rubycord::API.request(
      :users_me_connections,
      nil,
      :get,
      "#{Rubycord::API.api_base}/users/@me/connections",
      authorization: token
    )
  end

  # Change user status setting
  def change_status_setting(token, status)
    Rubycord::API.request(
      :users_me_settings,
      nil,
      :patch,
      "#{Rubycord::API.api_base}/users/@me/settings",
      {status: status}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Returns one of the "default" discord avatars from the CDN given a discriminator or id since new usernames
  # TODO: Maybe change this method again after discriminator removal ?
  def default_avatar(discrim_id = 0, legacy: false)
    index = if legacy
      discrim_id.to_i % 5
    else
      (discrim_id.to_i >> 22) % 5
    end
    "#{Rubycord::API.cdn_url}/embed/avatars/#{index}.png"
  end

  # Make an avatar URL from the user and avatar IDs
  def avatar_url(user_id, avatar_id, format = nil)
    format ||= if avatar_id.start_with?("a_")
      "gif"
    else
      "webp"
    end
    "#{Rubycord::API.cdn_url}/avatars/#{user_id}/#{avatar_id}.#{format}"
  end
end
