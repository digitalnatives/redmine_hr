Feature: Edit Holiday Request

  Background:
    Given I am logged in
      And I have a holiday request
     When I visit the edit holiday request page

  Scenario: Edit status
  	 When I fill out the status with "requested"
  	  And I click on the save button
  	 Then I should be on the holiday request page

