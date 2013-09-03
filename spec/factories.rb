FactoryGirl.define do
  sequence(:random_string) {|n| rand(10**10).to_s }

  factory :user do
    name "John Doe"
    email { generate(:random_string) + "@example.com" }
    password "password"
    password_confirmation "password"
  end

  factory :league do
    name "League Name"
    association :commissioner, factory: :user
  end

  factory :draft_pick do
    league
    association :member, factory: :user
    order { rand(0..31) }
  end
end
