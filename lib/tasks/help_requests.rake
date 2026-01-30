namespace :help_requests do
  desc "昨日マッチングした助け合いリクエストをリセットする"
  task reset_yesterday_matched: :environment do
    # HelpRequestモデルのクラスメソッドを呼び出す
    HelpRequest.reset_yesterday_matched_all!

    # ログに出力
    Rails.logger.info "昨日マッチングした助け合いリクエストをリセットしました"
    puts "[#{Time.current}] 昨日マッチングした助け合いリクエストと魔法をリセットしました"
  end
end
