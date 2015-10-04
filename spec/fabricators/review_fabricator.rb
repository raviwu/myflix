Fabricator(:review) do
  body { Faker::Lorem.paragraph }
  rating { rand(1..5) }
end
