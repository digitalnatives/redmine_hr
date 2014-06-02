class HrEmployeeProfilesController < HrAPIController

  UPDATEABLE_ATTRIBUTES = {
    admin: [:id, :supervisor_id, :administrator, :user_id],
    user: []
  }

  def index
    resources = klass.all.select do |profile|
      profile.user.allowed_to_hr?
    end
    render :json => resources
  end
end
