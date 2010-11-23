Feature: Find locations from user information
  In order to use our itinerary services
  An user
  wants to find location from an input string
  
  Scenario: Match exact name
    Given the location "rue jean jaurès" exists
    When I search "rue jean jaurès"
    Then that location should be selected

  Scenario: Match a word exactly
    Given the location "rue jean jaurès" exists
    When I search "jean"
    Then that location should be selected

  Scenario: Unmatch when no word machs
    Given the location "rue jean jaurès" exists
    When I search "avenue de paris"
    Then that location should not be selected

  Scenario: Match a word phonetically
    Given the location "rue jean jaurès" exists
    When I search "rhu gean joresse"
    Then that location should be selected

  Scenario: Prefer locations where more words match
    Given the location "rue jean mermoz" exists
    And a another location "avenue jean jaurès" exists
    When I search "rue jean mermoz"
    Then that location should be selected first

  Scenario Outline: Support common abbreviations
    Given the location "<word> albert" exists
    When I search "<abbreviation> albert"
    Then that location should be selected first
  Examples:
    | abbreviation | word        |
    | st           | saint       |
    | ste          | sainte      |
    | r            | rue         |
    | boul         | boulevard   |
    | bd           | boulevard   |
    | av           | avenue      |
    | fb           | faubourg    |
    | mt           | mont        |
    | pl           | place       |
    | imp          | impasse     |
    | rte          | route       |
    | sq           | square      |
    | pte          | porte       |
    | esc          | escalier    |
    | gal          | general     |

  Scenario: Prefer location where the location matchs
    Given a location "rue jean mermoz" exists in "boulogne"
    And a another location "rue jean mermoz" exists in "clichy"
    And the location "rue jean mermoz" exists in "paris"
    When I search "rue jean mermoz paris"
    Then that location should be selected first

  Scenario Outline: Support numerical expressions
    Given the location "rue du 21 siecle" exists
    When I search "truc <expression>"
    Then that location should be selected
  Examples: 
    | expression      |
    | 21              |
    | XXI             |
    | XXIe            |
    | XXIeme          |
    | vingt-et-unième |
    | 21e             |
    | 21eme           |
    | vingt et un     |
