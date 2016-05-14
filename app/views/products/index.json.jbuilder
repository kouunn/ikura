json.array!(@products) do |product|
  json.extract! product, :id, :name_cn, :name_jp, :price, :introduction, :pic_url
  json.url product_url(product, format: :json)
end
