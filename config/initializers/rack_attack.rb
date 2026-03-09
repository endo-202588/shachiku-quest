class Rack::Attack
  Rack::Attack.cache.store = Rails.cache

  throttle("logins/ip_email", limit: 5, period: 60.seconds) do |req|
    if req.post? && req.path.start_with?("/login")
      email = req.params["email"]&.downcase&.strip || ""
      ip = req.get_header("HTTP_X_FORWARDED_FOR")&.split(",")&.first || req.ip
      "#{ip}:#{email}"
    end
  end
end
