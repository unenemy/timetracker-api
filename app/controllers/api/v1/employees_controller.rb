class API::V1::EmployeesController < API::V1::BaseController
  skip_before_action :authenticate_user, only: [:sign_in, :create]
  before_action :check_ownership, only: :update
  before_action :authenticate_manager, only: :destroy

  def sign_in
    @token, @employee = Employee.authenticate(params[:employee][:email], params[:employee][:password])
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
  def employee_params
    params.require(:employee).permit(:email, :password, :password_confirmation)
  end

  def check_ownership
    employee = Employee.find(params[:id])
    if current_user.is_a?(Employee) && current_user != employee
      render json: { error: 'Can\'t update another employee' }, status: 400 and return
    end
  end
end
