json.extract! product, :id, :name, :description, :category, :state, :condition, :price, :post_date, :created_at, :updated_at
json.url product_url(product, format: :json)
