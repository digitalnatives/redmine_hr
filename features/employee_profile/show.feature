Feature: Show employee profile

  Scenario: Include profile in the list
    Given I am logged in
      And There is a user
     When I visit the employee profiles page
     Then I should see 2 employee profile items

  Scenario: Show profile
	 	Given I am logged in
      And There is a user
     When I visit the employee profile page
     Then I should see the profile
