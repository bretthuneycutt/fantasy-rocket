FactoryGirl.define do
  # Model.build(:model, :id) to get fake ID
  trait :id do
    id { rand(1000000) }
  end

  sequence(:random_string) {|n| rand(10**10).to_s }

  factory :user do
    name { "John Doe #{generate(:random_string)}" }
    email { generate(:random_string) + "@example.com" }
    password "password"
    password_confirmation "password"

    factory :user_with_password_reset_token do
      before(:create) { |u| u.generate_token(:password_reset_token) }
      password_reset_sent_at { Time.now }
    end
  end

  factory :league, aliases: [:nfl_league] do
    name "League Name"
    association :commissioner, factory: :user
    sport 'nfl'
  end

  factory :nba_league, class: League do
    name "League Name"
    association :commissioner, factory: :user
    sport 'nba'
  end

  factory :draft_pick do
    league
    association :member, factory: :user
    order { rand(0..31) }
  end

  factory :regular_season_game do
    sequence(:winner_id) { |n| n }
    week 1
  end
end
