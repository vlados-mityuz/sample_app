module SessionsHelper

  #logging user in
  def log_in(user)
    session[:user_id]=user.id
  end
end
