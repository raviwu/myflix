# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = %w(action drama comedy)

categories.each do |category|
  Category.create(title: category)
end

User.create(fullname: 'Ravi Wu', email: 'raviwu@gmail.com', password: 'password', admin: true)

User.create(fullname: 'Ravi Wu', email: 'raviwu@example.com', password: ENV["SIDEKIQ_PASSWORD"])
