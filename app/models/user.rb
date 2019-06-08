class User < ActiveRecord::Base
  include Amistad::FriendModel
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable
  has_attached_file :avatar, :styles => {:thumb => '50x50', :tiny => '25x25', :medium => '100x100'}
  do_not_validate_attachment_file_type :avatar
  crop_attached_file :avatar
  validates_uniqueness_of :nickname
  has_many :lists
  has_many :notes
  
  def recent_paths
    [self.recent_path1,
    self.recent_path2,
    self.recent_path3,
    self.recent_path4,
    self.recent_path5,
    self.recent_path6,
    self.recent_path7,
    self.recent_path8,
    self.recent_path9].select { |path| ! path.blank? }
  end
  
  def add_recent_path(new_path_int)
    new_path = "#{new_path_int}"
    recent_paths = self.recent_paths
    Rails.logger.debug("recent paths: #{recent_paths}")
    # first, look for a dup of the new_path
    dup_index = recent_paths.find_index(new_path)
    unless dup_index.blank?
      Rails.logger.debug("dup path: #{dup_index} for #{new_path}")
    end
    # then, insert the new path in the "most recent" position
    recent_paths.insert(0, new_path)
    Rails.logger.debug("recent paths: #{recent_paths}")
    # if the dup was present, remove it, else remove the last element
    if dup_index != nil
      recent_paths.delete_at(dup_index + 1)
    elsif recent_paths.length > 9
      recent_paths.delete_at(-1)
    end
    Rails.logger.debug("recent paths: #{recent_paths}")
    num_paths = recent_paths.length
    if num_paths > 0
      self.recent_path1 = recent_paths[0]
    end
    if num_paths > 1
      self.recent_path2 = recent_paths[1]
    end
    if num_paths > 2
      self.recent_path3 = recent_paths[2]
    end
    if num_paths > 3
      self.recent_path4 = recent_paths[3]
    end
    if num_paths > 4
      self.recent_path5 = recent_paths[4]
    end
    if num_paths > 5
      self.recent_path6 = recent_paths[5]
    end
    if num_paths > 6
      self.recent_path7 = recent_paths[6]
    end
    if num_paths > 7
      self.recent_path8 = recent_paths[7]
    end
    if num_paths > 8
      self.recent_path9 = recent_paths[8]
    end
    self.save
  end
end
