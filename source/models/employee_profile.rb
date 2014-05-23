class EmployeeProfile < Fron::Model
  field :supervisor_id
  field :user_id
  field :administrator

  adapter Fron::Adapters::RailsAdapter, {
    endpoint: `window.location.origin`,
    resources: 'hr_employee_profiles',
    resource: 'hr_employee_profile'
  }

  def supervisor
    @data[:supervisor]
  end

  def user
    @data[:user]
  end

  def name
    self.user[:lastname] + " " + self.user[:firstname]
  end
end
