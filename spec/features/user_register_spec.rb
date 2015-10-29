require 'spec_helper'

feature "Signing in" do
  scenario "with valid signin info", {js: true, vcr: true} do
    visit register_path
    fill_in 'Email Address', with: 'foo@bar.com'
    fill_in 'Full Name', with: 'Joe Doe'
    fill_in 'Password', with: 'password'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select('10 - October', :from => 'exp_month' )
    select("#{Date.today.year + 1}", :from => 'exp_year' )
    click_button 'Sign Up'

    expect(page).to have_content 'Joe Doe'
    expect(ActionMailer::Base.deliveries.last.to).to eq(['foo@bar.com'] )
  end
end
