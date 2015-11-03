Fabricator(:user) do
  email { Faker::Internet.email }
  fullname { Faker::Name.name }
  password { 'password' }
  admin false
  active true
end

Fabricator(:admin, from: :user) do
  admin true
end
