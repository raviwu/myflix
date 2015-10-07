class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:id])
    @queue_item = QueueItem.new(user: current_user, video: video)

    if current_user.queued?(video)
      flash[:danger] = "You've already have #{video.title} in your queue."
      redirect_to video_path(video)
    else
      @queue_item.update(position: new_queue_item_position)
      flash[:success] = "Added #{video.title} to your queue!"
      redirect_to my_queue_path
    end

  end

  def update_position
    queue_owner = updated_queue_owner
    if queue_owner == current_user && position_input_valid?
      ActiveRecord::Base.transaction do
        params[:queue_items].each do |id, assign|
          QueueItem.find(id).update_attributes!(position: assign[:position], rating: assign[:rating])
        end
        queue_owner.normalize_queue_items_position
      end

    else
      access_deny
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_owner = queue_item.user
    if queue_owner == current_user
      queue_item.destroy
      queue_owner.normalize_queue_items_position
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

  def updated_queue_owner
    QueueItem.find(params[:queue_items].to_a.first.first).try(:user)
  end

  def position_input_invalid?
    #{queue_items: {1 => {position: 'value', rating: '1'}, 2 => {position: 'value', rating: ''}}}
    input_positions = params[:queue_items].map { |id, assign| assign[:position] }

    duplicated_position?(input_positions) || non_integer_position?(input_positions)

  end

  def position_input_valid?
    !position_input_invalid?
  end

  def duplicated_position?(input_positions)
    input_positions.length != input_positions.uniq.length
  end

  def non_integer_position?(input_positions)
    input_positions.join =~ /\D/
  end

end
