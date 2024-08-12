require "rubycord"
require "securerandom"

CHANNEL_EDIT = ENV.fetch("CHANNEL_EDIT")
ROLE_1 = ENV.fetch("ROLE_1")
ROLE_2 = ENV.fetch("ROLE_2")

bot = Rubycord::Bot.new(token: ENV.fetch("RUBYCORD_TOKEN"))

bot.message do |event|
  if event.message.content == "DEFINE_OVERWRITE"
    event.channel.send_message("Define overwrite in this channel")

    allow = Rubycord::Permissions.new
    allow.can_mention_everyone = true

    overwrite = Rubycord::Overwrite.new(ROLE_1, type: "role", allow: allow, deny: Rubycord::Permissions.new)

    event.bot.channel(CHANNEL_EDIT, event.server).define_overwrite(overwrite)
  end

  if event.message.content == "CHECK_OVERWRITE"
    event.channel.send_message("Check overwrite in this channel")
    puts(event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites.map { |_, v| "#{v.type} - #{v.id} - #{v.allow.bits} / #{v.deny.bits}" })
  end

  if event.message.content == "DELETE_OVERWRITE"
    event.channel.send_message("Delete overwrite in this channel")

    event.bot.channel(CHANNEL_EDIT, event.server).delete_overwrite(ROLE_1)
  end

  if event.message.content == "BULK_OVERWRITE"
    event.channel.send_message("Bulk overwrite in this channel")

    allow = Rubycord::Permissions.new
    allow.can_mention_everyone = true

    deny = Rubycord::Permissions.new
    deny.can_mention_everyone = true

    overwrites = []
    overwrites << Rubycord::Overwrite.new(ROLE_1, type: "role", allow: allow, deny: Rubycord::Permissions.new)
    overwrites << Rubycord::Overwrite.new(ROLE_2, type: "role", allow: Rubycord::Permissions.new, deny: deny)

    event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites = overwrites
    puts(event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites.map { |_, v| "#{v.type} - #{v.id} - #{v.allow.bits} / #{v.deny.bits}" })

    # Bulk edit from permission_overwrites return values (this method return a Hash and not an Array)
    event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites = event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites.dup
    puts(event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites.map { |_, v| "#{v.type} - #{v.id} - #{v.allow.bits} / #{v.deny.bits}" })

    # Send nil to check if permission_overwrites not changed
    event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites = nil
    puts(event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites.map { |_, v| "#{v.type} - #{v.id} - #{v.allow.bits} / #{v.deny.bits}" })
  end

  if event.message.content == "BULK_DELETE_OVERWRITE"
    event.channel.send_message("Bulk delete overwrite in this channel")
    event.bot.channel(CHANNEL_EDIT, event.server).permission_overwrites = []
  end
end

bot.run
