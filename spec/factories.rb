FactoryGirl.define do
  sequence(:random_string) {|n| rand(10**10).to_s }

  factory :user do
    name "John Doe"
    email { generate(:random_string) + "@example.com" }
    password "password"
    password_confirmation "password"
  end
end
