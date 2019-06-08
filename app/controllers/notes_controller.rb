class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!

  def index
  end
  
  def create
    logger.debug(note_params)
    @note = Note.new(note_params)
    @note.user = current_user
    logger.debug(@note)
    if @note.save
      redirect_to(:back)
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def edit
  end
  
  def destroy
    if @note_is_mine
      @note.destroy
    else
      flash['error'] = "You do not have permission to perform this operation."
    end
    redirect_to(:back)
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def update
    if ! @note_is_mine
      flash['error'] = "You do not have permission to perform this operation."
      redirect_to(:back)
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  	
  def note_params
    params.require(:note).permit(:title, :body, :list_pin_id, :kind, :user_id)
  end

	def find_note
	  @note = Note.find(params[:id])
	  @note_is_mine = @note.user == current_user
	end
end
