Feature: Edit Holiday Request

  Scenario: Can't create for other users
    Given I am logged in as a normal user
     When I visit the new holiday request page
     Then The hr_employee_profile_id should be disabled
      And The hr_employee_profile_id should equal "1"

  Scenario: Admin can create for other users
    Given I am logged in
      And There is a user
     When I visit the new holiday request page
     Then The hr_employee_profile_id should not be disabled
      And The hr_employee_profile_id field should have 2 options

