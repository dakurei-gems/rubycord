# API calls for slash commands.
module Rubycord::API::Application
  module_function

  # Get a list of global application commands.
  # https://discord.com/developers/docs/interactions/slash-commands#get-global-application-commands
  def get_global_commands(token, application_id)
    Rubycord::API.request(
      :applications_aid_commands,
      nil,
      :get,
      "#{Rubycord::API.api_base}/applications/#{application_id}/commands",
      nil,
      authorization: token
    )
  end

  # Get a global application command by ID.
  # https://discord.com/developers/docs/interactions/slash-commands#get-global-application-command
  def get_global_command(token, application_id, command_id)
    Rubycord::API.request(
      :applications_aid_commands_cid,
      nil,
      :get,
      "#{Rubycord::API.api_base}/applications/#{application_id}/commands/#{command_id}",
      nil,
      authorization: token
    )
  end

  # Create a global application command.
  # https://discord.com/developers/docs/interactions/slash-commands#create-global-application-command
  def create_global_command(token, application_id, name, description, options = [], default_permission = nil, type = 1)
    Rubycord::API.request(
      :applications_aid_commands,
      nil,
      :post,
      "#{Rubycord::API.api_base}/applications/#{application_id}/commands",
      {name: name, description: description, options: options, default_permission: default_permission, type: type}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Edit a global application command.
  # https://discord.com/developers/docs/interactions/slash-commands#edit-global-application-command
  def edit_global_command(token, application_id, command_id, name = nil, description = nil, options = nil, default_permission = nil, type = 1)
    Rubycord::API.request(
      :applications_aid_commands_cid,
      nil,
      :patch,
      "#{Rubycord::API.api_base}/applications/#{application_id}/commands/#{command_id}",
      {name: name, description: description, options: options, default_permission: default_permission, type: type}.compact.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Delete a global application command.
  # https://discord.com/developers/docs/interactions/slash-commands#delete-global-application-command
  def delete_global_command(token, application_id, command_id)
    Rubycord::API.request(
      :applications_aid_commands_cid,
      nil,
      :delete,
      "#{Rubycord::API.api_base}/applications/#{application_id}/commands/#{command_id}",
      nil,
      authorization: token
    )
  end

  # Set global application commands in bulk.
  # https://discord.com/developers/docs/interactions/slash-commands#bulk-overwrite-global-application-commands
  def bulk_overwrite_global_commands(token, application_id, commands)
    Rubycord::API.request(
      :applications_aid_commands,
      nil,
      :put,
      "#{Rubycord::API.api_base}/applications/#{application_id}/commands",
      commands.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Get a guild's commands for an application.
  # https://discord.com/developers/docs/interactions/slash-commands#get-guild-application-commands
  def get_guild_commands(token, application_id, guild_id)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands,
      guild_id,
      :get,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands",
      nil,
      authorization: token
    )
  end

  # Get a guild command by ID.
  # https://discord.com/developers/docs/interactions/slash-commands#get-guild-application-command
  def get_guild_command(token, application_id, guild_id, command_id)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands_cid,
      guild_id,
      :get,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands/#{command_id}",
      nil,
      authorization: token
    )
  end

  # Create an application command for a guild.
  # https://discord.com/developers/docs/interactions/slash-commands#create-guild-application-command
  def create_guild_command(token, application_id, guild_id, name, description, options = nil, default_permission = nil, type = 1)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands,
      guild_id,
      :post,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands",
      {name: name, description: description, options: options, default_permission: default_permission, type: type}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Edit an application command for a guild.
  # https://discord.com/developers/docs/interactions/slash-commands#edit-guild-application-command
  def edit_guild_command(token, application_id, guild_id, command_id, name = nil, description = nil, options = nil, default_permission = nil, type = 1)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands_cid,
      guild_id,
      :patch,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands/#{command_id}",
      {name: name, description: description, options: options, default_permission: default_permission, type: type}.compact.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Delete an application command for a guild.
  # https://discord.com/developers/docs/interactions/slash-commands#delete-guild-application-command
  def delete_guild_command(token, application_id, guild_id, command_id)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands_cid,
      guild_id,
      :delete,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands/#{command_id}",
      nil,
      authorization: token
    )
  end

  # Set guild commands in bulk.
  # https://discord.com/developers/docs/interactions/slash-commands#bulk-overwrite-guild-application-commands
  def bulk_overwrite_guild_commands(token, application_id, guild_id, commands)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands,
      guild_id,
      :put,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands",
      commands.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Get the permissions for a specific guild command.
  # https://discord.com/developers/docs/interactions/slash-commands#get-application-command-permissions
  def get_guild_command_permissions(token, application_id, guild_id)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands_permissions,
      guild_id,
      :get,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands/permissions",
      nil,
      authorization: token
    )
  end

  # Edit the permissions for a specific guild command.
  # https://discord.com/developers/docs/interactions/slash-commands#edit-application-command-permissions
  def edit_guild_command_permissions(token, application_id, guild_id, command_id, permissions)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands_cid_permissions,
      guild_id,
      :put,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands/#{command_id}/permissions",
      {permissions: permissions}.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end

  # Edit permissions for all commands in a guild.
  # https://discord.com/developers/docs/interactions/slash-commands#batch-edit-application-command-permissions
  def batch_edit_command_permissions(token, application_id, guild_id, permissions)
    Rubycord::API.request(
      :applications_aid_guilds_gid_commands_cid_permissions,
      guild_id,
      :put,
      "#{Rubycord::API.api_base}/applications/#{application_id}/guilds/#{guild_id}/commands/permissions",
      permissions.to_json,
      authorization: token,
      content_type: "application/json"
    )
  end
end
