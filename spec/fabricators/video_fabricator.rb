Fabricator(:video) do
  title { Faker::Book.title }
  description { Faker::Lorem.paragraph }
end
