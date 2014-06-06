ActionController::Parameters.action_on_unpermitted_parameters = :raise
Rails.configuration.to_prepare do

  User.class_eval do
    has_one :hr_employee_profile
    before_create :build_default_hr_employee_profile

    def allowed_to_hr?
      return self.test_hr_access if defined? self.test_hr_access
      return false unless Setting.plugin_redmine_hr[:access]
      ids = Setting.plugin_redmine_hr[:access].reduce([]) { |memo,id| memo << Group.find(id.to_i).user_ids }.flatten
      ids.include?(id)
    end

    def role
      return self.test_role if defined? self.test_role
      return :user unless Setting.plugin_redmine_hr[:admin_group]
      ids = Setting.plugin_redmine_hr[:admin_group].reduce([]) { |memo,id| memo << Group.find(id.to_i).user_ids }.flatten
      return :admin if ids.include?(id)
      :user
    end

    def supervisor?
      HrEmployeeProfile.where(supervisor_id: id).count > 0
    end

    private

    # Create employee_profile automatically
    def build_default_hr_employee_profile
      build_hr_employee_profile
      hr_employee_profile.supervisor_id = 0
      true
    end
  end
end
