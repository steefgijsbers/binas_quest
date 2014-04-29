class LevelpacksController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user
  
  def new
    @levelpack = Levelpack.new
  end
  
  def show
    @levelpack = Levelpack.find_by(id: params[:id])
    @levels = @levelpack.corresponding_levels
  end
  
  def create
    @levelpack = Levelpack.new(levelpack_params)
    @levelpack.solution = ""
    if @levelpack.save
      flash[:success] = "Levelpack has been succesfully created."
      redirect_to levelpacks_url
    else
      render 'new'
    end
  end
  
  def index
    @levelpacks = Levelpack.paginate(page: params[:page])
  end
  
  def destroy
    Levelpack.find(params[:id]).destroy
    flash[:success] = "Levelpack successfully destroyed."
    redirect_to levelpacks_url
  end
  
  
  private
  
    def levelpack_params
      params.require(:levelpack).permit(:name, :title)
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