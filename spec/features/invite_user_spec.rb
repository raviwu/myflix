require 'spec_helper'

feature "User can invite other users", { js: true, vcr: true } do
  given(:joe) { Fabricate(:user, fullname: 'Joe Doe') }
  given(:guest_email) { 'alice@example.com' }
  given(:guest_fullname) { 'Alice Chou' }
  given(:invitation_message) { 'Hi, Alice. Please join MyFLix with me!' }

  background do
    sign_in(joe)
  end

  scenario "user invite other people to join" do
    visit invite_path
    expect(page).to have_content 'Invite a friend to join MyFlix!'

    fill_in "Friend's Name", with: guest_fullname
    fill_in "Friend's Email Address", with: guest_email
    fill_in "Invitation Message", with: invitation_message
    click_button 'Send Invitation'

    expect(page).to have_content "You've successfully invite #{guest_fullname} to join MyFlix!"

    sign_out(joe)
    open_email(guest_email)
    expect(current_email).to have_content invitation_message
    current_email.click_link 'Join Me on MyFLix'

    expect(page).to have_content 'Register'
    expect(find_field('Email Address').value).to eq(guest_email)
    expect(find_field('Full Name').value).to eq(guest_fullname)
    fill_in 'Password', with: 'password'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select('10 - October', :from => 'exp_month' )
    select("#{Date.today.year + 1}", :from => 'exp_year' )
    click_button 'Sign Up'

    expect(page).to have_content guest_fullname

    visit sign_in_path
    sign_in_with_email_and_password_on_signin_page(guest_email, 'password')

    visit people_path
    expect(page).to have_content joe.fullname

    sign_out(User.last)
    sign_in(joe)

    visit people_path
    expect(page).to have_content guest_fullname
  end
end
