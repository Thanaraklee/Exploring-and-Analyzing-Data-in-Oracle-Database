-- แสดงผลข้อมูลทั้งหมดในตาราง LOCATIONS, DEPARTMENTS, JOBS, EMPLOYEES, JOB_HISTORY, REGIONS, COUNTRIES
SELECT * FROM LOCATIONS;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM EMPLOYEES;
SELECT * FROM JOB_HISTORY;
SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;


-- เพิ่มพนักงานใหม่ในตาราง EMPLOYEES
SELECT * FROM EMPLOYEES ORDER BY EMPLOYEE_ID DESC;

ROLLBACK; -- ยกเลิกการเปลี่ยนแปลงทั้งหมดที่เกิดขึ้นก่อนจากการ COMMIT
COMMIT; -- ยืนยันการเปลี่ยนแปลงทั้งหมดและบันทึกข้อมูล

Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
VALUES (207,'Rahul','Dravid','rd@gmail.comm','515.123.9999',TO_DATE('29-NOV-2021','dd-MON-yyyy'),'HR_REP',2400,NULL,101,40);

-- อัปเดตข้อมูลที่มีปัญหาในตาราง EMPLOYEES
UPDATE EMPLOYEES
SET EMAIL = 'rd@gmail.com'
WHERE EMPLOYEE_ID = 207;


-- อัปเดต COMMISSION_PCT เป็น 0 เมื่อ COMMISSION_PCT = NULL
UPDATE EMPLOYEES
SET COMMISSION_PCT = 0
WHERE COMMISSION_PCT IS NULL;


-- ลบข้อมูลพนักงานออกจากตาราง EMPLOYEES
DELETE FROM EMPLOYEES
WHERE EMPLOYEE_ID = 207;

-- สร้างตารางสำรองของตาราง EMPLOYEES
CREATE TABLE EMPLOYEE_BACKUP AS (
SELECT * FROM EMPLOYEES
);

SELECT * FROM EMPLOYEE_BACKUP;


-- ลบข้อมูลทั้งหมดในตาราง EMPLOYEE_BACKUP
TRUNCATE TABLE EMPLOYEE_BACKUP;


-- นำข้อมูลทั้งหมดจากตาราง EMPLOYEES ไปยังตารางสำรอง EMPLOYEE_BACKUP และ COMMIT ข้อมูล
INSERT INTO EMPLOYEE_BACKUP
SELECT * FROM EMPLOYEES;
COMMIT;


-- แสดงผลข้อมูลทั้งหมดในตาราง LOCATIONS, DEPARTMENTS
SELECT * FROM LOCATIONS;
SELECT * FROM DEPARTMENTS;

-- แสดงผลข้อมูลภูมิภาค (COUNTRY_ID) จากตาราง LOCATIONS
SELECT COUNTRY_ID FROM LOCATIONS;

-- แสดงผลข้อมูลภูมิภาค (COUNTRY_ID) ที่ไม่ซ้ำกันจากตาราง LOCATIONS
SELECT DISTINCT COUNTRY_ID FROM LOCATIONS;

-- แสดงผลข้อมูล MANAGER_ID ที่ไม่ซ้ำกันจากตาราง DEPARTMENTS
SELECT DISTINCT MANAGER_ID FROM DEPARTMENTS;

-- แสดงผลข้อมูล FIRST_NAME และ LAST_NAME ของพนักงานที่มี EMPLOYEE_ID ตรงกับค่าที่กำหนด
SELECT FIRST_NAME, LAST__NAME FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (108,200,203,204,121,145,103,201,114,100,205);

-- แสดงผลข้อมูล FIRST_NAME และ LAST_NAME ของพนักงานที่มี EMPLOYEE_ID ตรงกับค่าที่กำหนด และ join ชื่อและนามสกุลเข้าด้วยกัน
SELECT FIRST_NAME || ' ' || LAST__NAME AS NAME FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (108,200,203,204,121,145,103,201,114,100,205);

-- แสดงผลข้อมูล FIRST_NAME และ LAST_NAME ของพนักงานที่มี EMPLOYEE_ID ตรงกับค่าที่กำหนด และ join ชื่อและนามสกุลเข้าด้วยกัน
SELECT FIRST_NAME || ' ' || LAST_NAME AS EMPLOYEE_NAME FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (108,200,203,204,121,145,103,201,114,100,205);

-- แสดงผลข้อมูล FIRST_NAME และ LAST_NAME ของพนักงานที่มี EMPLOYEE_ID ตรงกับค่าที่กำหนด และ join ชื่อและนามสกุลเข้าด้วยกัน โดยกำหนดชื่อคอลัมน์เป็น "EMPLOYEE NAME"
SELECT FIRST_NAME || ' ' || LAST_NAME AS "EMPLOYEE NAME" FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (108,200,203,204,121,145,103,201,114,100,205);

-- แสดงผลข้อมูล FIRST_NAME และ LAST_NAME ของพนักงานที่มี EMPLOYEE_ID ตรงกับค่าที่กำหนด และ join ชื่อและนามสกุลเข้าด้วยกัน โดยกำหนดชื่อคอลัมน์เป็น "EMPLOYEE NAME"
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLOYEE NAME" FROM EMPLOYEES 
WHERE EMPLOYEE_ID IN (108,200,203,204,121,145,103,201,114,100,205); 

-- แสดงผลข้อมูล FIRST_NAME และ LAST_NAME ของพนักงานที่มี EMPLOYEE_ID ตรงกับค่าที่กำหนด และ join ชื่อและนามสกุลเข้าด้วยกัน โดยกำหนดชื่อคอลัมน์เป็น "EMPLOYEE NAME"
SELECT t_emp.FIRST_NAME || ' ' || t_emp.LAST_NAME "EMPLOYEE NAME" 
FROM EMPLOYEES t_emp 
WHERE EMPLOYEE_ID IN (108,200,203,204,121,145,103,201,114,100,205);


-- แสดงผลข้อมูลทั้งหมดในตาราง LOCATIONS, DEPARTMENTS
SELECT * FROM LOCATIONS;
SELECT * FROM DEPARTMENTS;

-- แสดงผลข้อมูลจากตาราง JOBS ที่ JOB_ID เริ่มต้นด้วย AD และเงินเดือนมากกว่า 10000
SELECT * 
FROM JOBS
WHERE JOB_ID LIKE 'AD%' AND SALARY > 10000;

-- แสดงผลข้อมูลจากตาราง JOBS ที่ JOB_ID เริ่มต้นด้วย IT และเงินเดือนไม่เกิน 6000
SELECT * 
FROM JOBS
WHERE JOB_ID LIKE 'IT%' AND SALARY <= 6000;

-- แสดงผลข้อมูลจากตาราง EMPLOYEES ที่ตำแหน่งงานอยู่ในแผนก Purchasing, IT, Executive และ COMMISSION_PCT เท่ากับ 0 และวันที่เข้าทำงานหลังจาก 1-JAN-2000
SELECT * 
FROM EMPLOYEES
WHERE (
    (JOB_ID LIKE 'AD%' AND SALARY > 10000)
    OR (JOB_ID LIKE 'IT%' AND SALARY <= 10000)
)
OR (
    DEPARTMENT_ID IN (90, 60, 30)
    AND COMMISSION_PCT = 0
)
AND HIRE_DATE > TO_DATE('1-JAN-2000', 'dd-MON-yyyy');
