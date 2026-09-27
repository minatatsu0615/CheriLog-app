class SeedDefaultCategories < ActiveRecord::Migration[8.1]
  def up
    [ "映画", "音楽", "旅行", "カフェ", "その他" ].each do |category_name|
      Category.find_or_create_by!(name: category_name)
    end
  end

  def down
    Category.where(name: [ "映画", "音楽", "旅行", "カフェ", "その他" ]).delete_all
  end
end
