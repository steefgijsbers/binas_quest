class LevelsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user
  
  def new
    @level = Level.new
  end
  
  def show
    @level = Level.find(params[:id])
  end
  
  def create
    @level = Level.new(level_params) 
    if @level.save
      @level.update_attribute(:thumb_src, generate_thumb_src(@level.img_src))
      flash[:success] = "Upload geslaagd."
      redirect_to @level
    else
      render 'new'
    end
  end
  
  def index
    @levels = Level.paginate(page: params[:page])
  end
  
  def destroy
    Level.find(params[:id]).destroy
    flash[:success] = "Level succesvol verwijderd"
    redirect_to levels_url
  end
  
  
  private
  
  def generate_thumb_src(img_src)
    img_src.split('.')[0] += "_thumb.bmp"
  end
  
  def level_params
    params.require(:level).permit(:name, :img_src, :solution)
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Voor deze actie moet je inloggen en administrator privileges hebben"
    end
  end
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
 
end
