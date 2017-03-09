class ProfileController < BaseController
  def update_avatar
    current_user.update_attribute(:avatar, params[:avatar])
    current_user.update_attribute(:image, current_user.avatar.url)

    render json: { avatar_url: current_user.avatar.url }, status: 200
    
  end
  def update_avatar_params
    params.permit(:avatar)
  end
end
