Feature: Show Employee Profile

  Background:
    Given I am logged in

  Scenario: Included in the profile list
    Given There is a user
     When I visit the employee profiles page
     Then I should see 2 employee profile items

  Scenario: Not included in the profile list
    Given There is a user
      And It can't access the hr module
     When I visit the employee profiles page
     Then I should see 1 employee profile items

  Scenario: Show profile
    Given There is a user
     When I visit the employee profile page
     Then I should see the profile
