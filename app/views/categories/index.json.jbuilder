json.(@categories) do |json, category|
	json.(category, :id, :name)
end