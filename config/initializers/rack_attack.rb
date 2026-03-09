class Rack::Attack
  Rails.logger.info "Rack::Attack loaded"

  Rack::Attack.cache.store = Rails.cache

  throttle("logins/ip_email", limit: 5, period: 60.seconds) do |req|
    real_ip = req.env["HTTP_X_FORWARDED_FOR"]&.split(",")&.first || req.ip

    Rails.logger.info "RackAttack DEBUG ip=#{real_ip} path=#{req.path}"

    if req.post? && req.path == "/login"
      email = req.params["email"]&.downcase&.strip || ""
      "#{real_ip}:#{email}"
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
