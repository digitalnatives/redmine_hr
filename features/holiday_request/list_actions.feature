Feature: List Holiday Requests (actions)

  Background:
    Given I am logged in

  Scenario: Request
     When I have a planned holiday request
      And I visit the holiday requests page
      And I click on the request action
     Then There should be a cancel action

  Scenario: Cancel
     When I have a requested holiday request
      And I visit the holiday requests page
      And I click on the cancel action
     Then There should be a request action

  Scenario: Delete
     When I have a planned holiday request
      And I visit the holiday requests page
      And I click on the remove action
     Then I should see 0 holiday request items

  Scenario: Approve
     When I have a requested holiday request
      And I visit the holiday requests page
      And I click on the approve action
     Then There should be a withdraw action

  Scenario: Withdraw
     When I have a approved holiday request
      And I visit the holiday requests page
      And I click on the withdraw action
     Then There should be a approve_withdrawn action
     Then There should be a reject_withdrawn action

  Scenario: Approve Withdrawn
     When I have a withdrawn holiday request
      And I visit the holiday requests page
      And I click on the approve_withdrawn action
     Then There should be a approve_withdrawn action
     Then There should be a request action

  Scenario: Reject Withdraw
     When I have a withdrawn holiday request
      And I visit the holiday requests page
      And I click on the reject_withdrawn action
     Then There should be a approve_withdrawn action
     Then There should be a withdraw action
