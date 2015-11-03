require 'spec_helper'

feature 'Admin views recent payment', {js: true, vcr: true} do
  given(:admin) { Fabricate(:admin) }
  given(:joe) { Fabricate(:user, fullname: 'Joe Doe', email: 'joe@example.com') }

  before do
    Fabricate(:payment, user: joe, reference_id: "asdfg")
  end

  scenario "admin sees the 10 recent payments" do
    sign_in(admin)
    visit admin_payments_path
    expect(page).to have_content('Joe Doe')
    expect(page).to have_content('joe@example.com')
    expect(page).to have_content('$9.99')
  end

  scenario "user cannot see payments" do
    sign_in
    visit admin_payments_path
    expect(page).to have_content("You are not authenticated to access that area.")
  end
end
