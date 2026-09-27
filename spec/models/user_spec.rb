require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    context "入力内容が正しい場合" do
      it "ユーザーが有効であること" do
        user = build(:user)

        expect(user).to be_valid
      end
    end

    context "nameが未入力の場合" do
      it "ユーザーが無効であること" do
        user = build(:user, name: nil)

        expect(user).not_to be_valid
      end
    end

    context "emailが未入力の場合" do
      it "ユーザーが無効であること" do
        user = build(:user, email: nil)

        expect(user).not_to be_valid
      end
    end

    context "emailの形式が不正な場合" do
      it "ユーザーが無効であること" do
        user = build(:user, email: "invalid-email")

        expect(user).not_to be_valid
      end
    end

    context "emailが重複している場合" do
      it "ユーザーが無効であること" do
        existing_user = create(:user)
        user = build(:user, email: existing_user.email)

        expect(user).not_to be_valid
      end
    end

    context "passwordが未入力の場合" do
      it "ユーザーが無効であること" do
        user = build(:user, password: nil, password_confirmation: nil)

        expect(user).not_to be_valid
      end
    end

    context "passwordが6文字未満の場合" do
      it "ユーザーが無効であること" do
        user = build(
          :user,
          password: "12345",
          password_confirmation: "12345"
        )

        expect(user).not_to be_valid
      end
    end
  end

  describe "Postとの関連付け" do
    it "複数のPostを持つことができる" do
      user = create(:user)
      post1 = create(:post, user: user)
      post2 = create(:post, user: user)

      expect(user.posts).to contain_exactly(post1, post2)
    end
  end
end
