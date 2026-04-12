# features/admin/product_moderation.feature
Feature: Admin Product Moderation
  As an admin
  I want to manage all listings

  Scenario: Update product status
    Given I am signed in as admin
    And a product exists
    When I change a product's state to "sold"
    Then the status is updated immediately