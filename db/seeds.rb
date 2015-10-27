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

video_titles = %w(die_hard se7en the_god_father the_intern the_matrix up)

video_titles.each do |video_title|
  Video.create(title: video_title.split('_').join(' ').capitalize, description: Faker::Lorem.paragraphs.join(' '),large_cover: "#{video_title}_l.jpg", small_cover: "#{video_title}_s.jpg", category: Category.all.sample)
end

5.times { Fabricate(:user) }

Video.all.each do |video|
  User.all.each do |user|
    Review.create(creator: user, video: video, body: Faker::Lorem.paragraph(2), rating: [1,2,3,4,5].sample)
  end
end
