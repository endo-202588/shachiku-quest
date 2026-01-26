# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")

# cronを実行する環境変数周りの設定
ENV.each { |k, v| env(k, v) }

# cronを実行する環境変数(:developmentを初期値とする)
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronの標準出力先
set :output, "#{Rails.root}/log/cron.log"

# 動作確認用: 1分ごとに実行
# every 1.minute do
#   rake "help_requests:reset_yesterday_matched"
# end

# 本番用: 毎日午前0時に実行（動作確認後にコメントを切り替え）
every 1.day, at: "12:00 am" do
  rake "help_requests:reset_yesterday_matched"
end
