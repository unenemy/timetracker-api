class API::V1::BaseController < InheritedResources::Base
  respond_to :json
  include API::V1::AuthLogic
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found


  private
  def authenticate_manager
    render json: { error: 'Sign in as manager to do it' }, status: 400 and return unless current_user.is_a? Manager
  end

  def authenticate_employee
    render json: { error: 'Sign in as employee to do it' }, status: 400 and return unless current_user.is_a? Employee
  end

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end
end
