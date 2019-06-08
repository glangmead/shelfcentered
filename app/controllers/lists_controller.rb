class ListsController < ApplicationController
  before_action :find_list, only: [:show, :edit, :update, :destroy]
  before_action :find_users, only: [:show, :index]
  before_action :update_recents, only: [:show]
	before_filter :authenticate_user!
  def index
    @lists = @list_user.lists.order("created_at desc").select {|list| list.is_visible(current_user)}
  end
  
  def update_recents
    if @list_is_visible
      current_user.add_recent_path(@list.id)
      recent_paths # force update
    end
  end
  
  def show
    if ! @list_is_visible
      current_user.add_recent_path(@list.id)
      flash['error'] = "You do not have permission to perform this operation."
      redirect_to :back
    end    
  end

  def new
    @list = current_user.lists.build
  end
  
  def create
    @list = current_user.lists.build(list_params)
    
    if @list.save
      redirect_to @list, notice: "Successfully created new list"
    else
      render 'new'
    end
  end
  
  def edit
    if ! @list_is_mine
      flash['error'] = "You do not have permission to perform this operation."
      redirect_to :back
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def update
    if @list_is_mine
      if @list.update(list_params)
        redirect_to @list, notice: "List was successfully updated"
      else
        render 'edit'
      end
    else
      flash['error'] = "You do not have permission to perform this operation."
      redirect_to :back
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def destroy
    if @list_is_mine
      @list.destroy
      redirect_to root_path
    else
      flash['error'] = "You do not have permission to perform this operation."
      redirect_to :back
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  private
  
  def list_params
    params.require(:list).permit(:title, :description, :visibility)
  end
  
  def find_users
    @current_user = current_user
    @list_user = current_user
    if params.include? :user_id
      @list_user = User.find(params[:user_id])
    end
    @list_user_is_me = @list_user == current_user
  end
  
  def find_list
    @list = List.find(params[:id])
    @list_pins = @list.list_pins
    @list_is_mine = (@list.user.id == current_user.id)
    @show_notes = params.has_key?("secret") ? true : ! @list_is_mine
    @list_is_visible = @list.is_visible(current_user)
  end
end
