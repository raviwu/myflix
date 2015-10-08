def set_current_user
  ravi = Fabricate(:user, password: 'password')
  session[:user_id] = ravi.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end
