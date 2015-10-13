require 'spec_helper'

feature "User interact with the queue" do
  scenario "user adds and reorder the queue" do
    drama = Fabricate(:category)
    up = Fabricate(:video, title: 'Up')
    die_hard = Fabricate(:video, title: 'Die Hard')
    monk = Fabricate(:video, title: 'Monk')
    Video.all.each { |v| v.categories << drama }

    sign_in

    add_video_to_my_queue(up)
    add_video_to_my_queue(die_hard)
    add_video_to_my_queue(monk)

    expect_video_be_in_queue(up)
    check_if_add_queue_button_is_disabled(up)

    visit my_queue_path
    set_video_order_in_my_queue(up, 3)
    set_video_order_in_my_queue(die_hard, 1)
    set_video_order_in_my_queue(monk, 2)

    update_queue

    check_video_order_in_my_queue(up, 3)
    check_video_order_in_my_queue(die_hard, 1)
    check_video_order_in_my_queue(monk, 2)

  end

  def add_video_to_my_queue(video)
    visit home_path
    click_link(video.title)
    click_link('+ My Queue')
  end

  def expect_video_be_in_queue(video)
    visit my_queue_path
    page.should have_content "My Queue"
    page.should have_content video.title
  end

  def check_if_add_queue_button_is_disabled(video)
    click_link(video.title)
    page.should have_content video.title
    page.should have_css("a.disabled")
  end

  def set_video_order_in_my_queue(video, order)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items_id_position", with: order
    end
  end

  def update_queue
    click_button('Update Instant Queue')
  end

  def check_video_order_in_my_queue(video, order)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(order.to_s)
  end

  scenario "with invalid user" do
    visit videos_path
    page.should have_content 'Sign in'
  end
end
