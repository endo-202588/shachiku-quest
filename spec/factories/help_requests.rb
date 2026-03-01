# spec/factories/help_requests.rb
FactoryBot.define do
  factory :help_request do
    association :task
    status { :open }
    matched_on { nil }
    completed_notified_at { nil }
    helper { nil }

    trait :matched do
      association :helper, factory: :user
      status { :matched }
      matched_on { Date.current }
    end

    trait :completed do
      status { :completed }
    end
  end
end
