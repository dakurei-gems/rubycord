# API calls for Invite object
module Rubycord::API::Invite
  module_function

  # Resolve an invite
  # https://discord.com/developers/docs/resources/invite#get-invite
  def resolve(token, invite_code, counts = true)
    Rubycord::API.request(
      :invite_code,
      nil,
      :get,
      "#{Rubycord::API.api_base}/invites/#{invite_code}#{counts ? "?with_counts=true" : ""}",
      authorization: token
    )
  end

  # Delete an invite by code
  # https://discord.com/developers/docs/resources/invite#delete-invite
  def delete(token, code, reason = nil)
    Rubycord::API.request(
      :invites_code,
      nil,
      :delete,
      "#{Rubycord::API.api_base}/invites/#{code}",
      authorization: token,
      x_audit_log_reason: reason
    )
  end

  # Join a server using an invite
  # https://discord.com/developers/docs/resources/invite#accept-invite
  def accept(token, invite_code)
    Rubycord::API.request(
      :invite_code,
      nil,
      :post,
      "#{Rubycord::API.api_base}/invites/#{invite_code}",
      nil,
      authorization: token
    )
  end
end
