class API::V1::EmployeesController < API::V1::BaseController
  def sign_in
    token = Employee.authenticate(params[:employee][:email], params[:employee][:password])
    if token
      render json: { token: token }
    else
      render json: { error: 'Wrong credentials' }, status: :bad_request
    end
  end

  def sign_out
    current_token.destroy
    head 204
  end
end
