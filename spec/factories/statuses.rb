FactoryBot.define do
  factory :status do
    association :user
    status_date        { Date.current }
    status_type { :peaceful }       # enum の値に合わせて調整
    memo        { "テスト用ステータス" } # カラムに合わせて適宜
  end
end
