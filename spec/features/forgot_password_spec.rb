require 'spec_helper'

feature "User fogot and reset password" do
  given(:user_email) { 'joe@example.com' }
  given(:user_fullname) { 'Joe Doe' }
  given(:old_password) { 'old_password' }
  given(:new_password) { 'new_password' }

  background do
    Fabricate(:user, fullname: user_fullname, email: user_email, password: old_password)
  end

  scenario "user forgot password but not fill in any email" do
    visit forgot_password_path

    fill_email_and_request_reset_email('')
    expect(page).to have_content "Email cannot be blank."
  end

  scenario "user forgot password but fill in invalid email" do
    visit forgot_password_path

    fill_email_and_request_reset_email('invalid@email.com')
    expect(page).to have_content "Something wrong with you email."
  end

  scenario "user forgot password and fill in correct email" do
    visit forgot_password_path

    fill_email_and_request_reset_email(user_email)
    expect(page).to have_content "We have send an email with instruction to reset your password."

    open_email(user_email)
    expect(current_email).to have_content user_fullname

    current_email.click_link 'Reset My Password'
    expect(page).to have_content 'Reset Your Password'

    fill_new_password_and_reset_password(new_password)
    expect(page).to have_content "Your password has been changed. Please sign in."

    sign_in_with_email_and_password_on_signin_page(user_email, new_password)
    expect(page).to have_content user_fullname

  end

  def fill_email_and_request_reset_email(email)
    fill_in 'Email Address', with: email
    click_button 'Send Email'
  end

  def fill_new_password_and_reset_password(new_password)
    fill_in 'New password', with: new_password
    click_button 'Reset Password'
  end

end
