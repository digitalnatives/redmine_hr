Feature: Edit Holiday Request

  Background:
    Given I am logged in
      And I have a planned holiday request
     When I visit the edit holiday request page

  Scenario: Edit
     When I fill out the start date with "2014-01-03"
      And I fill out the end date with "2014-01-04"
  	  And I click on the save button
  	 Then I should be on the holiday request page

