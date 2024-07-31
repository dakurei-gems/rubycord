module Discordrb
  # Custom errors raised in various places
  module Errors
    # Raised when authentication data is invalid or incorrect.
    class InvalidAuthenticationError < RuntimeError
      # Default message for this exception
      def message
        "User login failed due to an invalid email or password!"
      end
    end

    # Raised when a message is over the character limit
    class MessageTooLong < RuntimeError; end

    # Raised when the bot can't do something because its permissions on the server are insufficient
    class NoPermission < RuntimeError; end

    # Raised when the bot gets a HTTP 502 error, which is usually caused by Cloudflare.
    class CloudflareError < RuntimeError; end

    # Raised when using a webhook method without an associated token.
    class UnauthorizedWebhook < RuntimeError; end

    # Generic class for errors denoted by API error codes
    class CodeError < RuntimeError
      class << self
        # @return [Integer] The error code represented by this error class.
        attr_reader :code
      end

      # Create a new error with a particular message (the code should be defined by the class instance variable)
      # @param message [String] the message to use
      # @param errors [Hash] API errors
      def initialize(message, errors = nil)
        @message = message

        @errors = errors ? flatten_errors(errors) : []
      end

      # @return [Integer] The error code represented by this error.
      def code
        self.class.code
      end

      # @return [String] A message including the message and flattened errors.
      def full_message(*)
        error_list = @errors.collect { |err| "\t- #{err}" }

        "#{@message}\n#{error_list.join("\n")}"
      end

      # @return [String] This error's represented message
      attr_reader :message

      # @return [Hash] More precise errors
      attr_reader :errors

      private

      # @!visibility hidden
      # Flattens errors into a more easily read format.
      # @example Flattening errors of a bad field
      #   flatten_errors(data['errors'])
      #   # => ["embed.fields[0].name: This field is required", "embed.fields[0].value: This field is required"]
      def flatten_errors(err, prev_key = nil)
        err.collect do |key, sub_err|
          if prev_key
            key = /\A\d+\Z/.match?(key) ? "#{prev_key}[#{key}]" : "#{prev_key}.#{key}"
          end

          if (errs = sub_err["_errors"])
            "#{key}: #{errs.map { |e| e["message"] }.join(" ")}"
          elsif sub_err["message"] || sub_err["code"]
            "#{sub_err["code"] ? "#{sub_err["code"]}: " : nil}#{err_msg}"
          elsif sub_err.is_a? String
            sub_err
          else
            flatten_errors(sub_err, key)
          end
        end.flatten
      end
    end

    # Create a new code error class
    def self.Code(code)
      classy = Class.new(CodeError)
      classy.instance_variable_set(:@code, code)

      @code_classes ||= {}
      @code_classes[code] = classy

      classy
    end

    # @param code [Integer] The code to check
    # @return [Class] the error class for the given code
    def self.error_class_for(code)
      @code_classes[code] || UnknownError
    end

    # List of error codes available here:
    #   https://discord.com/developers/docs/topics/opcodes-and-status-codes#json-json-error-codes

    # Used when Discord doesn't provide a more specific code
    UnknownError = Code(0)

    # Unknown Account
    UnknownAccount = Code(10_001)

    # Unknown Application
    UnknownApplication = Code(10_002)

    # Unknown Channel
    UnknownChannel = Code(10_003)

    # Unknown Server
    UnknownServer = Code(10_004)

    # Unknown Integration
    UnknownIntegration = Code(10_005)

    # Unknown Invite
    UnknownInvite = Code(10_006)

    # Unknown Member
    UnknownMember = Code(10_007)

    # Unknown Message
    UnknownMessage = Code(10_008)

    # Unknown Permission Overwrite
    UnknownPermissionOverwrite = Code(10_009)

    # Unknown Provider
    UnknownProvider = Code(10_010)

    # Unknown Role
    UnknownRole = Code(10_011)

    # Unknown Token
    UnknownToken = Code(10_012)

    # Unknown User
    UnknownUser = Code(10_013)

    # Unknown Emoji
    UnknownEmoji = Code(10_014)

    # Unknown Webhook
    UnknownWebhook = Code(10_015)

    # Unknown Webhook Service
    UnknownWebhookService = Code(10_016)

    # Unknown Session
    UnknownSession = Code(10_020)

    # Unknown Ban
    UnknownBan = Code(10_026)

    # Unknown SKU
    UnknownSKU = Code(10_027)

    # Unknown Store Listing
    UnknownStoreListing = Code(10_028)

    # Unknown Entitlement
    UnknownEntitlement = Code(10_029)

    # Unknown Build
    UnknownBuild = Code(10_030)

    # Unknown Lobby
    UnknownLobby = Code(10_031)

    # Unknown Branch
    UnknownBranch = Code(10_032)

    # Unknown Store directory layout
    UnknownStoreDirectoryLayout = Code(10_033)

    # Unknown Redistribuable
    UnknownRedistribuable = Code(10_036)

    # Unknown Gift code
    UnknownGiftCode = Code(10_038)

    # Unknown Stream
    UnknownStream = Code(10_049)

    # Unknown Premium server subscribe cooldown
    UnknownPremiumServerSubscribeCooldown = Code(10_050)

    # Unknown Server Template
    UnknownServerTemplate = Code(10_057)

    # Unknown Discoverable server category
    UnknownDiscoverableServerCategory = Code(10_059)

    # Unknown Sticker
    UnknownSticker = Code(10_060)

    # Unknown Interaction
    UnknownInteraction = Code(10_062)

    # Unknown Application command
    UnknownApplicationCommand = Code(10_063)

    # Unknown Voice state
    UnknownVoiceState = Code(10_065)

    # Unknown Application command permissions
    UnknownApplicationCommandPermissions = Code(10_066)

    # Unknown Stage Instance
    UnknownStageInstance = Code(10_067)

    # Unknown Server member verification form
    UnknownServerMemberVerificationForm = Code(10_068)

    # Unknown Server welcome screen
    UnknownServerWelcomeScreen = Code(10_069)

    # Unknown Server scheduled event
    UnknownServerScheduledEvent = Code(10_070)

    # Unknown Server scheduled event user
    UnknownServerScheduledEventUser = Code(10_071)

    # Unknown Tag
    UnknownTag = Code(10_087)

    # Bots cannot use this endpoint
    EndpointNotForBots = Code(20_001)

    # Only bots can use this endpoint
    EndpointOnlyForBots = Code(20_002)

    # Explicit content cannot be sent to the desired recipient(s)
    ExplicitContentCannotBeSent = Code(20_009)

    # You are not authorized to perform this action on this application
    ActionNotAuthorizedOnApplication = Code(20_012)

    # This action cannot be performed due to slowmode rate limit
    ActionNotPerformedDueToSlowmode = Code(20_016)

    # Only the owner of this account can perform this action
    OnlyOwnerCanPerformAction = Code(20_018)

    # This message cannot be edited due to announcement rate limits
    EditMessageAnnouncementRateLimited = Code(20_022)

    # Under minimum age
    UnderMinimumAge = Code(20_024)

    # The channel you are writing has hit the write rate limit
    ChannelHitWriteRateLimit = Code(20_028)

    # The write action you are performing on the server has hit the write rate limit
    ServerHitWriteRateLimit = Code(20_029)

    # Your Stage topic, server name, server description, or channel names contain words that are not allowed
    ContainWordsNotAllowed = Code(20_031)

    # Guild premium subscription level too low
    GuildPremiumSubscriptionLevelTooLow = Code(20_035)

    # Maximum number of servers reached (100)
    ServerLimitReached = Code(30_001)

    # Maximum number of friends reached (1000)
    FriendLimitReached = Code(30_002)

    # Maximum number of pins reached (50)
    PinLimitReached = Code(30_003)

    # Maximum number of recipients reached (10)
    RecipientLimitReached = Code(30_004)

    # Maximum number of guild roles reached (250)
    RoleLimitReached = Code(30_005)

    # Maximum number of webhooks reached (15)
    WebhookLimitReached = Code(30_007)

    # Maximum number of emojis reached
    EmojiLimitReached = Code(30_008)

    # Maximum number of reactions reached (20)
    ReactionLimitReached = Code(30_010)

    # Maximum number of group DMs reached (10)
    GroupChannelLimitReached = Code(30_011)

    # Maximum number of guild channels reached (500)
    ChannelLimitReached = Code(30_013)

    # Maximum number of attachments in a message reached (10)
    MessageAttachmentLimitReached = Code(30_015)

    # Maximum number of invites reached (1000)
    InviteLimitReached = Code(30_016)

    # Maximum number of animated emojis reached
    AnimatedEmojiLimitReached = Code(30_018)

    # Maximum number of server members reached
    ServerMemberLimitReached = Code(30_019)

    # Maximum number of server categories has been reached (5)
    ServerCategoryLimitReached = Code(30_030)

    # Guild already has a template
    ServerAlreadyHasTemplate = Code(30_031)

    # Maximum number of application commands reached
    ApplicationCommandLimitReached = Code(30_032)

    # Maximum number of thread participants has been reached (1000)
    ThreadParticipantLimitReached = Code(30_033)

    # Maximum number of daily application command creates has been reached (200)
    ApplicationCommandCreateLimitReached = Code(30_034)

    # Maximum number of bans for non-guild members have been exceeded
    BanNonServerMemberLimitReached = Code(30_035)

    # Maximum number of bans fetches has been reached
    BanFetchLimitReached = Code(30_037)

    # Maximum number of uncompleted guild scheduled events reached (100)
    UncompletedServerScheduledEventLimitReached = Code(30_038)

    # Maximum number of stickers reached
    StickerLimitReached = Code(30_039)

    # Maximum number of prune requests has been reached. Try again later
    PruneRequestLimitReached = Code(30_040)

    # Maximum number of guild widget settings updates has been reached. Try again later
    ServerWidgetUpdateLimitReached = Code(30_042)

    # Maximum number of edits to messages older than 1 hour reached. Try again later
    MessageEditOlderOneHourLimitReached = Code(30_046)

    # Maximum number of pinned threads in a forum channel has been reached
    ForumPinnedThreadLimitReached = Code(30_047)

    # Maximum number of tags in a forum channel has been reached
    ForumTagLimitReached = Code(30_048)

    # Bitrate is too high for channel of this type
    BitrateTooHigh = Code(30_052)

    # Maximum number of premium emojis reached (25)
    PremiumEmojiLimitReached = Code(30_056)

    # Maximum number of webhooks per guild reached (1000)
    ServerWebhookLimitReached = Code(30_058)

    # Maximum number of channel permission overwrites reached (1000)
    ChannelPermissionOverwriteLimitReached = Code(30_060)

    # The channels for this guild are too large
    ServerChannelTooLarge = Code(30_061)

    # Unauthorized. Provide a valid token and try again
    Unauthorized = Unauthorised = Code(40_001)

    # You need to verify your account in order to perform this action
    NeedVerifiedAccount = Code(40_002)

    # You are opening direct messages too fast
    DirectMessageOpenTooFast = Code(40_003)

    # Send messages has been temporarily disabled
    SendMessageTemporarilyDisabled = Code(40_004)

    # Request entity too large. Try sending something smaller in size
    RequestEntityTooLarge = Code(40_005)

    # This feature has been temporarily disabled server-side
    ServerFeatureTemporarilyDisabled = Code(40_006)

    # The user is banned from this guild
    UserBannedFromServer = Code(40_007)

    # Connection has been revoked
    ConnectionRevoked = Code(40_012)

    # Target user is not connected to voice
    UserNotVoiceConnected = Code(40_032)

    # This message has already been crossposted
    MessageAlreadyCrossposted = Code(40_033)

    # An application command with that name already exists
    ApplicationCommandAlreadyExists = Code(40_041)

    # Application interaction failed to send
    ApplicationInteractionSendFailed = Code(40_043)

    # Cannot send a message in a forum channel
    ForumMessageCannotSend = Code(40_058)

    # Interaction has already been acknowledged
    InteractionAlreadyAcknowledged = Code(40_060)

    # Tag names must be unique
    TagNameMustBeUnique = Code(40_061)

    # Service resource is being rate limited
    ServiceResourceRateLimited = Code(40_062)

    # There are no tags available that can be set by non-moderators
    NoTagAvailableForNonModerator = Code(40_066)

    # A tag is required to create a forum post in this channel
    ForumPostCreateTagRequired = Code(40_067)

    # An entitlement has already been granted for this resource
    ResourceEntitlementAlreadyGranted = Code(40_074)

    # Cloudflare is blocking your request. This can often be resolved by setting a proper User Agent
    RequestBlockedByCloudflare = Code(40_333)

    # Missing Access
    MissingAccess = Code(50_001)

    # Invalid Account Type
    InvalidAccountType = Code(50_002)

    # Cannot execute action on a DM channel
    InvalidActionForDM = Code(50_003)

    # Server widget disabled
    ServerWidgetDisabled = Code(50_004)

    # Cannot edit a message authored by another user
    MessageAuthoredByOtherUser = Code(50_005)

    # Cannot send an empty message
    MessageEmpty = Code(50_006)

    # Cannot send messages to this user
    NoMessagesToUser = Code(50_007)

    # Cannot send messages in a voice channel
    NoMessagesInVoiceChannel = Code(50_008)

    # Channel verification level is too high
    VerificationLevelTooHigh = Code(50_009)

    # OAuth2 application does not have a bot
    NoBotForApplication = Code(50_010)

    # OAuth2 application limit reached
    ApplicationLimitReached = Code(50_011)

    # Invalid OAuth State
    InvalidOAuthState = Code(50_012)

    # You lack permissions to perform that action
    LackPermissions = Code(50_013)

    # Invalid authentication token
    InvalidAuthToken = Code(50_014)

    # Note is too long
    NoteTooLong = Code(50_015)

    # Provided too few or too many messages to delete. Must provide at least 2 and fewer than 100 messages to delete
    InvalidBulkDeleteCount = Code(50_016)

    # Invalid MFA Level
    InvalidMFALevel = Code(50_017)

    # A message can only be pinned to the channel it was sent in
    CannotPinInDifferentChannel = Code(50_019)

    # Invite code was either invalid or taken
    InvalidInviteCode = Code(50_020)

    # Cannot execute action on a system message
    InvalidActionForSystemMessage = Code(50_021)

    # Cannot execute action on this channel type
    CannotExecuteOnChannelType = Code(50_024)

    # Invalid OAuth2 access token provided
    InvalidOAuthAccessToken = Code(50_025)

    # Missing required OAuth2 scope
    MissingOAuthScope = Code(50_026)

    # Invalid webhook token provided
    InvalidWebhookToken = Code(50_027)

    # Invalid role
    InvalidRole = Code(50_028)

    # Invalid Recipient(s)
    InvalidRecipient = Code(50_033)

    # A message provided was too old to bulk delete
    MessageTooOld = Code(50_034)

    # Invalid form body (returned for both application/json and multipart/form-data bodies), or invalid Content-Type provided
    InvalidFormBody = Code(50_035)

    # An invite was accepted to a guild the application's bot is not in
    MissingBotMember = Code(50_036)

    # Invalid Activity Action
    InvalidActivityAction = Code(50_039)

    # Invalid API version provided
    InvalidAPIVersion = Code(50_041)

    # File uploaded exceeds the maximum size
    FileSizeUploadLimitReached = Code(50_045)

    # Invalid file uploaded
    InvalidFileUpload = Code(50_046)

    # Cannot self-redeem this gift
    CannotSelfRedeemGift = Code(50_054)

    # Invalid Server
    InvalidServer = Code(50_055)

    # Invalid SKU
    InvalidSKU = Code(50_057)

    # Invalid Request origin
    InvalidRequestOrigin = Code(50_067)

    # Invalid Message type
    InvalidMessageType = Code(50_068)

    # Payment source required to redeem gift
    PaymentSourceRequired = Code(50_070)

    # Cannot modify a system webhook
    CannotModifySystemWebhook = Code(50_073)

    # Cannot delete a channel required for Community guilds
    CannotDeleteCommunityServerChannelRequired = Code(50_074)

    # Cannot edit stickers within a message
    CannotEditMessageSticker = Code(50_080)

    # Invalid sticker sent
    InvalidStickerSent = Code(50_081)

    # Tried to perform an operation on an archived thread, such as editing a message or adding a user to the thread
    OperationOnArchivedThread = Code(50_083)

    # Invalid thread notification settings
    InvalidThreadNotificationSettings = Code(50_084)

    # before value is earlier than the thread creation date
    BeforeValueEarlierThanThread = Code(50_085)

    # Community server channels must be text channels
    CommunityServerChannelMustBeTextChannel = Code(50_086)

    # The entity type of the event is different from the entity you are trying to start the event for
    EntityTypeEventMismatch = Code(50_091)

    # This server is not available in your location
    ServerNotAvailableInYourLocation = Code(50_095)

    # This server needs monetization enabled in order to perform this action
    ServerNeedsMonetizationEnabled = Code(50_097)

    # This server needs more boosts to perform this action
    ServerNeedsMoreBoosts = Code(50_101)

    # The request body contains invalid JSON
    RequestBodyInvalidJSON = Code(50_109)

    # Owner cannot be pending member
    OwnerCannotBePendingMember = Code(50_131)

    # Ownership cannot be transferred to a bot user
    OwnershipCannotTransferedToBot = Code(50_132)

    # Failed to resize asset below the maximum size: 262144
    FailedResizeBelowAssetLimit = Code(50_138)

    # Cannot mix subscription and non subscription roles for an emoji
    EmojiCannotMixSubscriptionTypeRole = Code(50_144)

    # Cannot convert between premium emoji and normal emoji
    CannotConvertBetweenPremiumAndNormalEmoji = Code(50_145)

    # Uploaded file not found
    UploadedFileNotFound = Code(50_146)

    # Voice messages do not support additional content
    VoiceMessageAdditionalContentNotSupported = Code(50_159)

    # Voice messages must have a single audio attachment
    VoiceMessageMustHaveSingleAudio = Code(50_160)

    # Voice messages must have supporting metadata
    VoiceMessageMustSupportMetadata = Code(50_161)

    # Voice messages cannot be edited
    VoiceMessageCannotBeEdited = Code(50_162)

    # Cannot delete guild subscription integration
    ServerSubscriptionIntegrationCannotBeDeleted = Code(50_163)

    # You cannot send voice messages in this channel
    CannotSendVoiceMessage = Code(50_173)

    # The user account must first be verified
    UserAccountMustBeVerified = Code(50_178)

    # You do not have permission to send this sticker
    NeedPermissionToSendSticker = Code(50_600)

    # Two factor is required for this operation
    TwoFactorRequired = Code(60_003)

    # No users with DiscordTag exist
    UserDiscordTagNotExist = Code(80_004)

    # Reaction Blocked
    ReactionBlocked = Code(90_001)

    # User cannot use burst reactions
    UserCannotBurstReactions = Code(90_002)

    # Application not yet available. Try again later
    ApplicationNotYetAvailable = Code(110_001)

    # API resource is currently overloaded. Try again a little later
    APIResourceOverloaded = Code(130_000)

    # The Stage is already open
    StageAlreadyOpen = Code(150_006)

    # Cannot reply without permission to read message history
    CannotReplyWithoutReadMessageHistory = Code(160_002)

    # A thread has already been created for this message
    MessageThreadAlreadyCreated = Code(160_004)

    # Thread is locked
    ThreadLocked = Code(160_005)

    # Maximum number of active threads reached
    ActiveThreadLimitReached = Code(160_006)

    # Maximum number of active announcement threads reached
    ActiveAnnouncementThreadLimitReached = Code(160_007)

    # Invalid JSON for uploaded Lottie file
    LottieInvalidJSON = Code(170_001)

    # Uploaded Lotties cannot contain rasterized images such as PNG or JPEG
    LottieCannotContainRasterizedImages = Code(170_002)

    # Sticker maximum framerate exceeded
    StickerFramerateLimitReached = Code(170_003)

    # Sticker frame count exceeds maximum of 1000 frames
    StickerFrameLimitReached = Code(170_004)

    # Lottie animation maximum dimensions exceeded
    LottieDimensionLimitReached = Code(170_005)

    # Sticker frame rate is either too small or too large
    StickerFramerateInvalid = Code(170_006)

    # Sticker animation duration exceeds maximum of 5 seconds
    StickerDurationLimitReached = Code(170_007)

    # Cannot update a finished event
    CannotUpdateFinishedEvent = Code(180_000)

    # Failed to create stage needed for stage event
    StageCreateFailed = Code(180_002)

    # Message was blocked by automatic moderation
    MessageBlockedByAutoMod = Code(200_000)

    # Title was blocked by automatic moderation
    TitleBlockedByAutoMod = Code(200_001)

    # Webhooks posted to forum channels must have a thread_name or thread_id
    ForumWebhookPostMissingArgument = Code(220_001)

    # Webhooks posted to forum channels cannot have both a thread_name and thread_id
    ForumWebhookPostTooMuchArgument = Code(220_002)

    # Webhooks can only create threads in forum channels
    OnlyForumWebhookCanCreateThread = Code(220_003)

    # Webhook services cannot be used in forum channels
    ForumWebhookCannotUseService = Code(220_004)

    # Message blocked by harmful links filter
    MessageBlockedByHarmfulLinkFilter = Code(240_000)

    # Cannot enable onboarding, requirements are not met
    CannotEnableOnboarding = Code(350_000)

    # Cannot update onboarding while below requirements
    CannotUpdateOnboarding = Code(350_001)

    # Failed to ban users
    BanUserFailed = Code(500_000)

    # Poll voting blocked
    PollVotingBlocked = Code(520_000)

    # Poll expired
    PollExpired = Code(520_001)

    # Invalid channel type for poll creation
    PollInvalidTypeChannel = Code(520_002)

    # Cannot edit a poll message
    PollMessageCannotBeEdited = Code(520_003)

    # Cannot use an emoji included with the poll
    PollCannotUseEmojiIncluded = Code(520_004)

    # 520006 Cannot expire a non-poll message
    CannotExpireNonPollMessage = Code(520_006)
  end
end
