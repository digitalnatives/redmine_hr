class HrHolidayRequestsController < HrAPIController
  load_and_authorize_resource only: [:create,:update]

  UPDATEABLE_ATTRIBUTES = [
    :hr_employee_profile_id,
    :id,
    :start_date,
    :end_date,
    :request_type,
    :half_day,
    :description,
    :status
  ]

  def report
    respond_to do |format|
      format.html
      format.pdf do
        pdf = HolidayReport.new get_scope.as_json
        send_data pdf.render, filename: "holidays_and_sickleaves.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def index
    render :json => get_scope.all
  end

  def filter_data
    requests = HrHolidayRequest.scoped
    requests = if params[:user]
      requests.by_user(params[:user])
    elsif User.current.role == :admin
      requests.all
    else
      requests.by_user(User.current.id) + requests.by_supervisor(User.current.id)
    end
    render json: {
      year: requests.group_by { |r| r.start_date.year }.keys.uniq,
      profiles: requests.map(&:hr_employee_profile).map(&:as_json),
      status: requests.group_by { |r| r.status }.keys.uniq
    }
  end

  def create
    params = safe_params
    params[:hr_employee_profile_id] ||= User.current.hr_employee_profile.id
    resource = klass.create! params
    render :json => resource
  end

  HrHolidayRequest::SM.events.map(&:name).each do |method|
    define_method method.to_s+"!" do
      get_resource
      return deny_access unless current_ability.can?(method,@resource)
      @resource.send("#{method}!")
      show
    end
  end

  private

  def get_scope
    scope = HrHolidayRequest.scoped
    scope = scope.by_year(DateTime.new(params[:year].to_i)) unless params[:year].blank?
    scope = scope.by_status(params[:status]) unless params[:status].blank?
    scope = scope.by_user(params[:user]) unless params[:user].blank?

    if User.current.role == :user && params[:user].to_i != User.current.hr_employee_profile.id
      scope = scope.by_supervisor(User.current.id)
    else
      scope = scope.by_supervisor(params[:supervisor]) unless params[:supervisor].blank?
    end
    scope
  end
end
