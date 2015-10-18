require 'spec_helper'

feature "User follow and unfollow another user" do
  given(:joe) { Fabricate(:user) }
  given(:mark) { Fabricate(:user) }
  given(:up) { Fabricate(:video) }
  given(:comedy) { Fabricate(:category) }

  background do
    up.categories << comedy
    Fabricate(:review, creator: mark, video: up)
  end

  scenario "user follow and unfollow another user" do
    sign_in(joe)

    visit_video_page_from_home_page(up)

    visit_user_page_from_video_page_and_follow(mark)

    check_followships_and_flash_after_follow(joe, mark)

    check_follow_link_being_disabled(mark)

    remove_followship_from_followships_list(mark)

    check_unfollow_status(joe, mark)
  end

  def visit_video_page_from_home_page(video)
    click_video_on_home_path(video)
    page.should have_content video.title
  end

  def visit_user_page_from_video_page_and_follow(followee)
    click_link(followee.fullname)
    click_link('Follow')
  end

  def check_followships_and_flash_after_follow(follower, followee)
    expect(follower.followed?(followee)).to be_truthy
    page.should have_content "Successfully follow #{followee.fullname}"
  end

  def check_follow_link_being_disabled(followee)
    visit user_path(followee)
    page.should have_css("a.disabled")
  end

  def remove_followship_from_followships_list(followee)
    visit people_path
    within(:xpath, "//tr[contains(.,\"#{followee.fullname}\")]") do
      find("a[data-method='delete']").click
    end
  end

  def check_unfollow_status(follower, followee)
    expect(follower.followed?(followee)).to be_falsey
    page.should have_content "Successfully unfollow #{followee.fullname}."
  end

end
