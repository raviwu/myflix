class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join('_')

  belongs_to :category, -> { order('title') }
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(query)
    return [] if query.blank?
    where("lower(title) LIKE ?", "%#{query}%").order(created_at: :desc)
  end

  def avg_rating
    ratings = []
    reviews.each { |review| ratings << review.rating }
    ratings.empty? ? 0 : (ratings.compact.sum.to_f / ratings.compact.size).round(1)
  end

  def self.search(query, options={ })
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: "and"
        }
      }
    }

    if query.present? && options[:reviews]
      search_definition[:query][:multi_match][:fields] << "reviews.body"
    end

    if options[:rating_from] || options[:rating_to]
      search_definition[:filter] = {
        range: {
          avg_rating: {
            gte: options[:rating_from],
            lte: options[:rating_to]
          }
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(option={})
    as_json(
      only: [:title, :description],
      include: {
        reviews: { only: [:body] }
      },
      methods: :avg_rating
    )
  end
end
