module API::V1::AuthLogic
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user, except: :sign_in
  end

  private
  def current_user
    @current_user ||= current_token.try(:user)
  end

  def authenticate_user
    render json: { error: 'Token is wrong' }, status: :unauthorized and return unless current_token.present?
    render json: { error: 'Token expired' }, status: :unauthorized and return if current_token.expired?
  end

  def current_token
    token = request.authorization.split('token=').last
    @current_token ||= Token.find_by(token: token)
  end
end
