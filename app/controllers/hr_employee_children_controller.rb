class HrEmployeeChildrenController < HrAPIController

  UPDATEABLE_ATTRIBUTES = {
    admin: [:id,:name,:gender,:birth_date,:hr_employee_profile_id],
    user: []
  }

  def index
    @children = klass.by_employee_profile(params[:hr_employee_profile_id])
    render :json => @children
  end

  def create
    resource = klass.create safe_params
    render :json => resource
  end

  def destroy
    @resource.destroy
    head 200
  end

end
