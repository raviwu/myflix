Fabricator(:followship) do
  follower { Fabricate(:user) }
  followee { Fabricate(:user) }
end
