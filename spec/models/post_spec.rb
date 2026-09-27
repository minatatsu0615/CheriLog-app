require "rails_helper"

RSpec.describe Post, type: :model do
  describe "バリデーション" do
    context "入力内容が正しい場合" do
      it "投稿が有効であること" do
        post = build(:post)

        expect(post).to be_valid
      end
    end

    context "favorite_ratingが0の場合" do
      it "投稿が無効であること" do
        post = build(:post, favorite_rating: 0)

        expect(post).not_to be_valid
      end
    end

    context "favorite_ratingが6の場合" do
      it "投稿が無効であること" do
        post = build(:post, favorite_rating: 6)

        expect(post).not_to be_valid
      end
    end

    context "favorite_ratingが未入力の場合" do
      it "投稿が有効であること" do
        post = build(:post, favorite_rating: nil)

        expect(post).to be_valid
      end
    end
  end

  describe "Userとの関連付け" do
    it "Userに紐づいていること" do
      user = create(:user)
      post = create(:post, user: user)

      expect(post.user).to eq(user)
    end
  end

  describe "Categoryとの関連付け" do
    it "Categoryに紐づいていること" do
      category = create(:category)
      post = create(:post, category: category)

      expect(post.category).to eq(category)
    end
  end
end
