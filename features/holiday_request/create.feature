Feature: Create Holiday Request

  Background:
    Given I am logged in
     When I visit the new holiday request page

  Scenario: Missing fields
     When I click on the create button
     Then I should get 2 error messages

  Scenario: Wrong dates
     When I fill out the start date with "2014-01-02"
      And I fill out the end date with "2014-01-01"
     When I click on the create button
     Then I should get 1 error message

  Scenario: Half day change
     When I fill out the start date with "2014-01-02"
      And I check half day
     Then The end date should equal "2014-01-02"
     Then The end date should be disabled
     When I uncheck half day
     Then The end date should not be disabled

  Scenario: Success
     When I fill out the start date with "2014-01-01"
      And I fill out the end date with "2014-01-02"
      And I fill out the status with "requested"
      And I fill out the type with "sick-leave"
      And I fill out the description with "test description"
      And I click on the create button
     Then I should be on the holiday request page
