[ "映画", "音楽", "旅行", "カフェ", "その他" ].each do |category_name|
  Category.find_or_create_by!(name: category_name)
end
