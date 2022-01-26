# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

u = User.create! email: 'test@mail.com', password: 'asdfasdf', password_confirmation: 'asdfasdf', username: 'yosef'
10.times do
  r = Recipe.create user: u, title: Faker::Food.dish, description: Faker::Food.description, time: rand(120), servings: rand(24)
  3.times do
    Ingredient.create!(recipe: r, body: Faker::Food.measurement + ' ' +Faker::Food.ingredient)
  end
  3.times do
    Instruction.create!(recipe: r, body: Faker::Quotes::Shakespeare.romeo_and_juliet_quote)
  end
end

5.times do
  c = Cookbook.create! title: Faker::Movie.title, user: u, description: Faker::Movie.quote
  3.times do
    c.recipes << Recipe.find(rand(9)+1)
  end
end