FactoryBot.define do
  factory :post do
    association :user
    association :category

    sequence(:title) { |n| "テスト投稿#{n}" }
    body { "これはテスト用の投稿です。" }
    favorite_rating { 5 }
    emotion { :happy }

    after(:build) do |post|
      post.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test_image.png")),
        filename: "test_image.png",
        content_type: "image/png"
      )
    end
  end
end
