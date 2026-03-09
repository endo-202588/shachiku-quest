class Rack::Attack
  Rails.logger.info "Rack::Attack loaded"

  Rack::Attack.cache.store = Rails.cache

  throttle("logins/ip_email", limit: 5, period: 60.seconds) do |req|
    Rails.logger.info "RackAttack DEBUG path=#{req.path} method=#{req.request_method} ip=#{req.ip}"

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
