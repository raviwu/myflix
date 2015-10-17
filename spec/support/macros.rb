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
