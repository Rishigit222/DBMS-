# Experiment 7: Database Normalization

## Aim

Given a denormalized student registration table, identify functional dependencies and normalize step-by-step from UNF to 1NF, 2NF, and 3NF. Verify lossless join decomposition and functional dependency preservation using SQL queries.

## Concepts Covered

- **Unnormalized Form (UNF)**: Redundant repeating data and vulnerability to insertion, update, and deletion anomalies.
- **First Normal Form (1NF)**: Ensuring all column attributes contain atomic values and every row is uniquely identifiable.
- **Second Normal Form (2NF)**: Eliminating partial functional dependencies on candidate keys by decomposing into `Students`, `Courses`, and `Registrations`.
- **Third Normal Form (3NF)**: Eliminating transitive dependencies (`course_id -> instructor_id -> instructor_name, department`) by isolating instructor details into an independent `Instructors` relation and referencing it from `Courses_3NF`.
- **BCNF Relationship**: In the resulting 3NF decomposition, all functional determinants (`student_id`, `course_id`, `instructor_id`) are candidate keys in their respective relations. Hence, the schema inherently satisfies Boyce-Codd Normal Form (BCNF) without requiring additional decomposition steps.
- **Lossless Join Decomposition**: Verifying that reconstructing the original relation via `JOIN` operations reproduces the original dataset without loss of information or generation of spurious tuples.
- **Functional Dependency Preservation**: Verifying through aggregation queries that all identified functional dependencies are maintained within individual relations.

## Database Objects / Implementation

- `Registration_UNF`: Unnormalized relation containing student, course, instructor, and registration details.
- `Registration_1NF`: Relational table ensuring atomic values.
- `Students`: `student_id` (PK), `student_name`.
- `Courses`: Intermediate 2NF table containing `course_id` (PK), `course_name`, `instructor_id`, `instructor_name`, and `department`.
- `Registrations`: Associative table linking `student_id` (FK) and `course_id` (FK) with `registration_id` (PK), `semester`, and `grade`.
- `Instructors`: 3NF table storing `instructor_id` (PK), `instructor_name`, and `department`.
- `Courses_3NF`: 3NF table storing `course_id` (PK), `course_name`, and foreign key `instructor_id` referencing `Instructors`.

## SQL Operations Performed

1. **Table Creation & Initial Population**: Populated `Registration_UNF` with sample records representing students, courses, instructors, and assigned grades.
2. **Data Anomaly Note & Transparent Resolution**: In the raw lab data, registration `506` assigned `student_id = 101` to `'Aarav Sharma'`, while registration `501` assigned `student_id = 101` to `'Ankan Bhattacharjee'`. This conflict represents a data anomaly violating `student_id -> student_name` that triggers a primary key duplicate collision (`Error 1062`) during decomposition. The script updates registration `506` to `student_id = 106` to preserve all tuples cleanly while adhering to the 5-row output pattern shown in the original submission.
3. **1NF Transformation**: Cloned into `Registration_1NF` confirming flat atomic structure.
4. **2NF Decomposition**: Created `Students`, `Courses`, and `Registrations` with appropriate primary and foreign key constraints using `SELECT DISTINCT`.
5. **3NF Decomposition**: Decomposed `Courses` into `Instructors` and `Courses_3NF` to remove transitive dependencies on instructor attributes.
6. **Lossless Join Query**: Joined `Registrations`, `Students`, `Courses_3NF`, and `Instructors` to verify exact record reconstruction.
7. **Dependency Preservation Checks**: Executed `GROUP BY ... HAVING COUNT(...) > 1` queries to prove that no functional dependencies are violated.
8. **Final Projection**: Produced the clean denormalized business view via relational join.

## Execution Instructions

Run from the repository root:

```bash
mysql -u <username> -p < experiment-7/experiment_7.sql
```

The script independently creates and initializes the `NormalizationDB` database.

## Expected Results

- Clean decomposition into four normalized tables (`Students`, `Instructors`, `Courses_3NF`, and `Registrations`).
- Lossless join query reconstructs all registration records with accurate student and instructor mappings without spurious tuples.
- Dependency preservation verification queries return zero rows, confirming total dependency preservation across all relations.

## Files Included

- [SQL source](./experiment_7.sql)
- [Original submission](./dbms_exp_7.pdf)
