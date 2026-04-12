# features/chat.feature
Feature: Real-time Chat
  As a buyer or seller
  I want to communicate in real time

  Scenario: Send and receive messages
    Given two users have a conversation
    When user A sends a message
    Then user B sees the message instantly via Action Cable