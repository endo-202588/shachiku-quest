class DailyResetService
  KEY = "last_daily_reset_on"

  def self.call(now: Time.zone.now)
    today = now.to_date

    setting = AppSetting.find_or_create_by!(key: KEY) do |s|
      s.value = "1970-01-01"
    end

    setting.with_lock do
      last = Date.parse(setting.value) rescue Date.new(1970, 1, 1)
      return false if last >= today

      HelpRequest.reset_yesterday_matched_all!(now: now)

      setting.update!(value: today.to_s)
      true
    end
  end
end
