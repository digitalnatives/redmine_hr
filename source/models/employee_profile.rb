class HolidayModifier < Fron::Model
  field :year
  field :description
  field :value
  field :hr_employee_profile_id

  adapter Fron::Adapters::RailsAdapter, {
    endpoint: -> {
      `window.location.origin`+"/hr_employee_profiles/#{self.hr_employee_profile_id}"
    },
    resources: 'hr_holiday_modifiers',
    resource: 'hr_holiday_modifier'
  }

end

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

  def holiday_modifiers
    @data[:holiday_modifiers].map{|hr| HolidayModifier.new hr}
  end

  def name
    self.user[:lastname] + " " + self.user[:firstname]
  end
end
