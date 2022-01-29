# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

5.times do
  u = User.create! email: Faker::Internet.email, password: 'asdfasdf', password_confirmation: 'asdfasdf', username: Faker::Lorem.unique.word
  10.times do
    r = Recipe.create user: u, title: Faker::Food.unique.dish, description: Faker::Food.description, time: rand(120), servings: rand(24)
    r.image.attach(io: File.open(File.join(Rails.root, 'app/assets/images/sample.jpeg')), filename: 'sample.jpeg')
    3.times do
      Ingredient.create!(recipe: r, body: Faker::Food.measurement + ' ' +Faker::Food.ingredient)
    end
    3.times do
      Instruction.create!(recipe: r, body: Faker::Quotes::Shakespeare.romeo_and_juliet_quote)
    end
  end

  5.times do
    c = Cookbook.create! title: Faker::Movie.unique.title, user: u, description: Faker::Movies::Lebowski.quote
    c.image.attach(io: File.open(File.join(Rails.root, 'app/assets/images/sample.jpeg')), filename: 'sample.jpeg')
    3.times do
      c.recipes << Recipe.find(rand(9)+1)
    end
  end
end

# u = User.first
# 3.times.with_index do |i|
#   c = Cookbook.last(i + 1).first
#   s = User.last(i + 1).first
#   Subscriptions.create! subscriber: u, subscribable: c
#   Subscriptions.create! subscriber: u, subscribable: s
# end

puts 'First User Email: ' + User.first.email
puts 'First User Password: asdfasdf'