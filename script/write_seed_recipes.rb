#!/usr/bin/ruby

q = ARGV[0]
require 'uri'
require 'net/http'
require 'openssl'
require 'json'

url = URI("https://recipesapi2.p.rapidapi.com/recipes/#{q}?maxRecipes=9")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["x-rapidapi-host"] = 'recipesapi2.p.rapidapi.com'
request["x-rapidapi-key"] = '4c6843813cmsh6743e529a358bb7p115fc4jsnf2d8db89726f'

response = http.request(request)
File.write("public/recipes.json", JSON.generate(JSON.parse(response&.body)), File.size("public/recipes.json"), mode: 'a')

puts response.read_body

