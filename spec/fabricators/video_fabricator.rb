Fabricator(:video) do
  title { Faker::Book.title }
  description { Faker::Lorem.paragraph }
  category { Fabricate(:category) }
end
