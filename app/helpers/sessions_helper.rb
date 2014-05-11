module SessionsHelper
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    cookies.permanent[:levelpack_id] = user.unlocked_levelpacks.last.id
    cookies.permanent[:level_id] = user.unlocked_levelpacks.last.corresponding_levels.first.id
    user.update_attribute(:remember_token, User.hash(remember_token))
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def admin?
    current_user.admin?
  end
  
  def sign_out
    current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    cookies.delete(:levelpack_id)
    cookies.delete(:level_id)
    self.current_user = nil
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    remember_token = User.hash(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def current_levelpack=(levelpack)
    @levelpack = levelpack
  end
  
  def current_levelpack
    @levelpack ||= Levelpack.find_by(id: cookies[:levelpack_id])
  end
  
  def current_levelpack?(levelpack)
    levelpack == current_levelpack
  end
  
  def current_level=(level)
    @level = level
  end
  
  def current_level
    @level ||= Level.find_by(id: cookies[:level_id])
  end
  
  def current_level?(level)
    level == current_level
  end
  
  def store_location
    session[:return_to] = request.url if request.get?
  end
  
  def redirect_back_or(default)
    redirect_to session[:return_to] || default
    session.delete :return_to
  end
end
