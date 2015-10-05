class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:id])
    @queue_item = QueueItem.new(user: current_user, video: video)

    if queued?(video)
      flash[:danger] = "You've already have #{video.title} in your queue."
      redirect_to video_path(video)
    else
      @queue_item.position = new_queue_item_position
      @queue_item.save
      flash[:success] = "Added #{video.title} to your queue!"
      redirect_to my_queue_path
    end

  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if queue_item.user == current_user
      queue_item.destroy
      redirect_to my_queue_path
    else
      access_deny
      redirect_to root_path
    end
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def queued?(video)
    QueueItem.where(user: current_user, video: video).count > 0
  end
end
