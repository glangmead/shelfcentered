class ListPinsController < ApplicationController
  before_action :find_list_pin, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!

  def create
  end
  
  def edit
  end
  
  def destroy
  end
  
  def update
  end
  	
  def list_pin_params
    params.require(:list_pin).permit(:list_id, :pin_id, :note_ids => [])
  end

	def find_list_pin
	  @list_pin = ListPin.find(params[:id])
	end
end
