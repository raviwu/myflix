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

  def update_position
    queue_owner = updated_queue_owner
    if queue_owner == current_user
      if position_input_invalid?
        access_deny
      else
        ActiveRecord::Base.transaction do
          update_position_params.each do |id, assign|
            QueueItem.find(id).update_attributes!(position: assign[:position])
          end
        end
        normalize_position(queue_owner.queue_items)
      end
    else
      access_deny
    end
    redirect_to my_queue_path
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

  def update_position_params
    #{queue_items: {1 => {position: 'value'}, 2 => {position: 'value'}}}
    params.require(:queue_items).permit!
  end

  def updated_queue_owner
    QueueItem.find(update_position_params.to_a.first.first).try(:user)
  end

  def position_input_invalid?
    input_positions = update_position_params.map { |id, assign| assign[:position] }

    duplicated_position?(input_positions) || non_integer_position?(input_positions)

  end

  def duplicated_position?(input_positions)
    input_positions.length != input_positions.uniq.length
  end

  def non_integer_position?(input_positions)
    input_positions.join =~ /\D/
  end

  def normalize_position(queue_items)
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

end
