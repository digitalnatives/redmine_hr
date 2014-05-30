ActionController::Parameters.action_on_unpermitted_parameters = :raise
Rails.configuration.to_prepare do

  User.class_eval do
    has_one :hr_employee_profile
    before_create :build_default_hr_employee_profile

    def allowed_to_hr?
      allowed_to?(:view_holidays, nil, global: true)
    end

    def hr_admin?
      return true if admin?
      hr_role = Role.find Setting.plugin_redmine_hr[:admin_role]
      return true if project_roles.include?(hr_role)
      false
    end

    private

    # Create employee_profile automatically
    def build_default_hr_employee_profile
      build_hr_employee_profile
      hr_employee_profile.administrator = false
      hr_employee_profile.supervisor_id = 0
      true
    end
  end
end
