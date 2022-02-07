# PRODUCTION SEED

REMOTE_RECIPES = false
REMOTE_COUNT = 20

@u = User.find_by email: "yosefserkez@gmail.com"
@u ||= User.create! email: "yosefserkez@gmail.com", password: 'SpoonMeJoy!', password_confirmation: 'SpoonMeJoy!', username: 'spoonjoy', full_name: 'Spoon Joy Official'

# Read Recipes from Seed File
def get_recipes
  `bin/rails runner script/read_seed_recipes.rb`
end

# Generate New Recipes and Append to seed file, following seed be sure to fix seed file by replacing ']}{"data":[' with ','
def new_recipe(title)
  `bin/rails runner script/write_seed_recipes.rb #{title.gsub(' ', '%20')}`
end

def generate_new_recipes(amount)
  amount.times do
    title = Faker::Food.unique.dish
    result = new_recipe(title)
    build_recipe_from_json(result)
  end
end

def build_cached_recipes
  build_recipe_from_json(get_recipes)
end

def build_recipe_from_json(json)
  total = 0
  recipes = JSON.parse(json)['data']
  recipes.each_with_index do |recipe, index|
    recipe_name = recipe['name']
    recipe_ingredients = recipe['ingredients']
    recipe_instructions = recipe['instructions']
    recipe_servings = recipe['servings']
    recipe_image = recipe['image']
    recipe_time = recipe['time']['total']

    r = Recipe.create user: @u, title: recipe_name, description: '', time: recipe_time, servings: recipe_servings, remote_image: recipe_image
    recipe_ingredients.each do |ingredient|
      Ingredient.create!(recipe: r, body: ingredient)
    end
    recipe_instructions.each do |instruction|
      Instruction.create!(recipe: r, body: instruction)
    end
    total += 1
    puts "#{index}. Recipe id of [#{r.id}] is ready as #{recipe_name}"
  end
  puts "TOTAL: #{total}"
end

REMOTE_RECIPES ? generate_new_recipes(REMOTE_COUNT) : build_cached_recipes

# DEVELOPMENT SEED
# 5.times do
#   @u = User.create! email: Faker::Internet.email, password: 'asdfasdf', password_confirmation: 'asdfasdf', username: Faker::Movies::Lebowski.unique.actor.truncate(12, omission: '').gsub(' ','_').underscore, full_name: Faker::Movies::Lebowski.unique.character
#   20.times do
#     r = Recipe.create user: @u, title: Faker::Food.dish, description: Faker::Food.description, time: rand(120), servings: rand(24)
#     # rand(5).positive? ? r.image.attach(io: File.open(File.join(Rails.root, 'app/assets/images/sample.jpeg')), filename: 'sample.jpeg') : nil
#     10.times do
#       Ingredient.create!(recipe: r, body: Faker::Food.measurement + ' ' + Faker::Food.ingredient)
#     end
#     7.times do
#       Instruction.create!(recipe: r, body: Faker::Quotes::Shakespeare.romeo_and_juliet_quote)
#     end
#   end
#
#   20.times do
#     c = Cookbook.create! title: Faker::Movie.title, user: @u, description: Faker::Movies::Lebowski.quote
#     # rand(2).positive? ? c.image.attach(io: File.open(File.join(Rails.root, 'app/assets/images/sample.jpeg')), filename: 'sample.jpeg') : nil
#     10.times do
#       c.recipes << Recipe.find(rand(10)+1)
#     end
#   end
# end
#
# @u = User.first
# 3.times.with_index do |i|
#   c = Cookbook.last(i + 1).first
#   s = User.last(i + 1).first
#   Subscriptions.create! subscriber: @u, subscribable: c
#   Subscriptions.create! subscriber: @u, subscribable: s
# end
#
# puts 'First User Email: ' + User.first.email
# puts 'First User Password: asdfasdf'