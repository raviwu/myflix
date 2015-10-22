require 'spec_helper'

feature "Signing in" do
  background do
    clear_emailer_deliveries
  end
  scenario "with valid signin info" do
    visit register_path
    fill_in 'Email Address', with: 'foo@bar.com'
    fill_in 'Full Name', with: 'Joe Doe'
    fill_in 'Password', with: 'password'
    click_button 'Sign Up'

    expect(page).to have_content 'Joe Doe'
    expect(ActionMailer::Base.deliveries.last.to).to eq(['foo@bar.com'] )
  end
end
