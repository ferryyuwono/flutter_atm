Feature: Home
    Scenario: Login
        Given Home page is shown
        When User send login command
        Then User sees login success with balance
