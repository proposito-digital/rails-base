FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "123" }
    password_confirmation { "123" }
  end
end
