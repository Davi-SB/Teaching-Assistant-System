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

Scenario: Import with an empty file
    Given I am logged in as a teacher and on the student import page
    When I try to upload a file "planilha_vazia.xlsx" that contains no data rows
    Then I am redirected to the "Error case" screen
    And the screen shows the error message: "The uploaded file is empty or not supported (only .xlsx or .csv allowed). Please upload a file with valid registration numbers."

Scenario: Import with an invalid extension
    Given I am logged in as a teacher and on the student import page
    When I try to upload a file named "alunos.txt"
    Then I am redirected to the "Error case" screen
    And the screen shows the error message: "The uploaded file is empty or not supported (only .xlsx or .csv allowed). Please upload a file with valid registration numbers."

Scenario: Partial import — registration not found in the student registry
    Given I am logged in as a teacher and on the "Class C" page
    And the system has the student with ID "111" but no student with ID "999"
    When I upload a file "alunos.csv" containing ID "111" on row 1, ID "999" on row 2, and "222" on row 3
    Then I am redirected to the "Partial import" screen
    And the screen shows the summary "2 students imported successfully and 1 student rejected"
    And the screen shows the rejected list: "Row 2: Registration '999' not found in the student registry."
    And "Class C" now has students "111" and "222" enrolled

Scenario: Partial import — blank registration
    Given I am logged in as a teacher and on the "Class D" page
    And the system has the student with ID "111"
    When I upload a file "alunos.xlsx" where row 1 has a blank registration cell and row 2 contains ID "111"
    Then I am redirected to the "Partial import" screen
    And the screen shows the summary "1 student imported successfully and 1 student rejected"
    And the screen shows the rejected list: "Row 1: Blank registration number."
    And "Class D" now has student "111" enrolled

Scenario: Import would exceed the class capacity
    Given I am logged in as a teacher and on the "Class E" page
    And "Class E" has a limit of 50 seats and already has 48 enrolled students
    And the system has students with IDs "111", "222", and "333"
    When I upload a file "alunos.csv" containing these 3 new IDs
    Then I am redirected to the "Capacity limit would be exceeded" screen
    And the screen shows the error message: "Import failed. Adding 3 students would exceed the class limit of 50 seats."
    And the "Class E" student list remains with 48 students
