module SessionsHelper

  #logging user in
  def log_in(user)
    session[:user_id]=user.id
  end

  #returns true if user is logged in or return else if is not
  def logged_in?
    !current_user.nil?
  end

  #returns true if current user is logged in
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
