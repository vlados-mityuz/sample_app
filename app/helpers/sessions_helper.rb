module SessionsHelper

  #logging user in
  def log_in(user)
    session[:user_id]=user.id
  end

  # Remembers user in permanent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns user with specified token from cookies
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.autheticated?(cookies[:remember_token])
        log_in user_id
        @current_user = user
      end
    end
  end 

  #returns true if user is logged in or return else if is not
  def logged_in?
    !current_user.nil?
  end

  #returns true if current user is logged in
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the user is current
  def current_user?(user)
    user == current_user
  end

  # Forgets permanent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # logs out current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirect to saved path or to the default page
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Remembers URL
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
