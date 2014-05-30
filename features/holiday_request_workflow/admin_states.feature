Feature: Holiday Request States (Admin)

  Background:
    Given I am logged in

  Scenario: Planned state
    Given I have a planned holiday request
     When I visit the holiday request page
     Then I should be able to edit the holiday request
     Then There should be 2 buttons
      And There should be a request button
      And There should be a remove button

  Scenario: Requested state
    Given I have a requested holiday request
     When I visit the holiday request page
     Then I should be able to edit the holiday request
     Then There should be 4 buttons
      And There should be a cancel button
      And There should be a approve button
      And There should be a reject button
      And There should be a remove button

   Scenario: Rejected state
    Given I have a rejected holiday request
     When I visit the holiday request page
     Then I should be able to edit the holiday request
     Then There should be 1 buttons
      And There should be a approve button

  Scenario: Approved state
    Given I have a approved holiday request
     When I visit the holiday request page
     Then I should be able to edit the holiday request
     Then There should be 2 buttons
      And There should be a withdraw button
      And There should be a reject button

  Scenario: Withdrawn state
    Given I have a withdrawn holiday request
     When I visit the holiday request page
     Then I should be able to edit the holiday request
     Then There should be 2 buttons
      And There should be a approve_withdrawn button
      And There should be a reject_withdrawn button
