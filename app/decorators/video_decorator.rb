class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.avg_rating == 0 ? "N/A" : "#{object.avg_rating} / 5.0"
  end
end
