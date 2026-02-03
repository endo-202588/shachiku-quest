namespace :help_requests do
  desc "日次リセット（HelpRequest/HelpMagic）を実行する"
  task reset_yesterday_matched: :environment do
    ran = ::DailyResetService.call

    if ran
      Rails.logger.info "DailyResetService: 日次リセットを実行しました"
      puts "[#{Time.current}] DailyResetService: 日次リセットを実行しました"
    else
      Rails.logger.info "DailyResetService: 今日はすでに実行済みのためスキップしました"
      puts "[#{Time.current}] DailyResetService: 今日は実行済みのためスキップしました"
    end
  end
end
