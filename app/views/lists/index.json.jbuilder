json.(@lists) do |json, list|
  json.(list, :id, :title, :user_id, :name, :nickname, :avatar_url, :category_id, :created_at)
end