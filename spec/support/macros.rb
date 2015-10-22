def set_current_user(user = nil)
  ravi = Fabricate(:user, password: 'password')
  session[:user_id] = (user ? user.id : ravi.id)
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user = nil)
  user = a_user || Fabricate(:user, password: 'password')
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: 'password'
  click_button 'Sign in'
end

def sign_out
  page.find(:css, "a[href='#{sign_out_path}']").click
end

def sign_in_with_email_and_password_on_signin_page(email, password)
  fill_in 'Email Address', with: email
  fill_in 'Password', with: password
  click_button 'Sign in'
end

def click_video_on_home_path(video)
  visit home_path
  find(:xpath, "//a/img[@alt='#{video.title}']/..").click
end
