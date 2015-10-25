require 'spec_helper'

feature "Admin adds video" do
  given(:admin) { Fabricate(:admin) }
  given(:user) { Fabricate(:user) }

  background do
    Fabricate(:category, title: 'comedy')
    Fabricate(:category, title: 'action')
  end

  scenario "admin signs in and add video with correct input" do
    sign_in(admin)

    visit new_admin_video_path
    fill_in "Title", with: 'Up'
    select('Comedy', :from => 'Category')
    fill_in "Description", with: 'A funny movie.'
    attach_file('Large cover', 'spec/support/uploads/up_l.jpg')
    attach_file('Small cover', 'spec/support/uploads/up_s.jpg')
    fill_in "Video URL", with: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4'
    click_button 'Add Video'

    expect(page).to have_content "You've added video Up."
    expect(page).to have_content "Add a New Video"

    sign_out
    sign_in(user)

    click_link "Videos"
    expect(page).to have_selector("img[src='/uploads/up_s.jpg']")
    click_video_on_home_path(Video.last)
    expect(page).to have_selector("img[src='/uploads/up_l.jpg']")
    expect(page).to have_selector("a[href='http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4']")
  end

  scenario "admin signs in but add invalid input" do
    sign_in(admin)

    visit new_admin_video_path
    select('Comedy', :from => 'Category')
    fill_in "Description", with: 'A funny movie.'
    fill_in "Video URL", with: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4'
    click_button 'Add Video'

    expect(page).to have_content "Failed to create video. Please fix the problem."
  end
end
