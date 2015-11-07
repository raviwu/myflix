class VideosController < AuthenticatedController

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @review = Review.new
  end

  def search
    @query = params[:query]
    @results = Video.search_by_title(@query)
  end

  def create_review
    @video = Video.find(params[:id])
    @review = Review.new(review_params)
    @review.creator = current_user
    @review.video = @video
    if @review.save
      flash[:success] = "Just added a review!"
      redirect_to video_path(@video)
    else
      render :show
    end
  end

  def advanced_search
    @query ||= params[:query]

    options = {
      reviews: params[:reviews],
      rating_from: (params[:rating_from] if params[:rating_from].present?),
      rating_to: (params[:rating_to] if params[:rating_to].present?)
    }

    @videos = @query ? Video.search(@query, options).records.to_a : []
  end

  private

  def review_params
    params.require(:review).permit(:body, :rating)
  end
end
