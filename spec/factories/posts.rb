FactoryBot.define do
  factory :post do
    association :user
    association :category

    sequence(:title) { |n| "テスト投稿#{n}" }
    body { "これはテスト用の投稿です。" }
    favorite_rating { 5 }
    emotion { :happy }
  end
end
