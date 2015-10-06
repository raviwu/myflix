Fabricator(:queue_item) do
  user { Fabricate(:user) }
  video { Fabricate(:video) }
  position { [1, 2, 3].sample }
end
