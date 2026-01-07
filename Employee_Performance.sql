
-- ---------------------------------------------------------------
-- 1. Select the employee database
-- ---------------------------------------------------------------
USE employee;


-- ---------------------------------------------------------------
-- 2. Fetch basic employee details with department alias
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS DEPARTMENT
FROM
    emp_record_table;


-- ---------------------------------------------------------------
-- 3. Categorize employees based on performance rating
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS DEPARTMENT,
    CASE
        WHEN EMP_RATING < 2 THEN 'Rating below 2'
        WHEN EMP_RATING > 4 THEN 'Rating above 4'
        WHEN EMP_RATING BETWEEN 2 AND 4 THEN 'Rating between 2 and 4'
    END AS EMPLOYEE_RATING
FROM
    emp_record_table;


-- ---------------------------------------------------------------
-- 4. Display employee full name (trimmed)
-- ---------------------------------------------------------------
SELECT
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS NAME
FROM
    emp_record_table;


-- ---------------------------------------------------------------
-- 5. Fetch employees working in the Finance department
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'Finance';


-- ---------------------------------------------------------------
-- 6. Find number of reporters for each manager
-- ---------------------------------------------------------------
SELECT
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    COUNT(r.EMP_ID) AS NUM_OF_REPORTERS
FROM
    emp_record_table e
JOIN
    emp_record_table r
    ON e.EMP_ID = r.MANAGER_ID
GROUP BY
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE;


-- ---------------------------------------------------------------
-- 7. Fetch employees from Healthcare and Finance departments
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'Healthcare'

UNION

SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'Finance';


-- ---------------------------------------------------------------
-- 8. Fetch employees with their department's maximum rating
-- ---------------------------------------------------------------
SELECT
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    e.DEPT AS DEPARTMENT,
    e.EMP_RATING,
    d.MAX_DEPT_RATING
FROM
    emp_record_table e
JOIN (
    SELECT
        DEPT,
        MAX(EMP_RATING) AS MAX_DEPT_RATING
    FROM
        emp_record_table
    GROUP BY
        DEPT
) d
ON e.DEPT = d.DEPT;


-- ---------------------------------------------------------------
-- 9. Fetch salaries greater than 6000
-- ---------------------------------------------------------------
SELECT
    SALARY
FROM
    emp_record_table
WHERE
    SALARY > 6000;


-- ---------------------------------------------------------------
-- 10. Rank employees based on experience (descending order)
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    DEPT,
    EXP,
    RANK() OVER (ORDER BY EXP DESC) AS EXP_RANK
FROM
    emp_record_table;


-- ---------------------------------------------------------------
-- 11. Create a view for experienced employees with high salaries
-- ---------------------------------------------------------------
CREATE VIEW high_salary_employees_by_country AS
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    COUNTRY,
    ROLE,
    DEPT,
    EXP,
    SALARY
FROM
    emp_record_table
WHERE
    EXP > 3;


-- ---------------------------------------------------------------
-- 12. Fetch employees having more than 10 years of experience
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS NAME,
    ROLE,
    EXP
FROM
    emp_record_table
WHERE
    EMP_ID IN (
        SELECT
            EMP_ID
        FROM
            emp_record_table
        WHERE
            EXP > 10
    );


-- ---------------------------------------------------------------
-- 13. Stored procedure to get experienced employees
-- ---------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
    SELECT
        EMP_ID,
        FIRST_NAME,
        LAST_NAME,
        ROLE,
        DEPT,
        EXP,
        SALARY
    FROM
        emp_record_table
    WHERE
        EXP > 3;
END //

DELIMITER ;

-- Execute the stored procedure
CALL GetExperiencedEmployees();


-- ---------------------------------------------------------------
-- 14. Function to assign standard role based on experience
-- ---------------------------------------------------------------
DELIMITER //

CREATE FUNCTION GetStandardRole(exp INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE standard_role VARCHAR(30);

    IF exp <= 2 THEN
        SET standard_role = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp <= 5 THEN
        SET standard_role = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp <= 10 THEN
        SET standard_role = 'SENIOR DATA SCIENTIST';
    ELSEIF exp <= 12 THEN
        SET standard_role = 'LEAD DATA SCIENTIST';
    ELSEIF exp <= 16 THEN
        SET standard_role = 'MANAGER';
    ELSE
        SET standard_role = 'UNDEFINED';
    END IF;

    RETURN standard_role;
END //

DELIMITER ;


-- ---------------------------------------------------------------
-- 15. Validate assigned role vs standard role
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP,
    ROLE AS ASSIGNED_ROLE,
    GetStandardRole(EXP) AS STANDARD_ROLE,
    CASE
        WHEN ROLE = GetStandardRole(EXP) THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS STATUS
FROM
    Data_science_team;


-- ---------------------------------------------------------------
-- 16. Create index on FIRST_NAME for performance optimization
-- ---------------------------------------------------------------
CREATE INDEX idx_first_name
ON emp_record_table(FIRST_NAME(20));


-- ---------------------------------------------------------------
-- 17. Analyze query execution using EXPLAIN
-- ---------------------------------------------------------------
EXPLAIN
SELECT *
FROM
    emp_record_table
WHERE
    FIRST_NAME = 'Eric';


-- ---------------------------------------------------------------
-- 18. Calculate employee bonus based on salary and rating
-- ---------------------------------------------------------------
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    (0.05 * SALARY * EMP_RATING) AS BONUS
FROM
    emp_record_table;


-- ---------------------------------------------------------------
-- 19. Calculate average salary by continent and country
-- ---------------------------------------------------------------
SELECT
    CONTINENT,
    COUNTRY,
    ROUND(AVG(SALARY), 2) AS AVG_SALARY
FROM
    emp_record_table
GROUP BY
    CONTINENT,
    COUNTRY
ORDER BY
    CONTINENT,
    COUNTRY;
