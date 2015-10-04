Fabricator(:user) do
  email { Faker::Internet.email }
  fullname { Faker::Name.name }
  password { 'password' }
end
