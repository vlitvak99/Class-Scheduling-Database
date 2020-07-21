# Class Scheduling Database

### DESCRIPTION
- This is a database implementation for a University Scheduling System in IBM's DB2.

- It includes tables that store:
  - students (UNIVERSITY.STUDENT), which have an ID, a first name, and a last name
  - classes (UNIVERSITY.CLASS), which have a Class ID, a name, and a description
  - class requirements (UNIVERSITY.CLASSREQ), which have the Class ID, the Class ID of the prerequisite class, and a boolean determining whether or not the class is a prerequisite or a corequisite
  - student-class pairings (UNIVERSITY.SCHEDULE), which have the Student ID, the Class ID, Semester ('S' for Spring, 'M' for Summer, and 'F' for Fall), and the year
  - and a trigger (UNIVERSITY.PREREQ_CHECK), which does not allow rows to be added into UNIVERSITY.SCHEDULE if the student has not taken all the prerequisites of the class which is being added

- The line delimiter for this program is: `^`
<br>

### TESTING

The database was tested using the following classes and requirements:

| Class ID | Class Name | Prereq | Coreq  |
| :------: | :--------: | :----: | :----: |
| 10000    | CS46A      | None   | None   |
| 10001    | CS46B      | CS46A  | MATH46 |
| 10002    | CS47       | CS46B  | None   |
| 20000    | CS146      | CS46B  | None   |
| 20001    | CS157A     | CS146  | None   |
| 30000    | MATH46     | None   | None   |
