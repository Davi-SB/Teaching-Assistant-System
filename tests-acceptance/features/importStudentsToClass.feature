Feature: As a professor
         I want to enroll students in a class by uploading a spreadsheet file (.csv or .xlsx) containing their IDs
         So that I can quickly populate a large class without having to add each student manually.

Scenario: Import succeeds completely
    Given I am logged in as a teacher and on the "Class A" page, which has no enrolled students
    And the system has registered students with IDs "111" and "222"
    When I upload a file "alunos.xlsx" containing IDs "111" and "222"
    Then I am redirected to the "Success" screen
    And the screen shows the message "Import completed: 2 students were imported successfully and 0 were rejected"
    And when I return to the "Class A" student list, students "111" and "222" are listed

Scenario: Import into a non-empty class
    Given I am logged in as a teacher and on the "Class B" page
    And "Class B" already has the student with ID "111"
    And the system has a student with ID "222" who is not in "Class B"
    When I upload a file "novos_alunos.csv" containing IDs "111" (already in the class) and "222" (new)
    Then I am redirected to the "Success" screen
    And the screen shows the message "Import completed: 1 student was imported successfully and 0 were rejected"
    And the "Class B" student list now contains both students "111" and "222"