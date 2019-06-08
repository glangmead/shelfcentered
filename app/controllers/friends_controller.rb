class FriendsController < ApplicationController
	before_filter :authenticate_user!
  def index
    @i_invited = current_user.pending_invited
    @friends = current_user.friends
    @was_invited = current_user.pending_invited_by
    logger.debug("what's in these vars?")
    logger.debug(current_user.invited)
  end
  
  def search
    index
    @found = User.where(["lower(nickname) LIKE lower(?)", '%' + params["query"] + '%']).select {|user| user != current_user}
    @states = @found.map do |f|
      if current_user.invited_by? f and not current_user.friend_with? f
        1
      elsif current_user.invited? f  and not current_user.friend_with? f
        2
      elsif current_user.friend_with? f
        3
      else
        0
      end
    end
    render 'index'
  end
  
  def invite
    @other = User.find(params[:other_id])
    current_user.invite(@other)
    redirect_to action: 'index'
  end
  
  def approve
    @other = User.find(params[:other_id])
    current_user.approve(@other)
    redirect_to action: 'index'
  end

end
