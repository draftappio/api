class Users::InvitationsController < Devise::InvitationsController
  before_action :resource_from_invitation_token, only: [:update]

  ################# Documentation ##############################################
  api :PUT, '/auth/invitation/accept', 'Accept an invitation and set password'
  example <<-EOS
    { success: ['User updated.'] }
  EOS
  param :invitation_token, String, desc: 'User invitation token', required: true
  param :password, String, desc: 'Password', required: true
  param :password_confirmation, String, desc: 'Confirm password', required: true
  error code: 406, desc: 'Invalid token.'
  error code: 422, desc: 'Invalid password or password_confirmation'
  ################# Documentation ##############################################
  def update
    user = User.accept_invitation!(accept_invitation_params)
    if user.errors.empty?
      render json: { success: ['User updated.'] }, status: :accepted
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private
  def resource_from_invitation_token
    @user = User.find_by_invitation_token(params[:invitation_token], true)
    return if params[:invitation_token] && @user

    render json: { errors: ['Invalid token.'] }, status: :not_acceptable
  end

  def accept_invitation_params
      params.permit(:password, :password_confirmation, :invitation_token)
  end
end
