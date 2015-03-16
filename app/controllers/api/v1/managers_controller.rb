class API::V1::ManagersController < API::V1::BaseController
  before_action :authenticate_manager, except: [:sign_in, :sign_out]

  def sign_in
    @token, @manager = Manager.authenticate(params[:manager][:email], params[:manager][:password])
    if @token
    else
      render json: { error: 'Wrong credentials' }, status: :bad_request
    end
  end

  def sign_out
    current_token.destroy
    head 204
  end

  private
  def manager_params
    params.require(:manager).permit(:email, :password)
  end
end
