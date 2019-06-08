class Pin < ActiveRecord::Base
  retina!
  validates :lists, presence: true
  validates :title, presence: true
	has_attached_file :image, styles: {medium: "300x300>" }
	do_not_validate_attachment_file_type :image
	has_many :lists, through: :list_pins
	has_many :list_pins, inverse_of: :pin, :dependent => :destroy, foreign_key: 'pin_id'
	
	def image_remote_url=(url_value)
	  if ! url_value.blank?
  	  self.image = URI.parse(url_value)
  	end
    super url_value
	end
	
	def user
	  self.lists.first.user
	end
end
