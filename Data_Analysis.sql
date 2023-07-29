-- แสดงผลข้อมูลทั้งหมดในตาราง LOCATIONS, DEPARTMENTS, JOBS, EMPLOYEES, JOB_HISTORY, REGIONS, COUNTRIES
SELECT * FROM LOCATIONS;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
SELECT * FROM EMPLOYEES;
SELECT * FROM JOB_HISTORY;
SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;


/************************** ค้นหารายละเอียดของพนักงานและแผนกตามเงื่อนไขที่กำหนด **************************/

-- ค้นหารายละเอียดแผนกที่รหัสไปรษณีย์ = 98199
SELECT *
FROM LOCATIONS
WHERE POSTAL_CODE = '98199';

SELECT * FROM DEPARTMENTS WHERE LOCATION_ID = 1700;


-- ค้นหาชื่อแผนกที่รหัสไปรษณีย์ = 98199
SELECT DEPARTMENT_NAME
FROM DEPARTMENTS
WHERE LOCATION_ID = 1700;


-- ค้นหารายละเอียดแผนกที่รหัสไปรษณีย์ != 98199
SELECT DEPARTMENT_NAME
FROM DEPARTMENTS
WHERE LOCATION_ID != 1700;


-- ค้นหารายละเอียดของพนักงานที่เงินเดือนมากกว่า 10000
SELECT *
FROM EMPLOYEES
WHERE SALARY > 10000;


-- ค้นหาชื่อพนักงาน อีเมลและหมายเลขโทรศัพท์ของพนักงานที่เงินเดือนมากกว่า 10000
SELECT FIRST_NAME,
  LAST_NAME,
  EMAIL,
  PHONE_NUMBER
FROM EMPLOYEES
WHERE SALARY > 10000;


-- ค้นหารายละเอียดของพนักงานที่แผนกการตลาดและมีเงินเดือนน้อยกว่าหรือเท่ากับ 6000
SELECT *
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Marketing';

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 20 AND SALARY <= 6000;


/************************** แสดงรายการที่เรียงลำดับและจัดการกับค่า NULL **************************/

-- ค้นหารายละเอียดของพนักงานที่มีอัตราคอมมิชชัน
SELECT * 
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;


-- ค้นหารายละเอียดของพนักงานที่ไม่มีผู้จัดการ
SELECT * 
FROM EMPLOYEES
WHERE MANAGER_ID IS NULL;


-- รายชื่อพนักงานเรียงลำดับตามชื่อในลำดับน้อยไปมาก
SELECT first_name||' '||last_name
FROM EMPLOYEES
ORDER BY first_name, last_name;


-- ค้นหาสถานที่ในประเทศสหราชอาณาจักรที่เรียงลำดับตามรหัสไปรษณีย์ในลำดับน้อยไปมาก
SELECT * 
FROM LOCATIONS
WHERE COUNTRY_ID = 'UK'
ORDER BY POSTAL_CODE;


-- ค้นหาสถานที่ในประเทศสหราชอาณาจักรที่เรียงลำดับตามรหัสไปรษณีย์ในลำดับมากไปน้อย
SELECT * 
FROM LOCATIONS
WHERE COUNTRY_ID = 'UK'
ORDER BY POSTAL_CODE DESC;


-- ค้นหาสถานที่ในประเทศสหราชอาณาจักรที่เรียงลำดับตามรหัสไปรษณีย์โดยมีค่า NULL อยู่ด้านบน
SELECT * 
FROM LOCATIONS
WHERE COUNTRY_ID = 'UK'
ORDER BY POSTAL_CODE NULLS FIRST;


-- ค้นหาสถานที่ทั้งหมดและจัดเรียงประเทศในลำดับน้อยไปมากและเมืองในลำดับมากไปน้อย
SELECT * 
FROM LOCATIONS
ORDER BY COUNTRY_ID ASC, CITY DESC;


/************************** ค้นหารูปแบบที่ระบุในคอลัมน์ (Like, wildcards, in) **************************/

-- ค้นหาพนักงานที่ทำงานเป็นตำแหน่ง President, Administration Vice President และ Administration Assistant
SELECT * 
FROM JOBS 
WHERE JOB_TITLE IN ('President', 'Administration Vice President' ,'Administration Assistant');

SELECT FIRST_NAME, LAST_NAME, EMAIL, JOB_ID
FROM EMPLOYEES 
WHERE JOB_ID IN ('AD_ASST', 'AD_PRES', 'AD_VP');


-- ค้นหาพนักงานที่ไม่ได้ทำงานเป็นตำแหน่ง Finance Manager, Accountant และ Shipping Clerk
select * 
FROM JOBS
WHERE JOB_TITLE IN ('Finance Manager', 'Accountant', 'Shipping Clerk');

SELECT FIRST_NAME, LAST_NAME, EMAIL, JOB_ID
FROM EMPLOYEES 
WHERE JOB_ID NOT IN ('FI_MGR', 'FI_ACCOUNT', 'SH_CLERK');


-- ค้นหาพนักงานที่รหัสตำแหน่งงานขึ้นต้นด้วย AD
SELECT FIRST_NAME, LAST_NAME, EMAIL, JOB_ID
FROM EMPLOYEES 
WHERE JOB_ID LIKE 'AD%';


-- ค้นหาพนักงานทั้งหมดที่รหัสตำแหน่งงานไม่ได้ขึ้นต้นด้วย SA
SELECT FIRST_NAME, LAST_NAME, EMAIL, JOB_ID
FROM EMPLOYEES 
WHERE JOB_ID NOT LIKE 'SA%';


-- ค้นหาพนักงานทั้งหมดที่รหัสตำแหน่งงานไม่ได้ขึ้นต้นด้วย SA หรือ SH
SELECT FIRST_NAME, LAST_NAME, EMAIL, JOB_ID
FROM EMPLOYEES 
WHERE JOB_ID NOT LIKE 'SA%'
AND JOB_ID NOT LIKE 'SH%';


-- ค้นหาสถานที่ทั้งหมดที่ขึ้นต้นด้วย S
SELECT * 
FROM LOCATIONS
WHERE CITY LIKE 'S%';


-- ค้นหาสถานที่ทั้งหมดที่ที่อยู่บนถนนมีคำว่า Rd อยู่
SELECT * 
FROM LOCATIONS
WHERE STREET_ADDRESS LIKE '%Rd%';


/************************** เพิ่ม อัปเดต และลบพนักงาน **************************/

-- เพิ่มพนักงานใหม่ในตาราง
SELECT * FROM EMPLOYEES ORDER BY EMPLOYEE_ID DESC;

Insert into EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID)
VALUES 
   ( 207
   , 'Rahul'
   , 'Dravid'
   , 'rd@gmail.comm'
   , '515.123.9999'
   , TO_DATE('29-NOV-2021', 'dd-MON-yyyy')
   , 'HR_REP'
   , 24000
   , NULL
   , 101
   , 40
   );
   

-- อัปเดตข้อมูลที่มีปัญหาในตาราง
UPDATE EMPLOYEES 
SET EMAIL = 'rd@gmail.com'
WHERE EMPLOYEE_ID = 207;


-- อัปเดต COMMISSION_PCT เป็น 0 ในข้อมูลที่ COMMISSION_PCT ไม่มีค่า
UPDATE EMPLOYEES 
SET COMMISSION_PCT = 0
WHERE COMMISSION_PCT IS NULL;


-- ลบพนักงานจากตาราง
DELETE FROM EMPLOYEES 
WHERE EMPLOYEE_ID = 207;


-- สร้างตารางสำรองของพนักงาน
CREATE TABLE EMPLOYEE_BACKUP AS (
SELECT * FROM EMPLOYEES);


/************************** สร้างตารางสำรองของตารางพนักงานและนำข้อมูลที่ Commit และ Rollback **************************/

-- สร้างตารางสำรองของพนักงาน
CREATE TABLE EMPLOYEE_BACKUP AS (
SELECT * FROM EMPLOYEES);

SELECT * FROM EMPLOYEE_BACKUP;


-- ลบข้อมูลทั้งหมดในตาราง
TRUNCATE TABLE EMPLOYEE_BACKUP;


-- นำข้อมูลทั้งหมดจากตารางพนักงานไปยังตารางสำรอง
INSERT INTO EMPLOYEE_BACKUP
SELECT * FROM EMPLOYEES;
COMMIT;


-- ลบตาราง
DROP TABLE EMPLOYEE_BACKUP;
