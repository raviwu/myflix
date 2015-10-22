Fabricator(:invitation) do
  invitor { Fabricate(:user) }
  recipient_email { Faker::Internet.email }
  recipient_fullname { Faker::Name.name }
  message { Faker::Lorem.paragraph }
  token { SecureRandom.urlsafe_base64 }
end
