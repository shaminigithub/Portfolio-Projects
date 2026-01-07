-- 1
USE employee;

-- 3
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'DEPARTMENT'
FROM
    emp_record_table;

-- 4
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'DEPARTMENT',
    CASE
        WHEN EMP_RATING < 2 THEN 'Rating below 2'
        WHEN EMP_RATING > 4 THEN 'Rating Above 4'
        WHEN EMP_RATING BETWEEN 2 AND 4 THEN 'Rating between 2 and 4'
    END AS 'EMPLOYEE_RATING'
FROM
    emp_record_table;

-- 5
SELECT
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS 'NAME'
FROM
    emp_record_table;

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

-- 6
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

-- 7
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

-- 8
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

-- 9
SELECT
    SALARY
FROM
    emp_record_table
WHERE
    SALARY > 6000;

SELECT * FROM high_salary_employees_by_country;

-- 10
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

-- 11
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

-- 12
SELECT
    EMP_ID,
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS 'NAME',
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

-- 13
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

CALL GetExperiencedEmployees();

-- 14
DELIMITER //

CREATE FUNCTION GetStandardRole(exp INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE standard_role VARCHAR(30);

    IF exp <= 2 THEN
        SET standard_role = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp > 2 AND exp <= 5 THEN
        SET standard_role = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp > 5 AND exp <= 10 THEN
        SET standard_role = 'SENIOR DATA SCIENTIST';
    ELSEIF exp > 10 AND exp <= 12 THEN
        SET standard_role = 'LEAD DATA SCIENTIST';
    ELSEIF exp > 12 AND exp <= 16 THEN
        SET standard_role = 'MANAGER';
    ELSE
        SET standard_role = 'UNDEFINED';
    END IF;

    RETURN standard_role;
END //

DELIMITER ;

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

-- 15
CREATE INDEX idx_first_name
ON emp_record_table(FIRST_NAME(20));

EXPLAIN
SELECT *
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

-- 16
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    (0.05 * SALARY * EMP_RATING) AS BONUS
FROM
    emp_record_table;

-- 17
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
