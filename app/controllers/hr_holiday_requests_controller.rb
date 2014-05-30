class HrHolidayRequestsController < HrAPIController

  UPDATEABLE_ATTRIBUTES = [
    :hr_employee_profile_id,
    :id,
    :start_date,
    :end_date,
    :type,
    :half_day,
    :description,
    :status
  ]

  def create
    params = safe_params
    params[:hr_employee_profile_id] ||= User.current.hr_employee_profile.id
    resource = klass.create! params
    render :json => resource
  end

  HrHolidayRequest::SM.events.map(&:name).each do |method|
    define_method method.to_s+"!" do
      get_resource
      return deny_access unless @resource.user_allowed_to?(User.current, method)
      @resource.send("#{method}!")
      show
    end
  end
end
