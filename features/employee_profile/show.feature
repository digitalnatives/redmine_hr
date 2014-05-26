Feature: Show employee profile

  Background:
    Given I am logged in
      And There is a user

  Scenario: Include profile in the list
     When I visit the employee profiles page
     Then I should see 2 employee profile items

  Scenario: Show profile
     When I visit the employee profile page
     Then I should see the profile
