require 'spec_helper'

feature "Admin adds video" do
  given(:admin) { Fabricate(:admin) }
  given(:user) { Fabricate(:user) }
  given(:comedy) { Fabricate(:category, title: 'comedy') }
  given(:up) { { title: 'Up',
                 category: comedy.title.capitalize,
                 description: 'A funny movie',
                 large_cover: 'spec/support/uploads/up_l.jpg',
                 small_cover: 'spec/support/uploads/up_s.jpg',
                 video_url: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4'} }
  given(:invalid_video_input) {{ category: comedy.title.capitalize,
                                 description: 'This is the only input user made.' }}

  scenario "admin signs in and add video with correct input" do
    sign_in(admin)

    admin_adds_new_video(up)

    check_if_video_added_and_redirect_back_to_add_new

    sign_out

    sign_in(user)

    check_if_new_added_video_show_up_on_home(up)

    check_if_new_added_video_has_correct_large_cover_and_video_url(up)
  end

  scenario "admin signs in but add invalid input" do
    sign_in(admin)

    admin_adds_new_video(invalid_video_input)

    check_if_admin_failed_to_add_new_video
  end

  def admin_adds_new_video(video)
    visit new_admin_video_path
    fill_in "Title", with: video[:title]
    select(video[:category], :from => 'Category')
    fill_in "Description", with: video[:description]
    attach_file('Large cover', video[:large_cover])
    attach_file('Small cover', video[:small_cover])
    fill_in "Video URL", with: video[:video_url]
    click_button 'Add Video'
  end

  def check_if_video_added_and_redirect_back_to_add_new
    expect(page).to have_content "You've added video Up."
    expect(page).to have_content "Add a New Video"
  end

  def check_if_new_added_video_show_up_on_home(video)
    click_link "Videos"
    expect(page).to have_selector("img[src='/uploads/#{video[:title].split(' ').join("_").downcase}_s.jpg']")
  end

  def check_if_new_added_video_has_correct_large_cover_and_video_url(video)
    click_video_on_home_path(Video.last)
    expect(page).to have_selector("img[src='/uploads/#{video[:title].split(' ').join("_").downcase}_l.jpg']")
    expect(page).to have_selector("a[href='#{video[:video_url]}']")
  end

  def check_if_admin_failed_to_add_new_video
    expect(page).to have_content "Failed to create video. Please fix the problem."
  end
end
