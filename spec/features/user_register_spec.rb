require 'spec_helper'

feature "User registering", {js: true, vcr: true} do
  given(:valid_user_info) {{ email: 'foo@bar.com', fullname: 'Joe Doe', password: 'password' }}
  given(:invalid_user_info) {{ email: 'test@example.com', password: 'pw' }}
  given(:valid_card) {{ number: '4242424242424242', cvc: '999', exp_month: "10 - October", exp_year: "#{Date.today.year + 1}"}}
  given(:invalid_card) {{ number: '4242424242424241', cvc: '999', exp_month: "10 - October", exp_year: "#{Date.today.year + 1}"}}
  given(:declined_card) {{ number: '4000000000000002', cvc: '999', exp_month: "10 - October", exp_year: "#{Date.today.year + 1}"}}

  before do
    visit register_path
  end

  scenario "with valid signin info and valid card" do
    register_with_user_info_and_card(user_info: valid_user_info, card: valid_card)

    expect(page).to have_content valid_user_info[:fullname]
    expect(ActionMailer::Base.deliveries.last.to).to eq([valid_user_info[:email]] )
  end

  scenario "with invalid signin info and valid card" do
    register_with_user_info_and_card(user_info: invalid_user_info, card: valid_card)

    expect(page).to have_content "Fullname can't be blank"
    expect(page).to have_content "Password is too short"
    expect(User.all.size).to eq(0)
  end

  scenario "with valid signin info and invalid card" do
    register_with_user_info_and_card(user_info: valid_user_info, card: invalid_card)

    expect(page).to have_content "Register"
    expect(User.all.size).to eq(0)
  end

  scenario "with invalid signin info and invalid card" do
    register_with_user_info_and_card(user_info: invalid_user_info, card: invalid_card)

    expect(page).to have_content "Register"
    expect(User.all.size).to eq(0)
  end

  scenario "with valid signin info and declined card" do
    register_with_user_info_and_card(user_info: valid_user_info, card: declined_card)

    expect(page).to have_content "declined"
    expect(User.all.size).to eq(0)
  end

  scenario "with invalid signin info and declined card" do
    register_with_user_info_and_card(user_info: invalid_user_info, card: declined_card)

    expect(page).to have_content "Fullname can't be blank"
    expect(page).to have_content "Password is too short"
    expect(User.all.size).to eq(0)
  end
end

def register_with_user_info_and_card(options={})
  fill_in 'Email Address', with: options[:user_info][:email]
  fill_in 'Full Name', with: options[:user_info][:fullname]
  fill_in 'Password', with: options[:user_info][:password]
  fill_in 'Credit Card Number', with: options[:card][:number]
  fill_in 'Security Code', with: options[:card][:cvc]
  select(options[:card][:exp_month], :from => 'exp_month' )
  select(options[:card][:exp_year], :from => 'exp_year' )
  click_button 'Sign Up'
end
