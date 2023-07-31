/************************** 1. COUNT(*) vs COUNT(column_name) **************************/
-- แสดงจำนวนรายการแยกตามประเทศและรัฐ
SELECT COUNTRY_ID, COUNT(*), COUNT(STATE_PROVINCE)
FROM LOCATIONS
GROUP BY COUNTRY_ID
ORDER BY COUNTRY_ID;

-- ค้นหาจำนวนผู้จัดการแยกตามแผนกและจำนวนรายการ
SELECT D.DEPARTMENT_NAME, COUNT(*), COUNT(E.MANAGER_ID)
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;

/************************** 2. CASE STATEMENT: จำแนกพนักงานตามวันเริ่มงาน **************************/
-- จำแนกพนักงานตามวันเริ่มงาน
/*
1. ก่อน 1990
2. ระหว่าง 1990 ถึง 1995
3. ระหว่าง 1995 ถึง 2000
4. หลัง 90s
*/
SELECT FIRST_NAME || ' ' || LAST_NAME,
HIRE_DATE,
CASE 
  WHEN HIRE_DATE < TO_DATE('01-JAN-1990', 'dd-MON-yyyy')
  THEN 'ก่อน 1990'
  WHEN HIRE_DATE >= TO_DATE('01-JAN-1990', 'dd-MON-yyyy') AND HIRE_DATE < TO_DATE('01-JAN-1995', 'dd-MON-yyyy')
  THEN 'ระหว่าง 1990 ถึง 1995'
  WHEN HIRE_DATE >= TO_DATE('01-JAN-1995', 'dd-MON-yyyy') AND HIRE_DATE < TO_DATE('01-JAN-2000', 'dd-MON-yyyy')
  THEN 'ระหว่าง 1995 ถึง 2000'
  WHEN HIRE_DATE >= TO_DATE('01-JAN-2000', 'dd-MON-yyyy') 
  THEN 'หลัง 90s'
  ELSE
    'ไม่มีการจำแนก'
END HIRE_CATEGORY
FROM EMPLOYEES
ORDER BY HIRE_DATE;

/************************** 3. WITH Clause **************************/
-- ค้นหาพนักงานทั้งหมดที่เงินเดือนมากกว่าเงินเดือนเฉลี่ยของพนักงานทั้งหมด
SELECT E.EMPLOYEE_ID, SALARY, AVG_SALARY
FROM EMPLOYEES E, (SELECT AVG(SALARY) AVG_SALARY FROM EMPLOYEES) AVG_SAL
WHERE E.SALARY > AVG_SAL.AVG_SALARY;

WITH AVG_SAL AS
(SELECT AVG(SALARY) AVG_SALARY 
  FROM EMPLOYEES)
SELECT E.EMPLOYEE_ID, SALARY, AVG_SALARY
FROM EMPLOYEES E, AVG_SAL
WHERE E.SALARY > AVG_SAL.AVG_SALARY;

-- ค้นหาแผนกที่เงินเดือนรวมของพนักงานทั้งหมดในแผนกนั้นมากกว่าเฉลี่ยของเงินเดือนรวมของพนักงานทั้งหมดในฐานข้อมูล
WITH DEPT_WISE_SAL AS 
  (
  SELECT DEPARTMENT_ID, SUM(SALARY) TOTAL_SAL_DEPT_WISE
  FROM EMPLOYEES
  GROUP BY DEPARTMENT_ID
  ),
AVG_SAL AS (
    SELECT AVG(SALARY) AVG_SAL
    FROM EMPLOYEES)
SELECT * 
FROM DEPT_WISE_SAL, AVG_SAL
WHERE DEPT_WISE_SAL.TOTAL_SAL_DEPT_WISE > AVG_SAL.AVG_SAL;

/************************** 4. ค้นหารายละเอียดแผนกโดยใช้ WITH clause และ View **************************/
CREATE OR REPLACE VIEW DEPARTMENT_LEVEL_DETAILS AS
WITH DEPT_SAL_DET AS
  (SELECT DEPARTMENT_ID,
    MAX(SALARY)           AS MAX_SALARY,
    MIN(SALARY)           AS MIN_SALARY,
    ROUND(AVG(SALARY), 2) AS AVG_SALARY,
    SUM(SALARY)           AS SUM_SALARY,
    COUNT(*)              AS NUMBER_OF_EMP
  FROM EMPLOYEES
  GROUP BY DEPARTMENT_ID
  ),
EMP_RESIGNATION_DET AS 
  (SELECT DEPARTMENT_ID,
    COUNT(*) AS NUMBER_OF_EMP_RESIGNED
  FROM JOB_HISTORY
  GROUP BY DEPARTMENT_ID
  ) 
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
LEFT JOIN DEPT_SAL_DET
ON DEPARTMENTS.DEPARTMENT_ID = DEPT_SAL_DET.DEPARTMENT_ID
LEFT JOIN EMP_RESIGNATION_DET
ON DEPARTMENTS.DEPARTMENT_ID = EMP_RESIGNATION_DET.DEPARTMENT_ID
ORDER BY DEPARTMENTS.DEPARTMENT_ID;

SELECT * FROM DEPARTMENT_LEVEL_DETAILS;

/************************** 5. ค้นหาบันทึกพนักงานที่มีเงินเดือนสามสูงสุดโดยไม่ใช้ฟังก์ชัน Analytical **************************/

WITH THIRD_MAX_SALARY AS (
SELECT MAX(SALARY) AS THIRD_MAX_SAL
FROM EMPLOYEES
WHERE SALARY NOT IN
  (SELECT T.*
  FROM
    ( SELECT SALARY FROM EMPLOYEES GROUP BY SALARY ORDER BY SALARY DESC
    ) T
  WHERE ROWNUM < 3
  ))
SELECT * 
FROM EMPLOYEES JOIN THIRD_MAX_SALARY
ON EMPLOYEES.SALARY = THIRD_MAX_SALARY.THIRD_MAX_SAL;

/************************** 6. ค้นหารายการที่ซ้ำกันของ Location ID พร้อมกับรายละเอียด **************************/
WITH ALL_LOCATIONS AS (
  SELECT LOCATION_ID, POSTAL_CODE, CITY, COUNTRY_ID 
  FROM LOCATIONS
  UNION
  SELECT LOCATION_ID, CAST(POSTAL_CODE AS VARCHAR2(12)), CITY, COUNTRY_ID 
  FROM NON_FUNCTIONAL_LOCATIONS
),
DUPLICATE_LOCATION_ID AS (
  SELECT LOCATION_ID, COUNT(*) AS DUPLICATE_COUNT 
  FROM ALL_LOCATIONS 
  GROUP BY LOCATION_ID
  HAVING COUNT(*) > 1
)
SELECT 
  ALL_LOCATIONS.LOCATION_ID, 
  POSTAL_CODE,
  CITY,
  COUNTRY_ID,
  DUPLICATE_COUNT
FROM ALL_LOCATIONS JOIN DUPLICATE_LOCATION_ID
ON ALL_LOCATIONS.LOCATION_ID = DUPLICATE_LOCATION_ID.LOCATION_ID;

/************************** 7. เลือกเมืองที่ไม่ซ้ำกันพร้อมรายละเอียด **************************/
WITH ALL_LOCATIONS AS
  ( SELECT LOCATION_ID, POSTAL_CODE, CITY, COUNTRY_ID FROM LOCATIONS
  UNION
  SELECT LOCATION_ID,
    CAST(POSTAL_CODE AS VARCHAR2(12 BYTE)),
    CITY,
    COUNTRY_ID
  FROM NON_FUNCTIONAL_LOCATIONS
  ),
  UNIQUE_CITY AS
  (SELECT CITY,
    MAX(LOCATION_ID) AS MAX_LOCATION_ID
  FROM ALL_LOCATIONS
  GROUP BY CITY
  )
SELECT ALL_LOCATIONS.LOCATION_ID,
  POSTAL_CODE,
  ALL_LOCATIONS.CITY,
  COUNTRY_ID
FROM ALL_LOCATIONS
JOIN UNIQUE_CITY
ON ALL_LOCATIONS.LOCATION_ID = UNIQUE_CITY.MAX_LOCATION_ID
AND ALL_LOCATIONS.CITY       = UNIQUE_CITY.CITY
ORDER BY LOCATION_ID;

/************************** 8. แสดงชื่อเมืองในรูปแบบตัวอักษรที่คั่นด้วยเครื่องหมายจุลภาค เช่น Bern, Bombay เป็นต้น **************************/
WITH ALL_LOCATIONS AS
(SELECT LOCATION_ID, POSTAL_CODE, CITY, COUNTRY_ID FROM LOCATIONS
  UNION
  SELECT LOCATION_ID,
    CAST(POSTAL_CODE AS VARCHAR2(12 BYTE)),
    CITY,
    COUNTRY_ID
  FROM NON_FUNCTIONAL_LOCATIONS
  )
SELECT LISTAGG(CITY, ', ') WITHIN GROUP (ORDER BY CITY) AS CITY 
FROM ALL_LOCATIONS;

-- แสดงเมืองที่ซ้ำกันอย่างเดียวโดยใช้คำสั่งก่อนหน้านี้
WITH ALL_LOCATIONS AS
  ( SELECT LOCATION_ID, POSTAL_CODE, CITY, COUNTRY_ID FROM LOCATIONS
  UNION
  SELECT LOCATION_ID,
    CAST(POSTAL_CODE AS VARCHAR2(12 BYTE)),
    CITY,
    COUNTRY_ID
  FROM NON_FUNCTIONAL_LOCATIONS
  ),
  UNIQUE_CITY AS
  (SELECT CITY,
    MAX(LOCATION_ID) AS MAX_LOCATION_ID
  FROM ALL_LOCATIONS
  GROUP BY CITY
  ),
UNIQUE_LOCATIONS_WITH_DETAILS AS (
SELECT ALL_LOCATIONS.LOCATION_ID,
  POSTAL_CODE,
  ALL_LOCATIONS.CITY,
  COUNTRY_ID
FROM ALL_LOCATIONS
JOIN UNIQUE_CITY
ON ALL_LOCATIONS.LOCATION_ID = UNIQUE_CITY.MAX_LOCATION_ID
AND ALL_LOCATIONS.CITY       = UNIQUE_CITY.CITY
)
SELECT COUNTRY_ID, LISTAGG(CITY, ', ') WITHIN GROUP (ORDER BY CITY) AS CITY  
FROM UNIQUE_LOCATIONS_WITH_DETAILS
GROUP BY COUNTRY_ID;

/************************** 9. ค้นหาพนักงานที่เงินเดือนไม่อยู่ในช่วงเงินเดือนของตำแหน่งงาน **************************/
SELECT EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  EMAIL,
  PHONE_NUMBER,
  HIRE_DATE,
  EMPLOYEES.JOB_ID,
  SALARY,
  JOB_TITLE,
  MIN_SALARY,
  MAX_SALARY
FROM EMPLOYEES
JOIN JOBS
ON JOBS.JOB_ID = EMPLOYEES.JOB_ID
AND ( SALARY   < MIN_SALARY
OR SALARY      > MAX_SALARY );