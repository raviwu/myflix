require 'spec_helper'

feature "Signing in" do
  given(:user) {Fabricate(:user, password: 'password')}

  scenario "with valid email and password" do
    sign_in(user)
    expect(page).to have_content user.fullname
  end

  scenario "with invalid email and password" do
    visit sign_in_path
    fill_in 'Email Address', with: user.email
    click_button 'Sign in'
    expect(page).to have_content 'Invalid email / password combination.'
  end
end
