class LevelpacksController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user, only: [:new, :create, :edit, :update, :index, :destroy]

  before_action :find_levelpack, only: [:show, :destroy, :edit, :update]

  def check_solution
    @levelpack = Levelpack.find_by(id: params[:levelpack_id])
    if params[:guess] == @levelpack.solution
      flash[:success] = "JUIST!"
      @user = current_user
      @user.unlock_levelpack_following(@levelpack)
      redirect_to @user
    else
      flash[:error] = "Antwoord is niet correct."
      @level = Level.find_by(id: params[:level_id])
      redirect_to @levelpack
    end
  end

  def new
    @levelpack = Levelpack.new
  end

  def show
    @levelpack ||= Levelpack.find_by(id: params[:levelpack_id])
    if params[:level_id]
      @level = Level.find_by(id: params[:level_id])
    else
      @level = @levelpack.corresponding_levels.first
    end
  end

  def create
    @levelpack = Levelpack.new(levelpack_params)
    if @levelpack.save
      add_levels_to @levelpack
      update_solution_of @levelpack
      flash[:success] = "Levelpack has been succesfully created."
      redirect_to @levelpack
    else
      render 'new'
    end
  end

  def edit
    lvls = @levelpack.corresponding_levels
    @levels = []
    (0..4).each do |n|
      if lvls[n]
        @levels[n] = lvls[n].name
      else
        @levels[n] = ""
      end
    end
  end

  def update
    if @levelpack.update_attributes(levelpack_params)
      remove_levels_of @levelpack
      add_levels_to @levelpack
      update_solution_of @levelpack
      flash[:success] = "Levelpack has been successfully saved."    
      redirect_to @levelpack
    else
      render 'edit'
    end
  end

  def index
    @levelpacks = Levelpack.paginate(page: params[:page])
  end

  def destroy
    @levelpack.destroy
    flash[:success] = "Levelpack successfully destroyed."
    redirect_to levelpacks_url
  end


  def unlock_levelpack_following(levelpack)
    next_levelpack = Levelpack.find_by_name name_of_next(levelpack)
    self.unlock! next_levelpack
  end
  
  def name_of_next(levelpack)
    levelpack_nr = levelpack.name.last(2).to_i
    next_levelpack_nr = levelpack_nr += 1
    "levelpack_#{next_levelpack_nr}"    
  end

  private
    
    def add_levels_to(levelpack)
      (1..5).each do |n|
        unless params["level#{n}_name"].blank?
          level = Level.find_by(name: params["level#{n}_name"])
          levelpack.add! level
        end
      end            
    end
    
    def remove_levels_of(levelpack)
      levelpack.lp_l_relationships.each { |r| r.destroy }
    end
    
    def update_solution_of(levelpack)
      solution = "" 
      levelpack.corresponding_levels.each do |lvl|
        solution += lvl.solution
      end
      levelpack.update_attribute(:solution, solution)
    end
    
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
