OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = UsersController.action(:oauth_failure)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], scope: "email, publish_stream"
end
