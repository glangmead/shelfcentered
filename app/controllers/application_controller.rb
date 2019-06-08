class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :recent_paths
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :nickname, :avatar, :avatar_original_w, :avatar_original_h, :avatar_box_w, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h, :avatar_aspect])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :avatar, :avatar_original_w, :avatar_original_h, :avatar_box_w, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h, :avatar_aspect, ])
  end

  def recent_paths
    if ! current_user.blank?
      @recent_paths = current_user.recent_paths.select { |path| List.exists?(:id => path.to_i) && List.find(path.to_i).is_visible(current_user) }
      @recent_path_names = @recent_paths.map do |path|
        list = List.find(path.to_i)
        name = ""
        if list.is_visible(current_user)
          if list.user == current_user
            name = list.title
          else
            name = "#{list.title} (#{list.user.nickname})"
          end
        end
        name
      end
    end
  end
end
