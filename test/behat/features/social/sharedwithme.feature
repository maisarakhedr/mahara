@javascript @core @core_view @core_portfolio
Feature: The "Portfolio -> Shared with me" screen

In order to be able to see the Pages & Collections that have been shared with me

Background:
    Given the following "users" exist:
      | username | password | email | firstname | lastname | institution | authname | role |
      | UserA | Kupuhipa1 | UserA@example.org | Angela | User | mahara | internal | member |
      | UserB | Kupuhipa1 | UserB@example.org | Bob | User | mahara | internal | member |
      | UserC | Kupuhipa1 | UserC@example.org | Cecilia | User | mahara | internal | member |

    And the following "groups" exist:
      | name | owner | description | grouptype | open | invitefriends | editroles |
      | GroupA | UserC | GroupA owned by UserC | standard | ON | OFF | all |

    And the following "pages" exist:
      | title | description | ownertype | ownername |
      | Page UserA_01 | Page 01 | user | UserA |
      | Page UserA_02 | Page 02 | user | UserA |
      | Page UserA_03 | Page 03 | user | UserA |
      | Page mahara_01 | Institution page | institution | mahara |
      | Page GroupA_01 | GroupA page | group | GroupA |

    And the following "collections" exist:
      | title | description | ownertype | ownername | pages |
      | Collection UserA_01 | Collection 01 | user | UserA | Page UserA_01, Page UserA_02 |

    And the following "permissions" exist:
      | title | accesstype | accessname | allowcomments |
      | Collection UserA_01 | user | UserB | 1 |
      | Page UserA_03 | user | UserB | 1 |
      | Page mahara_01 | loggedin | loggedin | 1 |
      | Page GroupA_01 | loggedin | loggedin | 1 |

Scenario: Testing that views & collections are collated properly
    # Putting some comments on the pages
    Given I log in as "UserA" with password "Kupuhipa1"
    And I choose "Pages and collections" in "Portfolio" from main menu
    And I click on "Collection UserA_01" panel collection
    And I click on "Page UserA_01" in "Collection UserA_01" panel collection
    And I fill in "I am on UserA_01 page" in editor "Comment"
    And I press "Comment"

    And I choose "Pages and collections" in "Portfolio" from main menu
    And I click on "Collection UserA_01" panel collection
    And I click on "Page UserA_02" in "Collection UserA_01" panel collection
    And I fill in "I am on UserA_02 page" in editor "Comment"
    And I press "Comment"

    And I choose "Pages and collections" in "Portfolio" from main menu
    And I click the panel "Page UserA_03"
    And I fill in "I am on Page UserA_03" in editor "Comment"
    And I press "Comment"

    When I log out
    And I log in as "UserB" with password "Kupuhipa1"
    And I choose "Shared with me" in "Portfolio" from main menu

    Then I should see "Page UserA_03"
    # I should see collections & individual pages
    And I should see "Collection UserA_01 (2 pages)"
    # I should not see pages in collections
    And I should not see "Page UserA_02"
    # I should see the latest comment from Collection UserA_01 only
    And I should see "I am on UserA_02 page"
    And I should not see "I am on UserA_01 page"
    And I should see "I am on Page UserA_03"

    # Allow user to see institution/group pages
    When I check "Registered users"
    And I press "Search"
    Then I should see "Page mahara_01"
    And I should see "Page GroupA_01"