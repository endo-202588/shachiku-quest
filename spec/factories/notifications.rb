FactoryBot.define do
  factory :notification do
    association :help_request
    association :recipient, factory: :user
    association :sender, factory: :user

    message_type { :matched }
    body { "テスト通知" }
  end
end
