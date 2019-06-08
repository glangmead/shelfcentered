class ListPin < ActiveRecord::Base
	belongs_to :list, foreign_key: 'list_id', inverse_of: :list_pins
	belongs_to :pin, foreign_key: 'pin_id', inverse_of: :list_pins
	has_many :notes, :dependent => :destroy
	self.table_name = "lists_pins"
	accepts_nested_attributes_for :pin, allow_destroy: true
	accepts_nested_attributes_for :notes
	
	# item is claimed if any note is a claim
	def is_claimed
	  claimed = false
	  self.notes.each do |note|
	    if note.is_claim
	      claimed = true
	    end
	  end
	  return claimed
	end
	
	def user
	  self.list.user
	end
end
