Fabricator(:video) do
  # title formatted as "Video Random Faker" for better test conditioning
  title { "Video #{Faker::Book.title}" }
  description { Faker::Lorem.paragraph }
end
