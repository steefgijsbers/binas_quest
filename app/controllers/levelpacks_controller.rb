class LevelpacksController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user

  before_action :find_levelpack, only: [:show, :destroy, :edit, :update]

  def new
    @levelpack = Levelpack.new
  end

  def show
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

  def edit
  end

  def update
    unless params[:level_name].blank?
      level = Level.find_by_name params[:level_name]
      @levelpack.add! level
    end
    redirect_to levelpack_path(@levelpack)
  end

  def index
    @levelpacks = Levelpack.paginate(page: params[:page])
  end

  def destroy
    @levelpack.destroy
    flash[:success] = "Levelpack successfully destroyed."
    redirect_to levelpacks_url
  end


  private

    def find_levelpack
      @levelpack = Levelpack.find(params[:id])
    end

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
