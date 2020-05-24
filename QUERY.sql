/*
    Desplegar total de salarios agrupados por job, solo de Programmer y todos los tipos de clerk (Purchasing Clerk, Shipping Clerk, Stock Clerk).
    Mostrar subtotales por job y el total general.
*/

SELECT 
    *
FROM 
    HR.EMPLOYEES E;

SELECT 
    SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
GROUP BY E.SALARY;

SELECT 
    E.JOB_ID, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
GROUP BY E.JOB_ID, E.SALARY;

SELECT 
    E.JOB_ID, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
GROUP BY E.JOB_ID
ORDER BY E.JOB_ID ASC;

SELECT 
    E.JOB_ID, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
GROUP BY E.JOB_ID, E.SALARY;

SELECT 
    E.JOB_ID, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
GROUP BY E.JOB_ID
HAVING
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
ORDER BY E.JOB_ID ASC;


SELECT 
    *
FROM 
    HR.JOBS;

SELECT 
    MAX(J.JOB_TITLE) TITLE, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY 
    E.JOB_ID
ORDER BY 
    E.JOB_ID ASC;
    
SELECT 
    MAX(J.JOB_TITLE) TITLE, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY 
    E.JOB_ID
HAVING
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
ORDER BY 
    E.JOB_ID ASC;
    
SELECT 
    MAX(J.JOB_TITLE) TITLE, MAX(FIRST_NAME) EMPLOYEE, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY CUBE
    (E.JOB_ID, E.SALARY)
HAVING
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
ORDER BY 
    E.JOB_ID ASC;
    
SELECT 
    MAX(J.JOB_TITLE) TITLE, MAX(FIRST_NAME) EMPLOYEE, SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY CUBE
    (E.JOB_ID, E.SALARY)
HAVING
--    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE 'PU_CLERK'
ORDER BY 
    E.JOB_ID ASC;
    
SELECT 
    MAX((SELECT JOB_TITLE FROM HR.JOBS WHERE J.JOB_ID = JOB_ID)) TITLE, 
    MAX((SELECT FIRST_NAME FROM HR.EMPLOYEES WHERE E.EMPLOYEE_ID = EMPLOYEE_ID)) EMPLOYEE, 
    SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY ROLLUP
    (E.JOB_ID, E.SALARY)
HAVING
--    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE 'PU_CLERK'
ORDER BY 
    E.JOB_ID ASC;
    
    
SELECT 
    MAX((SELECT JOB_TITLE FROM HR.JOBS WHERE J.JOB_ID = JOB_ID)) TITLE, 
    MAX((SELECT FIRST_NAME FROM HR.EMPLOYEES WHERE E.EMPLOYEE_ID = EMPLOYEE_ID)) EMPLOYEE, 
    SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY ROLLUP
    (E.JOB_ID, E.SALARY)
HAVING
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
--    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE 'PU_CLERK'
ORDER BY 
    E.JOB_ID ASC;
    
SELECT 
    MAX((SELECT JOB_TITLE FROM HR.JOBS WHERE J.JOB_ID = JOB_ID)) TITLE, 
    MAX((SELECT FIRST_NAME FROM HR.EMPLOYEES WHERE E.EMPLOYEE_ID = EMPLOYEE_ID)) EMPLOYEE, 
    SUM(E.SALARY) TOTAL,
    GROUPING(E.SALARY) GROUPING_VALUE
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY ROLLUP
    (E.JOB_ID, E.SALARY)
HAVING
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
--    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE 'PU_CLERK'
ORDER BY 
    E.JOB_ID ASC;


------ Without cursor solution
SELECT 
    CASE GROUPING(E.SALARY)
    WHEN 0 THEN MAX((SELECT JOB_TITLE FROM HR.JOBS WHERE J.JOB_ID = JOB_ID))
    WHEN 1 THEN NULL
    END TITLE,
    CASE GROUPING(E.SALARY)
    WHEN 0 THEN MAX((SELECT FIRST_NAME FROM HR.EMPLOYEES WHERE E.EMPLOYEE_ID = EMPLOYEE_ID))
    WHEN 1 THEN 'Subtotal'
    END EMPLOYEE,
    SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY ROLLUP
    (E.JOB_ID, E.SALARY)
HAVING
    E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
   
UNION ALL

SELECT 
    NULL TITLE,
    'Grand Total' EMPLOYEE, 
    SUM(TEMP.TOTAL) TOTAL
FROM    
(
    SELECT 
        MAX((SELECT JOB_TITLE FROM HR.JOBS WHERE J.JOB_ID = JOB_ID)) TITLE, 
        MAX((SELECT FIRST_NAME FROM HR.EMPLOYEES WHERE E.EMPLOYEE_ID = EMPLOYEE_ID)) EMPLOYEE, 
        SUM(E.SALARY) TOTAL,
        GROUPING(E.SALARY) GROUPING_VALUE
    FROM 
        HR.EMPLOYEES E
    INNER JOIN
        HR.JOBS J
    ON E.JOB_ID = J.JOB_ID
    GROUP BY ROLLUP
        (E.JOB_ID, E.SALARY)
    HAVING
          E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK'
    ORDER BY 
        E.JOB_ID ASC
) TEMP
WHERE
    TEMP.GROUPING_VALUE = 1;


------ Cursor solution
SET SERVEROUTPUT ON;

DECLARE
CURSOR cursor_employees_01 IS 
SELECT 
    CASE GROUPING(E.SALARY)
    WHEN 0 THEN MAX((SELECT JOB_TITLE FROM HR.JOBS WHERE J.JOB_ID = JOB_ID))
    WHEN 1 THEN ' '
    END TITLE,
    CASE GROUPING(E.SALARY)
    WHEN 0 THEN MAX((SELECT FIRST_NAME FROM HR.EMPLOYEES WHERE E.EMPLOYEE_ID = EMPLOYEE_ID))
    WHEN 1 THEN 'Subtotal'
    END EMPLOYEE,
    SUM(E.SALARY) TOTAL
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.JOBS J
ON E.JOB_ID = J.JOB_ID
GROUP BY ROLLUP
    (E.JOB_ID, E.SALARY)
    HAVING
        E.JOB_ID = 'IT_PROG' OR E.JOB_ID LIKE '%_CLERK';
-- title VARCHAR2(100);
-- employee VARCHAR2(100);
-- subtotal NUMBER(8,0);
title HR.JOBS.JOB_TITLE%type;
employee HR.EMPLOYEES.FIRST_NAME%type;
subtotal HR.EMPLOYEES.SALARY%type;
total NUMBER(8,0);

BEGIN

total := 0;
OPEN cursor_employees_01;

Dbms_output.put_line('');
-- Dbms_output.put_line('Title     Employee        Total');
Dbms_output.put_line(RPAD('Title',20) || RPAD('Employee' ,20) || RPAD('Total' ,10));
Dbms_output.put_line('');
LOOP
FETCH cursor_employees_01 INTO title, employee, subtotal;

IF cursor_employees_01%NOTFOUND THEN
    EXIT;
END IF;

IF title <> ' ' THEN
    total := total + subtotal;
END IF;

-- Dbms_output.put_line(title || '      ' || employee || '        ' || subtotal);
Dbms_output.put_line(RPAD(title,20) || RPAD(employee ,20) || RPAD(subtotal ,10));

-- Dbms_output.put_line('Job Fetched:' || title);
-- Dbms_output.put_line('Employee Fetched:' || employee);
-- Dbms_output.put_line('Subtotal Fetched:' || subtotal);
END LOOP;
-- Dbms_output.put_line('Grand Total:' || RPAD(total,20));
Dbms_output.put_line(RPAD(' ',20) || RPAD('Grand Total' ,20) || RPAD(total ,10));

CLOSE cursor_employees_01;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('No data was found - '||SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('An error was encountered - '||SQLERRM);
END;
/


/*
    Desplegar employees cuya commision sea null .
*/

SELECT 
    *
FROM 
    HR.EMPLOYEES E;
    
SELECT 
    *
FROM 
    HR.DEPARTMENTS;
    
SELECT 
    *
FROM 
    HR.EMPLOYEES E
WHERE E.COMMISSION_PCT IS NULL;

------ Without cursor solution
SELECT 
    E.FIRST_NAME EMPLOYEE,
    D.DEPARTMENT_NAME DEPARTMENT
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.DEPARTMENTS D
ON
    E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.COMMISSION_PCT IS NULL
ORDER BY
    D.DEPARTMENT_NAME ASC;

------ Cursor solution
SET SERVEROUTPUT ON;

DECLARE
CURSOR cursor_employees_02 IS 
SELECT 
    E.FIRST_NAME EMPLOYEE,
    D.DEPARTMENT_NAME DEPARTMENT
FROM 
    HR.EMPLOYEES E
INNER JOIN
    HR.DEPARTMENTS D
ON
    E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.COMMISSION_PCT IS NULL
ORDER BY
    D.DEPARTMENT_NAME ASC;
employee HR.EMPLOYEES.FIRST_NAME%type;
department HR.DEPARTMENTS.DEPARTMENT_NAME%type;

BEGIN

OPEN cursor_employees_02;

Dbms_output.put_line('');
Dbms_output.put_line(RPAD('Employee' ,20) || RPAD('Department' ,20));
Dbms_output.put_line('');
LOOP
FETCH cursor_employees_02 INTO employee, department;

IF cursor_employees_02%NOTFOUND THEN
    EXIT;
END IF;

Dbms_output.put_line(RPAD(employee ,20) || RPAD(department ,20));

END LOOP;

CLOSE cursor_employees_02;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('No data was found - '||SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('An error was encountered - '||SQLERRM);
END;
/
