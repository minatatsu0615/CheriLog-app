require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "POST /posts" do
    context "ログインしている場合" do
      it "投稿を作成できること" do
        user = create(:user)
        category = create(:category)
        sign_in user

        post_params = {
          post: {
            title: "テスト投稿",
            category_id: category.id,
            body: "テスト投稿の本文です。",
            favorite_rating: 5,
            emotion: "happy"
          }
        }

        expect do
          post posts_path, params: post_params
        end.to change(Post, :count).by(1)

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /posts" do
    context "ログインしている場合" do
      it "自分の投稿が一覧に表示されること" do
        user = create(:user)
        create(:post, user: user, title: "自分のテスト投稿")
        sign_in user

        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("自分のテスト投稿")
      end

      it "他のユーザーの投稿が一覧に表示されないこと" do
        user = create(:user)
        other_user = create(:user)

        create(:post, user: user, title: "自分の投稿")
        create(:post, user: other_user, title: "他のユーザーの投稿")

        sign_in user

        get posts_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("自分の投稿")
        expect(response.body).not_to include("他のユーザーの投稿")
      end
    end
  end

  describe "GET /posts/:id" do
    context "ログインしている場合" do
      it "自分の投稿詳細が表示されること" do
        user = create(:user)
        category = create(:category, name: "映画")
        post_record = create(
          :post,
          user: user,
          category: category,
          title: "映画の思い出",
          body: "とても楽しかったです。"
        )

        sign_in user

        get post_path(post_record)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("映画の思い出")
        expect(response.body).to include("とても楽しかったです。")
        expect(response.body).to include("映画")
      end
    end
  end

  describe "PATCH /posts/:id" do
    context "ログインしている場合" do
      it "自分の投稿を編集できること" do
        user = create(:user)
        post_record = create(
          :post,
          user: user,
          title: "編集前のタイトル",
          body: "編集前の本文"
        )

        sign_in user

        patch post_path(post_record), params: {
          post: {
            title: "編集後のタイトル",
            body: "編集後の本文"
          }
        }

        post_record.reload

        expect(post_record.title).to eq("編集後のタイトル")
        expect(post_record.body).to eq("編集後の本文")
        expect(response).to redirect_to(post_path(post_record))
      end
    end
  end

  describe "DELETE /posts/:id" do
    context "ログインしている場合" do
      it "自分の投稿を削除できること" do
        user = create(:user)
        post_record = create(:post, user: user)
        sign_in user

        expect do
          delete post_path(post_record)
        end.to change(Post, :count).by(-1)

        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe "投稿の主要な操作フロー" do
    it "投稿作成から一覧・詳細・編集・削除まで正常に操作できること" do
      user = create(:user)
      category = create(:category, name: "カフェ")
      sign_in user

      # 投稿を作成する
      expect do
        post posts_path, params: {
          post: {
            title: "カフェの思い出",
            category_id: category.id,
            body: "お気に入りのカフェに行きました。",
            favorite_rating: 5,
            emotion: "happy"
          }
        }
      end.to change(Post, :count).by(1)

      post_record = user.posts.order(:created_at).last

      # 投稿一覧に作成した投稿が表示される
      get posts_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("カフェの思い出")

      # 投稿詳細に作成した内容が表示される
      get post_path(post_record)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("カフェの思い出")
      expect(response.body).to include("お気に入りのカフェに行きました。")

      # 投稿を編集する
      patch post_path(post_record), params: {
        post: {
          title: "編集後のカフェの思い出",
          body: "また行きたいカフェでした。"
        }
      }

      post_record.reload

      expect(post_record.title).to eq("編集後のカフェの思い出")
      expect(post_record.body).to eq("また行きたいカフェでした。")
      expect(response).to redirect_to(post_path(post_record))

      # 投稿を削除する
      expect do
        delete post_path(post_record)
      end.to change(Post, :count).by(-1)

      expect(response).to redirect_to(posts_path)
    end
  end
end
