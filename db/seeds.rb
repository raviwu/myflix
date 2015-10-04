# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = %w(action drama comedy)

5.times { Fabricate(:user) }

categories.each {|category| Category.create(title: category)}

video = Video.create(title:'Die Hard',
             description:Faker::Lorem.paragraph,
             small_cover_url: '/video_images/die_hard_s.jpg',
             large_cover_url: '/video_images/die_hard_l.jpg')
video.categories << Category.find_by(title: 'action')
video = Video.create(title:'Se7en',
            description:Faker::Lorem.paragraph,
            small_cover_url: '/video_images/se7en_s.jpg',
            large_cover_url: '/video_images/se7en_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The God Father',
             description:Faker::Lorem.paragraph,
             small_cover_url: '/video_images/the_god_father_s.jpg',
             large_cover_url: '/video_images/the_god_father_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The Intern',
             description:Faker::Lorem.paragraph,
             small_cover_url: '/video_images/the_intern_s.jpg',
             large_cover_url: '/video_images/the_intern_l.jpg')
video.categories << Category.find_by(title: 'comedy')
video = Video.create(title:'The Matrix',
             description:Faker::Lorem.paragraph,
             small_cover_url: '/video_images/the_matrix_s.jpg',
             large_cover_url: '/video_images/the_matrix_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'Up',
             description:Faker::Lorem.paragraph,
             small_cover_url: '/video_images/up_s.jpg',
             large_cover_url: '/video_images/up_l.jpg')
video.categories << Category.find_by(title: 'comedy')
video = Video.create(title:'The Matrix',
             description:Faker::Lorem.paragraph,
             small_cover_url: '/video_images/the_matrix_s.jpg',
             large_cover_url: '/video_images/the_matrix_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'Se7en',
            description:Faker::Lorem.paragraph,
            small_cover_url: '/video_images/se7en_s.jpg',
            large_cover_url: '/video_images/se7en_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The God Father',
             description:Faker::Lorem.paragraph,
             small_cover_url: '/video_images/the_god_father_s.jpg',
             large_cover_url: '/video_images/the_god_father_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'Se7en',
            description: Faker::Lorem.paragraph,
            small_cover_url: '/video_images/se7en_s.jpg',
            large_cover_url: '/video_images/se7en_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The God Father',
             description: Faker::Lorem.paragraph,
             small_cover_url: '/video_images/the_god_father_s.jpg',
             large_cover_url: '/video_images/the_god_father_l.jpg')
video.categories << Category.find_by(title: 'drama')

User.all.each do |user|
  Video.all.each {|video| Fabricate(:review, creator: user, video: video)}  
end
