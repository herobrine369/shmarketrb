# features/product_management.feature
Feature: Product Management
  As a logged-in user
  I want to create, browse and manage my listings

  Background:
    Given I am a registered user
    And I am signed in

  Scenario: Create a new product listing
    When I visit the new product page
    And I fill in valid product details
    And I submit the form
    Then I should see the product on the marketplace

  Scenario: Search and filter products
    Given there are multiple products
    When I visit the product list page
    And I search for "lamp"
#    And I filter by category "electronics"
    Then I should only see matching products

  Scenario: View product details and request chat
    Given a product exists
    When I visit the product page
    And I click "Request"
    Then I should be redirected to the chat with the seller