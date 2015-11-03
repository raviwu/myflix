def set_current_user(user = nil)
  ravi = Fabricate(:user, password: 'password')
  session[:user_id] = (user ? user.id : ravi.id)
end

def set_current_admin(admin = nil)
  session[:user_id] = (admin ? admin.id : Fabricate(:admin).id)
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

def sign_out(user)
  click_on("Welcome, #{user.fullname}")
  click_on("Sign out")
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

def user_register(options={})
  visit register_path

  fill_in 'Email Address', with: options[:email]

  fill_in 'Full Name', with: options[:fullname]

  fill_in 'Password', with: options[:password]

  fill_in 'Credit Card Number', with: options[:number]

  fill_in 'Security Code', with: options[:cvc]
  select(options[:exp_month], :from => 'exp_month' )
  select(options[:exp_year], :from => 'exp_year' )

  click_button 'Sign Up'

  sleep 3.0 # wait for the js finishing
end
