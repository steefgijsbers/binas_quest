class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:show, :index, :edit, :update, :destroy] 
  before_action :correct_user,    only: [:show, :edit, :update]
  before_action :admin_user,      only: [:destroy, :index]

  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def show
    @user = User.find(params[:id])
    @unlocked_levelpacks = @user.unlocked_levelpacks    
    @levelpack ||= Levelpack.find_by(id: cookies[:levelpack_id])
    @levels = @levelpack.corresponding_levels
    @level ||= Level.find_by(id: cookies[:level_id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.unlock! Levelpack.first
      sign_in @user
      flash[:success] = "Welkom bij de Binas Quest!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Wijzigingen opgeslagen"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Gebruiker is verwijderd"
    redirect_to users_url
  end
  
  
  def toggle_current_levelpack_or_level
    if params[:levelpack_id]
      cookies[:levelpack_id] = params[:levelpack_id]
      cookies[:level_id] = current_levelpack.corresponding_levels.first.id
    end
    
    if params[:level_id]
      cookies[:level_id] = params[:level_id]
    end
    redirect_to current_user
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:naam, :klas, :email, :password, :password_confirmation)
  end
  
  
  # before filters
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Voor deze actie moet je ingelogd zijn"
    end    
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to signin_url, notice: "Voor deze actie moet je ingelogd zijn" unless current_user?(@user)
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
