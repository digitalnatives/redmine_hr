class HrHolidayRequestsController < HrAPIController

  UPDATEABLE_ATTRIBUTES = {
    admin: [
      :hr_employee_profile_id,
      :id,
      :start_date,
      :end_date,
      :type,
      :half_day,
      :description,
      :status
    ], user: []
  }

  def create
    params = safe_params
    params[:hr_employee_profile_id] ||= User.current.hr_employee_profile.id
    resource = klass.create! params
    render :json => resource
  end
end
