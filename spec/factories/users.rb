FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }

    password              { "password" }
    password_confirmation { "password" }

    last_name      { "山田" }
    first_name       { "太郎" }
    last_name_kana { "やまだ" }
    first_name_kana  { "たろう" }

    department  { "営業部" }

    # 役割（enum）: general / helper / manager / admin がある想定
    role { :general }

    total_virtue_points { 0 }
    level              { 1 }
  end
end
