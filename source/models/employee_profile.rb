class EmployeeProfile < Fron::Model
  field :supervisor_id
  field :user_id
  field :administrator
  field :birth_date
  field :employment_date

  adapter Fron::Adapters::RailsAdapter, {
    endpoint: `window.location.origin`,
    resources: 'hr_employee_profiles',
    resource: 'hr_employee_profile'
  }

  def method_missing(method)
    @data[method]
  end

  def holiday_modifiers
    @data[:holiday_modifiers].map{|hr| HolidayModifier.new hr}
  end

  def employee_children
    @data[:employee_children].map{|hr| EmployeeChild.new hr}
  end

  def name
    self.user[:lastname] + " " + self.user[:firstname]
  end
end
