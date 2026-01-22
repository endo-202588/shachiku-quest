module StatusesHelper
  def status_date_label(status)
    if status.status_date == Date.today
      "⚔️ 今日の状態"
    else
      "⚔️ #{status.status_date.strftime('%Y年%m月%d日')}のステータス"
    end
  end
end
