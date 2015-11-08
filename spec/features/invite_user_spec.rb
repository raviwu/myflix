require 'spec_helper'

feature "User can invite other users", { js: true, vcr: true } do
  given(:joe) { Fabricate(:user, fullname: 'Joe Doe') }
  given(:invitation) {{ invitor: joe, guest_email: 'alice@example.com', guest_fullname: 'Alice Chou', message: 'Hi, Alice. Please join MyFLix with me!' }}
  given(:valid_card) {{ number: '4242424242424242', cvc: '999', exp_month: "12 - December", exp_year: "2025"}}

  scenario "user invite other people to join" do
    invite_friend(invitation)

    open_invitation_email(invitation)

    register_with_valid_card(invitation)

    check_if_new_user_follow_invitor(invitation)

    check_if_invitor_follow_new_user(invitation)
  end

  def invite_friend(invitation={})
    sign_in(invitation[:invitor])

    visit invite_path
    expect(page).to have_content 'Invite a friend to join MyFlix!'

    fill_in "Friend's Name", with: invitation[:guest_fullname]
    fill_in "Friend's Email Address", with: invitation[:guest_email]
    fill_in "Invitation Message", with: invitation[:message]
    click_button 'Send Invitation'

    expect(page).to have_content "You've successfully invite #{invitation[:guest_fullname]} to join MyFlix!"
    sign_out(invitation[:invitor])
  end

  def open_invitation_email(invitation={})
    open_email(invitation[:guest_email])
    expect(current_email).to have_content invitation[:message]
    current_email.click_link 'Join Me on MyFLix'
  end

  def register_with_valid_card(invitation={})
    expect(page).to have_content 'Register'
    expect(find_field('Email Address').value).to eq(invitation[:guest_email])
    expect(find_field('Full Name').value).to eq(invitation[:guest_fullname])
    fill_in 'Password', with: 'password'
    fill_in 'Credit Card Number', with: valid_card[:number]
    fill_in 'Security Code', with: valid_card[:cvc]
    select(valid_card[:exp_month], :from => 'exp_month' )
    select(valid_card[:exp_year], :from => 'exp_year' )
    click_button 'Sign Up'

    expect(page).to have_content invitation[:guest_fullname]
  end

  def check_if_new_user_follow_invitor(invitation={})
    visit sign_in_path
    sign_in_with_email_and_password_on_signin_page(invitation[:guest_email], 'password')

    visit people_path
    expect(page).to have_content invitation[:invitor].fullname

    sign_out(User.last)
  end

  def check_if_invitor_follow_new_user(invitation={})
    sign_in(invitation[:invitor])

    visit people_path
    expect(page).to have_content invitation[:guest_fullname]
  end
end
