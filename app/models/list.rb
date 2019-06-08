class List < ActiveRecord::Base
	belongs_to :user
	has_many :pins, through: :list_pins
	has_many :list_pins, inverse_of: :list, foreign_key: 'list_id'
	
	PRIVATE = 0
	FRIENDS = 1
	PUBLIC = 2
	
	def is_visible(user)
	  visible = false
	  list_user = self.user
	  if user == self.user
	    visible = true
	  elsif self.visibility == PUBLIC
	    visible = true
	  elsif self.visibility == FRIENDS && list_user.friend_with?(user)
	    visible = true
	  end
	  visible
	end
end
