require "rails_helper"

RSpec.describe "FactoryBot" do
  it "Userのテストデータを作成できる" do
    user = create(:user)

    expect(user).to be_persisted
  end

  it "Categoryのテストデータを作成できる" do
    category = create(:category)

    expect(category).to be_persisted
  end

  it "Postのテストデータを関連データと一緒に作成できる" do
    post = create(:post)

    expect(post).to be_persisted
    expect(post.user).to be_persisted
    expect(post.category).to be_persisted
  end
end
