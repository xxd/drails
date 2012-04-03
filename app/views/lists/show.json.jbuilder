json.(@list, :id, :title, :user_id, :name, :nickname, :avatar_url, :category_id, :created_at)
json.items(@list.items) do |json, item|
  json.(item, :id, :content, :user_id, :name, :nickname, :avatar_url, :list_id, :created_at)
end