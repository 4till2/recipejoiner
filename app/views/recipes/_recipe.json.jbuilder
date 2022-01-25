json.extract! recipe, :id, :user_id, :title, :description, :time, :servings, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)
