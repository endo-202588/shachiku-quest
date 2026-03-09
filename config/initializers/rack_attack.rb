class Rack::Attack
  Rack::Attack.cache.store = Rails.cache

  throttle("logins/ip_email", limit: 5, period: 60.seconds) do |req|
    if req.post? && req.path == "/login"
      email = req.params["email"]&.downcase&.strip || ""
      "#{req.ip}:#{email}"
    end
  end

  self.throttled_responder = lambda do |req|
    req.env["rack.session"][:throttled] = true

    [
      302,
      { "Location" => "/login" },
      []
    ]
  end
end
