Feature: List Holiday Requests

  Background:
    Given I am logged in
      And I have a planned holiday request
      And I have an approved holiday request for last year
      And Someone has a rejected holiday request
      And I visit the holiday requests page

  Scenario: List All
     Then I should see 3 holiday request items

  Scenario: Filter for year
     When I filter for the current year
     Then I should see 2 holiday request item

  Scenario: Filter for status
     When I filter for planned status
     Then I should see 1 holiday request item

  Scenario: Filter for user
     When I filter for myself
     Then I should see 2 holiday request items

  Scenario: Filter for supervisor
     When I filter for myself as supervisor
     Then I should see 1 holiday request items

  Scenario: My Holiday Requests
     Then I should see 3 holiday request items
     When I visit the my holiday requests page
     Then I should see 2 holiday request items
      And I should not be able to filter for user
      And I should not be able to filter for supervisor
