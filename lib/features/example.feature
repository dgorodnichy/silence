Feature: Example feature
  In order to learn more
  As an information seeker
  I want to find more information

  Background:
    Given I set "en" subdomain
  
  @known_bug
  Scenario: I go to google home page
    Given I go to the "Example" page
    Then I fill registration form

  @tag
  @tag2
  Scenario: Wrong wait_until
    Given I go to the "Example" page
    Then I wait wrong element
  
  @tag3
  Scenario: Broken page
    Given I open broken page
