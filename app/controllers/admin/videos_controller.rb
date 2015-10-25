class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    category = Category.find(params[:video][:categories]) if params[:video][:categories]
    @video.categories << category
    if @video.save
      flash[:success] = "You've added video #{@video.title}."
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Failed to create video. Please fix the problem."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :large_cover, :small_cover, :video_url)
  end
end
