class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :original, foreign_key: { to_table: :recipes }
      t.string :title
      t.text :description
      t.integer :time
      t.integer :servings

      t.timestamps
    end
  end
end
