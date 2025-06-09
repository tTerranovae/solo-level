Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, "Ov23livjEmTV22WQcoV2", "18b09f64ab8f0972669c792a988a0da0c86f75cb", scope: "user:email"
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end

OmniAuth.config.allowed_request_methods = [ :post, :get ]
