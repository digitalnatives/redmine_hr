class HrHolidayModifiersController < HrAPIController

  UPDATEABLE_ATTRIBUTES = {
    admin: [:id,:year,:description,:value,:hr_employee_profile_id],
    user: []
  }

  before_filter :convert_year, only: [:create,:update]
  before_filter :get_profile, only: [:index]

  def index
    render :json => @profile
  end

  def create
    resource = klass.create! safe_params
    render :json => resource
  end

  private

  def convert_year
    params[:hr_holiday_modifier][:year] = Date.new(Integer(params[:hr_holiday_modifier][:year])) unless params[:hr_holiday_modifier][:year].blank?
  rescue e
  end

  def get_profile
    @profile = klass.by_profile(params[:hr_employee_profile_id])
  end
end
