Fabricator(:user) do
  email { Faker::Internet.email }
  fullname { Faker::Name.name }
  password { 'password' }
  token { SecureRandom.urlsafe_base64 }
end
