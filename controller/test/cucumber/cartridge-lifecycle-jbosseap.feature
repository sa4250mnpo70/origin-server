@runtime_extended
@runtime_extended2
@rhel-only
@not-fedora-19
@jboss
@jbosseap

Feature: Cartridge Lifecycle JBossEAP Verification Tests
  Scenario: Application Creation
    Given the libra client tools
    When 1 jbosseap-6.0 applications are created
    Then the applications should be accessible

  #Scenario: Application Modification
    Given an existing jbosseap-6.0 application
    When the application is changed
    Then it should be updated successfully
    And the application should be accessible

  #Scenario: Application Restarting
    When the application is restarted
    Then the application should be accessible

  #Scenario: Application Tidy
    When I tidy the application
    Then the application should be accessible

  #Scenario: Application Snapshot
    #Given an existing jbosseap-6.0 application, verify it can be snapshotted and restored
    When I snapshot the application
    Then the application should be accessible
    When a new file is added and pushed to the client-created application repo
    When I restore the application
    Then the application should be accessible
    And the new file will not be present in the gear app-root repo

  #Scenario: Application Destroying
    When the application is destroyed
    Then the application should not be accessible
