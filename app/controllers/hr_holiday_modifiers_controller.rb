class HrHolidayModifiersController < HrAPIController

  UPDATEABLE_ATTRIBUTES = {
    admin: [:year,:description,:value,:hr_employee_profile_id],
    user: []
  }

  before_filter :get_profile, only: [:index]

  def index
    render :json => @profile
  end

  def create
    resource = klass.create safe_params
    render :json => resource
  end

  def destroy
    @resource.destroy
    head 200
  end

  private

  def get_profile
    @profile = klass.by_profile(params[:hr_employee_profile_id])
  end
end
