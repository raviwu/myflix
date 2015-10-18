require 'spec_helper'

feature "User follow and unfollow another user" do
  given(:joe) { Fabricate(:user) }
  given(:mark) { Fabricate(:user) }

  scenario "user follow and unfollow another user" do
    sign_in(joe)

    visit_user_page_and_follow(mark)

    check_followships_and_flash_after_follow(joe, mark)

    check_follow_link_being_disabled(mark)

    remove_followship_from_followships_list(mark)

    check_unfollow_status(joe, mark)
  end

  def visit_user_page_and_follow(followee)
    visit user_path(followee)
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
    visit followships_path
    within(:xpath, "//tr[contains(.,\"#{followee.fullname}\")]") do
      click_link("unfollow_#{followee.id}")
    end
  end

  def check_unfollow_status(follower, followee)
    expect(follower.followed?(followee)).to be_falsey
    page.should have_content "Successfully unfollow #{followee.fullname}."
  end

end
