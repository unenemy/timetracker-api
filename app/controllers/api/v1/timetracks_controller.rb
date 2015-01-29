class API::V1::TimetracksController < API::V1::BaseController
  private
  def timetrack_params
    permitted = [:description, :date, :amount_in_minutes]
    permitted << :employee_id if current_user.manager?
    params.require(:timetrack).permit(permitted)
  end

  def end_of_association_chain
    if current_user.employee?
      current_user.timetracks
    else
      super
    end
  end
end
