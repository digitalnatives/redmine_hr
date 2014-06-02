class EmployeeChild < Fron::Model
  field :name
  field :birth_date
  field :gender
  field :hr_employee_profile_id

  adapter Fron::Adapters::RailsAdapter, {
    endpoint: -> {
      `window.location.origin`+"/hr_employee_profiles/#{self.hr_employee_profile_id}"
    },
    resources: 'hr_employee_children',
    resource: 'hr_employee_child'
  }
end
