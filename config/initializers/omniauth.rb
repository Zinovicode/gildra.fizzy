Rails.application.config.middleware.use OmniAuth::Builder do
  google_opts = {
    scope: "email,profile",
    prompt: "select_account"
  }
  google_opts[:hd] = ENV["GOOGLE_HD"] if ENV["GOOGLE_HD"].present?

  provider :google_oauth2,
    ENV["GOOGLE_CLIENT_ID"],
    ENV["GOOGLE_CLIENT_SECRET"],
    google_opts
end

OmniAuth.config.allowed_request_methods = [ :post ]
