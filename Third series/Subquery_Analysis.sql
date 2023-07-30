/************************** 1. การวิเคราะห์ข้อมูลโดยใช้ Sub-query **************************/

-- เลือกเอาข้อมูลหมายเลขแผนกและชื่อแผนกจากตาราง DEPARTMENTS
-- และเอาเฉพาะแถวที่มีหมายเลขแผนกอยู่ในเงื่อนไขที่ระบุในตาราง EMPLOYEES
SELECT DEPARTMENT_ID, DEPARTMENT_NAME 
FROM DEPARTMENTS
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID 
                        FROM EMPLOYEES);

                        
-- เลือกเอา DEPARTMENTS ที่ไม่ซ้ำกัน โดยเชื่อม Table EMPLOYEES และ DEPARTMENTS เข้าด้วยกัน            
SELECT DISTINCT DEPARTMENTS.DEPARTMENT_ID,
DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEES JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;


-- เลือกพนักงานทั้งหมด
-- โดยมีเงื่อนไข 3 เงื่อนไข
-- 1.ต้องอยู่แผนก Marketing
-- 2.ต้องมีอาชีพ Marketing Representative
-- 3.เงินเดือน <= 6000

SELECT * FROM EMPLOYEES 
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME = 'Marketing') 
AND JOB_ID = (SELECT JOB_ID 
              FROM JOBS 
              WHERE JOB_TITLE = 'Marketing Representative')
AND SALARY <= 6000;


/************************** 2. การแสดงข้อมูลพนักงานพร้อมชื่อแผนกและเมืองที่มีเมือง = 'Roma' **************************/

-- แสดงเลข ID ของพนักงาน ,ชื่อ,แผนก,เมืองที่อยู่จากการ join ตาราง EMPLOYEES ,DEPARTMENTS และ LOCATION 
-- และมีเงื่อนไขว่า City จากตาราง LOCATION ต้องเป็น Roma หรือ Venice หรือ Southlake
SELECT EMPLOYEES.EMPLOYEE_ID,
  EMPLOYEES.FIRST_NAME,
  DEPARTMENTS.DEPARTMENT_NAME,
  LOCATIONS.CITY
FROM EMPLOYEES
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
JOIN LOCATIONS
ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
AND CITY                  IN ('Roma', 'Venice', 'Southlake')
ORDER BY EMPLOYEES.EMPLOYEE_ID;


--แสดงรายการพนักงานทั้งหมดพร้อมกับชื่อแผนกและเมืองที่เมือง = 'Roma' หรือ 'Venice' หรือ 'Southlake'
SELECT EMPLOYEES.EMPLOYEE_ID,
  EMPLOYEES.FIRST_NAME,
  DEPARTMENTS.DEPARTMENT_NAME,
  LOCATIONS.CITY
FROM EMPLOYEES
LEFT JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
LEFT JOIN LOCATIONS
ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
AND CITY                  IN ('Roma', 'Venice', 'Southlake')
ORDER BY EMPLOYEES.EMPLOYEE_ID;


--แสดงรายการพนักงานทั้งหมดพร้อมกับชื่อแผนกและเมืองที่เมือง = 'Roma' หรือ 'Venice' หรือ 'Southlake'
--หมายเหตุ: รายละเอียดของแผนกและเมืองจะแสดงเฉพาะถ้าเมืองเป็น 'Roma' หรือ 'Venice' หรือ 'Southlake'
SELECT EMPLOYEES.EMPLOYEE_ID,
  EMPLOYEES.FIRST_NAME,
  DEPT_CITY.DEPARTMENT_NAME,
  DEPT_CITY.CITY
FROM EMPLOYEES
LEFT JOIN
  (SELECT DEPARTMENTS.DEPARTMENT_ID,
    DEPARTMENTS.DEPARTMENT_NAME,
    LOCATIONS.CITY
  FROM DEPARTMENTS
  JOIN LOCATIONS
  ON DEPARTMENTS.LOCATION_ID             = LOCATIONS.LOCATION_ID
  AND CITY                              IN ('Roma', 'Venice', 'Southlake')
  ) DEPT_CITY 
ON EMPLOYEES.DEPARTMENT_ID = DEPT_CITY.DEPARTMENT_ID
ORDER BY EMPLOYEES.EMPLOYEE_ID;


/************************** 3. ฟังก์ชันการรวมข้อมูล: Min, Max, Count, Sum, Avg **************************/

--หาเงินเดือนสูงสุดของพนักงาน
SELECT MAX(SALARY) AS MAX_SALARY FROM EMPLOYEES;

--แสดงรายชื่อพนักงานที่ได้รับเงินเดือนสูงสุด
SELECT * FROM EMPLOYEES
WHERE SALARY = (SELECT MAX(SALARY) AS MAX_SALARY FROM EMPLOYEES);


--หาเงินเดือนต่ำสุดของพนักงาน
SELECT MIN(SALARY) AS MIN_SALARY FROM EMPLOYEES;

--แสดงรายชื่อพนักงานที่ได้รับเงินเดือนต่ำสุด
SELECT * FROM EMPLOYEES
WHERE SALARY = (SELECT MIN(SALARY) AS MAX_SALARY FROM EMPLOYEES);


--หายอดเงินเดือนรวมทั้งหมดของพนักงาน
SELECT SUM(SALARY) AS SUM_OF_SALARY FROM EMPLOYEES;


--หาค่าเฉลี่ยเงินเดือนของพนักงาน
SELECT ROUND(AVG(SALARY), 2) AS SUM_OF_SALARY FROM EMPLOYEES;

--แสดงรายชื่อพนักงานที่ได้รับเงินเดือนมากกว่าเงินเดือนเฉลี่ย
SELECT * FROM EMPLOYEES
WHERE SALARY > (SELECT ROUND(AVG(SALARY), 2) AS SUM_OF_SALARY FROM EMPLOYEES)
ORDER BY SALARY;

--หาจำนวนพนักงานทั้งหมด
SELECT COUNT(*) FROM EMPLOYEES;


--หาเงินเดือนสูงสุดและจำนวนพนักงานที่ทำงานในแผนก IT และเข้าทำงานหลังจาก 29-Nov-1990
SELECT MAX(SALARY) AS "MAX_SALARY_OF_IT", COUNT(*) AS "NUMBER_OF_EMP_IN_IT"
FROM EMPLOYEES
WHERE DEPARTMENT_ID =
  (SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
  WHERE DEPARTMENT_NAME = 'IT'
  )
AND HIRE_DATE > TO_DATE('29-NOV-1990', 'dd-MON-yyyy');


--หาเงินเดือนต่ำสุดและจำนวนพนักงานที่ทำงานในแผนก Finance และเข้าทำงานหลังจาก 29-Jan-1987
SELECT MIN(SALARY) AS "MIN_SALARY_OF_FINANCE", COUNT(*) AS "NUMBER_OF_EMP_IN_FINANCE"
FROM EMPLOYEES
WHERE DEPARTMENT_ID =
  (SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
  WHERE DEPARTMENT_NAME = 'Finance'
  )
AND HIRE_DATE > TO_DATE('29-JAN-1987', 'dd-MON-yyyy');


--หาเงินเดือนเฉลี่ยและจำนวนพนักงานที่ทำงานในแผนก Human Resources
SELECT ROUND(AVG(SALARY),2) AS "AVERAGE_SALARY_OF_HR", COUNT(*) AS "NUMBER_OF_EMP_IN_HR"
FROM EMPLOYEES
WHERE DEPARTMENT_ID =
  (SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
  WHERE DEPARTMENT_NAME = 'Human Resources'
  );

SELECT * FROM NON_FUNCTIONAL_LOCATIONS;

--เพิ่ม LOCATION ใหม่ในตาราง NON_FUNCTIONAL_LOCATIONS
INSERT INTO NON_FUNCTIONAL_LOCATIONS(LOCATION_ID, POSTAL_CODE, CITY, COUNTRY_ID)
VALUES((SELECT MAX(LOCATION_ID)+1 FROM NON_FUNCTIONAL_LOCATIONS), 40000, 'Mumbai', 'IN');

INSERT INTO NON_FUNCTIONAL_LOCATIONS(LOCATION_ID, POSTAL_CODE, CITY, COUNTRY_ID)
VALUES((SELECT MAX(LOCATION_ID)+1 FROM NON_FUNCTIONAL_LOCATIONS), 40001, 'xyz', 'IN');



/************************** 4. การรวมผลลัพธ์ที่รวมกันจากคำสั่งคำนวณข้อมูลในแถวต่างๆ **************************/ 
--------------------------------------------------------------------------------

--รวมผลลัพธ์ที่คำนวณได้ในแต่ละแถว
SELECT 'min_salary' as record_type, MIN(SALARY) AS "SALARY", COUNT(*) AS "NUMBER_OF_EMP_IN_FINANCE"
FROM EMPLOYEES
WHERE DEPARTMENT_ID =
  (SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
  WHERE DEPARTMENT_NAME = 'Finance'
  )
AND HIRE_DATE > TO_DATE('29-JAN-1987', 'dd-MON-yyyy')
UNION ALL
SELECT 'avg_salary', ROUND(AVG(SALARY),2) AS "SALARY", COUNT(*) AS "NUMBER_OF_EMP_IN_HR"
FROM EMPLOYEES
WHERE DEPARTMENT_ID =
  (SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
  WHERE DEPARTMENT_NAME = 'Human Resources'
  );

--รวมผลลัพธ์ที่คำนวณได้ในแถวเดียว
SELECT MAX(TOTAL_NUMBER_OF_EMPLOYEES) AS TOTAL_NUMBER_OF_EMPLOYEES,
  MAX(SUM_OF_SALARIES)      AS SUM_OF_SALARIES,
  MAX(MAX_SALARY_OF_IT)          AS MAX_SALARY_OF_IT,
  MAX(NUMBER_OF_EMP_IN_IT)       AS NUMBER_OF_EMP_IN_IT,
  MAX(MIN_SALARY_OF_FINANCE)     AS MIN_SALARY_OF_FINANCE,
  MAX(NUMBER_OF_EMP_IN_FINANCE)  AS NUMBER_OF_EMP_IN_FINANCE,
  MAX(AVERAGE_SALARY_OF_HR)      AS AVERAGE_SALARY_OF_HR,
  MAX(NUMBER_OF_EMP_IN_HR)       AS NUMBER_OF_EMP_IN_HR
FROM
  (
   SELECT SUM(SALARY) AS "SUM_OF_SALARIES",
    NULL              AS TOTAL_NUMBER_OF_EMPLOYEES,
    NULL              AS MAX_SALARY_OF_IT,
    NULL              AS NUMBER_OF_EMP_IN_IT,
    NULL              AS MIN_SALARY_OF_FINANCE,
    NULL              AS NUMBER_OF_EMP_IN_FINANCE,
    NULL              AS AVERAGE_SALARY_OF_HR,
    NULL              AS NUMBER_OF_EMP_IN_HR
  FROM EMPLOYEES
  UNION ALL
  SELECT NULL,
    COUNT(*) AS "TOTAL_NUMBER_OF_EMPLOYEES",
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  FROM EMPLOYEES
  UNION ALL
  SELECT NULL,
    NULL,
    MAX(SALARY) AS "MAX_SALARY_OF_IT",
    COUNT(*)    AS "NUMBER_OF_EMP_IN_IT",
    NULL,
    NULL,
    NULL,
    NULL
  FROM EMPLOYEES
  WHERE DEPARTMENT_ID =
    (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = 'IT'
    )
  AND HIRE_DATE > TO_DATE('29-NOV-1990', 'dd-MON-yyyy')
  UNION ALL
  SELECT NULL,
    NULL,
    NULL,
    NULL,
    MIN(SALARY) AS "MIN_SALARY_OF_FINANCE",
    COUNT(*)    AS "NUMBER_OF_EMP_IN_FINANCE",
    NULL,
    NULL
  FROM EMPLOYEES
  WHERE DEPARTMENT_ID =
    (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = 'Finance'
    )
  AND HIRE_DATE > TO_DATE('29-JAN-1987', 'dd-MON-yyyy')
  UNION ALL
  SELECT NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    ROUND(AVG(SALARY),2) AS "AVERAGE_SALARY_OF_HR",
    COUNT(*)             AS "NUMBER_OF_EMP_IN_HR"
  FROM EMPLOYEES
  WHERE DEPARTMENT_ID =
    (SELECT DEPARTMENT_ID
    FROM DEPARTMENTS
    WHERE DEPARTMENT_NAME = 'Human Resources'
    )
  ) T;

  
/************************** 5. การวิเคราะห์ข้อมูลแยกตามแผนก **************************/

--แสดงเงินเดือนสูงสุดในแต่ละแผนก
SELECT DEPARTMENTS.DEPARTMENT_NAME,
  MAX(SALARY) AS "MAX_SALARY"
FROM EMPLOYEES
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID     = DEPARTMENTS.DEPARTMENT_ID
WHERE EMPLOYEES.DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENTS.DEPARTMENT_NAME;


--แสดงจำนวนพนักงานและเงินเดือนสูงสุดในแต่ละแผนก
SELECT DEPARTMENTS.DEPARTMENT_NAME,
  COUNT(*)    AS "NUMBER_OF_EMPLOYEES",
  MAX(SALARY) AS "MAX_SALARY",
  SUM(SALARY) AS "TOTAL_SALARY"
FROM EMPLOYEES
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID     = DEPARTMENTS.DEPARTMENT_ID
WHERE EMPLOYEES.DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENTS.DEPARTMENT_NAME;


--แสดงจำนวนแผนกตามสถานที่
SELECT LOCATIONS.CITY,
  COUNT(*) AS "NUMBER_OF_DEPT"
FROM DEPARTMENTS,
  LOCATIONS
WHERE LOCATIONS.LOCATION_ID = DEPARTMENTS.LOCATION_ID
GROUP BY LOCATIONS.CITY;


--แสดงจำนวนพนักงานที่ทำงานภายใต้ผู้จัดการแต่ละคนพร้อมกับรหัสพนักงานของผู้จัดการ
SELECT M.EMPLOYEE_ID AS "MANAGER'S_EMPLOYEE_ID",
  M.FIRST_NAME
  || ' '
  || M.LAST_NAME AS "MANAGER_NAME",
  COUNT(*)       AS "NUMBER_OF_EMP_WORKING_UNDER_MANAGER"
FROM EMPLOYEES E
JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID
GROUP BY M.EMPLOYEE_ID,
  M.FIRST_NAME
  || ' '
  || M.LAST_NAME;
  

/************************** 6. กรองและจัดระเบียนข้อมูลที่ผสานกันแล้ว **************************/

--แสดงจำนวนแผนกที่พนักงานลาออกแยกตามลำดับ
SELECT JOB_HISTORY.DEPARTMENT_ID,
  DEPARTMENTS.DEPARTMENT_NAME,
  COUNT(*) AS "NUMBER_OF_EMPLOYEES_RESIGNED"
FROM JOB_HISTORY
JOIN DEPARTMENTS
ON JOB_HISTORY.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
GROUP BY JOB_HISTORY.DEPARTMENT_ID,
  DEPARTMENTS.DEPARTMENT_NAME
HAVING COUNT(*) > 1
ORDER BY NUMBER_OF_EMPLOYEES_RESIGNED DESC;


--เหมือนกันกับวิวอินไลน์
SELECT *
FROM
  (SELECT JOB_HISTORY.DEPARTMENT_ID,
    DEPARTMENTS.DEPARTMENT_NAME,
    COUNT(*) AS "NUMBER_OF_EMPLOYEES_RESIGNED"
  FROM JOB_HISTORY
  JOIN DEPARTMENTS
  ON JOB_HISTORY.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
  GROUP BY JOB_HISTORY.DEPARTMENT_ID,
    DEPARTMENTS.DEPARTMENT_NAME
  ORDER BY NUMBER_OF_EMPLOYEES_RESIGNED DESC
  ) T
WHERE NUMBER_OF_EMPLOYEES_RESIGNED > 1;


--แสดงเงินเดือนสูงสุดในแต่ละแผนกที่เรียงลำดับโดยเงินเดือนสูงสุดควรมากกว่า 10000
SELECT DEPARTMENTS.DEPARTMENT_NAME,
  MAX(SALARY) AS "MAX_SALARY"
FROM EMPLOYEES
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID     = DEPARTMENTS.DEPARTMENT_ID
WHERE EMPLOYEES.DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENTS.DEPARTMENT_NAME
HAVING MAX(SALARY) > 10000
ORDER BY MAX_SALARY ASC,
  DEPARTMENT_NAME DESC;  
  
  
  
/************************** 7. แสดงรายละเอียดระดับแผนกโดยใช้คำสั่งคำนวณข้อมูลในแถวอินไลน์ **************************/ 


SELECT DEPARTMENTS.DEPARTMENT_ID,
  DEPARTMENT_NAME,
  EMPLOYEES.FIRST_NAME
  || ' '
  || EMPLOYEES.LAST_NAME AS MANAGER_NAME,
  LOCATIONS.CITY,
  MAX_SALARY,
  MIN_SALARY,
  AVG_SALARY,
  SUM_SALARY,
  NUMBER_OF_EMP,
  NUMBER_OF_EMP_RESIGNED
FROM DEPARTMENTS
LEFT JOIN EMPLOYEES
ON DEPARTMENTS.MANAGER_ID = EMPLOYEES.EMPLOYEE_ID
LEFT JOIN LOCATIONS
ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
LEFT JOIN
  (SELECT DEPARTMENT_ID,
    MAX(SALARY)           AS MAX_SALARY,
    MIN(SALARY)           AS MIN_SALARY,
    ROUND(AVG(SALARY), 2) AS AVG_SALARY,
    SUM(SALARY)           AS SUM_SALARY,
    COUNT(*)              AS NUMBER_OF_EMP
  FROM EMPLOYEES
  GROUP BY DEPARTMENT_ID
  ) DEPT_SAL_DET
ON DEPARTMENTS.DEPARTMENT_ID = DEPT_SAL_DET.DEPARTMENT_ID
LEFT JOIN
  (SELECT DEPARTMENT_ID,
    COUNT(*) AS NUMBER_OF_EMP_RESIGNED
  FROM JOB_HISTORY
  GROUP BY DEPARTMENT_ID
  ) EMP_RESIGNATION_DET
ON DEPARTMENTS.DEPARTMENT_ID = EMP_RESIGNATION_DET.DEPARTMENT_ID
ORDER BY DEPARTMENTS.DEPARTMENT_ID;



/************************** 8. การวิเคราะห์ข้อมูลโดยใช้คำสั่งคำนวณข้อมูลในแถวอินไลน์และคำนวณค่าสะสมในแต่ละแถว **************************/ 

--แสดงจำนวนพนักงานในแต่ละแผนก และรวมจำนวนพนักงานทั้งหมดจากแผนกแรกไปยังแผนกปัจจุบัน
SELECT DEPARTMENT_ID,
  DEPARTMENT_NAME,
  COUNT(*) AS "NUMBER_OF_EMPLOYEES",
  SUM(COUNT(*)) OVER(ORDER BY DEPARTMENT_ID) AS "CUMULATIVE_EMP_COUNT"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID,
  DEPARTMENT_NAME
ORDER BY DEPARTMENT_ID;



/************************** 9. การใช้รวมข้อมูลจากหลายตารางเข้าด้วยกัน **************************/

--แสดงรายการงานพร้อมชื่อแผนกและสถานที่
SELECT JOBS.JOB_TITLE,
  DEPARTMENTS.DEPARTMENT_NAME,
  LOCATIONS.CITY
FROM JOBS
JOIN EMPLOYEES
ON JOBS.JOB_ID               = EMPLOYEES.JOB_ID
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID   = DEPARTMENTS.DEPARTMENT_ID
JOIN LOCATIONS
ON DEPARTMENTS.LOCATION_ID   = LOCATIONS.LOCATION_ID
ORDER BY JOBS.JOB_TITLE;


--แสดงชื่อของพนักงานพร้อมกับชื่องาน และชื่อแผนก
SELECT EMPLOYEES.FIRST_NAME,
  EMPLOYEES.LAST_NAME,
  JOBS.JOB_TITLE,
  DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEES
JOIN JOBS
ON EMPLOYEES.JOB_ID          = JOBS.JOB_ID
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID   = DEPARTMENTS.DEPARTMENT_ID
ORDER BY EMPLOYEES.FIRST_NAME,
  EMPLOYEES.LAST_NAME;


--แสดงรายการงานพร้อมชื่อแผนก และข้อมูลของพนักงานที่ทำงานในแผนกนั้นๆ
SELECT JOBS.JOB_TITLE,
  DEPARTMENTS.DEPARTMENT_NAME,
  EMPLOYEES.FIRST_NAME,
  EMPLOYEES.LAST_NAME,
  EMPLOYEES.HIRE_DATE,
  EMPLOYEES.SALARY
FROM JOBS
JOIN EMPLOYEES
ON JOBS.JOB_ID               = EMPLOYEES.JOB_ID
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID   = DEPARTMENTS.DEPARTMENT_ID
ORDER BY DEPARTMENTS.DEPARTMENT_NAME,
  JOBS.JOB_TITLE,
  EMPLOYEES.FIRST_NAME,
  EMPLOYEES.LAST_NAME;


/************************** 10. การรวมข้อมูลและการใช้งานคำสั่ง JOIN **************************/

-- แสดงรายการพนักงานพร้อมชื่อแผนก และข้อมูลของพนักงานที่ทำงานในแผนก IT โดยใช้คำสั่ง JOIN
SELECT EMPLOYEES.FIRST_NAME,
  EMPLOYEES.LAST_NAME,
  DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEES
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID   = DEPARTMENTS.DEPARTMENT_ID
WHERE DEPARTMENTS.DEPARTMENT_NAME = 'IT'
ORDER BY EMPLOYEES.LAST_NAME,
  EMPLOYEES.FIRST_NAME;


-- แสดงรายการงานพร้อมชื่อแผนก และข้อมูลของพนักงานที่ทำงานในแผนก IT และมีชื่อขึ้นต้นด้วยตัวอักษร 'S'
SELECT JOBS.JOB_TITLE,
  DEPARTMENTS.DEPARTMENT_NAME,
  EMPLOYEES.FIRST_NAME,
  EMPLOYEES.LAST_NAME
FROM EMPLOYEES
JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID   = DEPARTMENTS.DEPARTMENT_ID
JOIN JOBS
ON EMPLOYEES.JOB_ID          = JOBS.JOB_ID
WHERE DEPARTMENTS.DEPARTMENT_NAME = 'IT'
AND EMPLOYEES.FIRST_NAME LIKE 'S%'
ORDER BY EMPLOYEES.LAST_NAME,
  EMPLOYEES.FIRST_NAME;
