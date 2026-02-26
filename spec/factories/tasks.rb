FactoryBot.define do
  factory :task do
    association :user
    title        { "タスクタイトル" }
    status        { :in_progress } # カラムに合わせて適宜
  end
end
