require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, options: {
    args: %w[
      headless
      disable-gpu
      no-sandbox
      disable-dev-shm-usage
      window-size=1400,1400
    ]
  }
end