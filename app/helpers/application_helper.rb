module ApplicationHelper
  def options_for_video_rating(selected = nil)
    options_for_select((1..5).map { |num| [pluralize(num, "Star"), num]}, selected)
  end

  def options_for_categories_select(selected = nil)
    options_for_select(Category.all.map { |category| [category.title.capitalize, category.id] }, selected)
  end
end
