class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle("logins/ip_email", limit: 5, period: 60.seconds) do |req|
    if req.post? && req.path.start_with?("/login")
      email = req.params["email"]&.downcase&.strip || ""
      "#{req.ip}:#{email}"
    end
  end

  self.throttled_responder = lambda do |req|
    if req.env["rack.session"]
      req.env["rack.session"][:throttled] = true
    end

    [
      302,
      { "Location" => "/login" },
      []
    ]
  end
end
