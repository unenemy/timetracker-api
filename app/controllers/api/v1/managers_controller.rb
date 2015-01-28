class API::V1::ManagersController < API::V1::BaseController
  def sign_in
    token = Manager.authenticate(params[:manager][:email], params[:manager][:password])
    if token
      render json: { auth_token: token }
    else
      render json: { error: 'Wrong credentials' }, status: :bad_request
    end
  end

  def sign_out
    current_token.destroy
    head 204
  end
end
