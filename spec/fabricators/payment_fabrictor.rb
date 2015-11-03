Fabricator(:payment) do
  user { Fabricate(:user) }
  amount { 999 }
  reference_id { SecureRandom.urlsafe_base64 }
end
