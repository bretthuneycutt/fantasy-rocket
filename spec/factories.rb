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

    factory :subscribed_user do
      stripe_id { generate(:random_string) }
      subscription
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

  factory :draft_pick, aliases: [:nfl_draft_pick] do
    league
    association :member, factory: :user
    order { rand(0..31) }
  end

  factory :nba_draft_pick, class: DraftPick do
    association :league, factory: :nba_league
    association :member, factory: :user
    order { rand(0..31) }
  end

  factory :nfl_regular_season_game, aliases: [:regular_season_game], class: NFLRegularSeasonGame do
    sequence(:winner_id) { |n| n }
    week 1
  end

  factory :nba_regular_season_game, class: NBARegularSeasonGame do
    sequence(:winner_id) { |n| n }
    week 1
  end

  factory :subscription do
    user

    factory :canceled_subscription do
      canceled_at { 1.month.ago }
    end
  end

  factory :league_membership do
    league
    association :member, factory: :user
  end
end
