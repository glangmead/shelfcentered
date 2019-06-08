class Note < ActiveRecord::Base
  belongs_to :list_pin
  belongs_to :user
  
  def is_claim
    self.kind == 2
  end
end
