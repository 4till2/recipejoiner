class CreateCookbooksRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :cookbooks_recipes, id: false do |t|
      t.belongs_to :cookbook
      t.belongs_to :recipe
    end
  end
end
