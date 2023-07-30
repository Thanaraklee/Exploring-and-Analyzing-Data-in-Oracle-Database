/************************** Inner Join: แสดงรายละเอียดพนักงาน **************************/

-- แสดงรายละเอียดของพนักงานที่มีแผนกเป็น 'Marketing' โดยใช้ Inner Join
SELECT *
FROM EMPLOYEES, DEPARTMENTS
WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
AND DEPARTMENTS.DEPARTMENT_NAME = 'Marketing';


-- แสดงรหัสพนักงาน (EMPLOYEE_ID), ชื่อ-นามสกุล (NAME), อีเมล (EMAIL), และเมืองของพนักงาน (CITY) ที่มีแผนกเป็น 'Marketing'
SELECT EMPLOYEES.EMPLOYEE_ID, 
EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME NAME,
EMPLOYEES.EMAIL,
LOCATIONS.CITY
FROM EMPLOYEES, DEPARTMENTS, LOCATIONS
WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
AND DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
AND DEPARTMENTS.DEPARTMENT_NAME = 'Marketing';


--ANSI Join
-- แสดงรหัสพนักงาน (EMPLOYEE_ID), ชื่อ-นามสกุล (NAME), อีเมล (EMAIL), และเมืองของพนักงาน (CITY) ที่มีแผนกเป็น 'Marketing' โดยใช้ ANSI Join
SELECT EMPLOYEES.EMPLOYEE_ID, 
EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME NAME,
EMPLOYEES.EMAIL,
LOCATIONS.CITY
FROM EMPLOYEES INNER JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
AND DEPARTMENTS.DEPARTMENT_NAME = 'Marketing'
INNER JOIN  LOCATIONS
ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID;

SELECT * FROM TABLE_1;
SELECT * FROM TABLE_2;

-- เลือกข้อมูลทั้งหมดจาก TABLE_1 และ TABLE_2 โดยใช้การ JOIN ด้วยเงื่อนไข COLUMN_1 เท่ากับ COLUMN_2
SELECT *
FROM TABLE_1, TABLE_2
WHERE COLUMN_1 = COLUMN_2;


/************************** แก้ไข Error "column ambiguously defined". **************************/

/* column ambiguously defined */
-- แก้ไข Error "column ambiguously defined" โดยใช้ชื่อ Table แทนชื่อคอลัมน์
SELECT *
FROM EMPLOYEES, DEPARTMENTS
WHERE DEPARTMENT_ID = DEPARTMENT_ID
AND DEPARTMENT_NAME = 'Marketing';


-- Alias
-- แก้ไข Error "column ambiguously defined" โดยใช้ Alias ในการตั้งชื่อคอลัมน์
SELECT *
FROM EMPLOYEES e, DEPARTMENTS d
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
AND d.DEPARTMENT_NAME = 'Marketing';


SELECT e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL,
l.CITY
FROM EMPLOYEES e, DEPARTMENTS d, LOCATIONS l
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
AND d.LOCATION_ID = l.LOCATION_ID
AND d.DEPARTMENT_NAME = 'Marketing';


/************************** LEFT OUTER JOIN: รายการแผนกทั้งหมดพร้อมกับพนักงานที่ทำงานในแผนกนั้นๆ **************************/

-- คำสั่ง SQL ไม่ถูกต้อง
SELECT d.DEPARTMENT_ID,
d.DEPARTMENT_NAME,
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL
FROM DEPARTMENTS d, EMPLOYEES e
WHERE d.DEPARTMENT_ID = e.DEPARTMENT_ID
ORDER BY d.DEPARTMENT_ID;

-- แสดงรายการแผนกทั้งหมดพร้อมกับพนักงานที่ทำงานในแผนกนั้นๆ โดยใช้ Left Outer Join
SELECT d.DEPARTMENT_ID,
d.DEPARTMENT_NAME,
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL
FROM DEPARTMENTS d, EMPLOYEES e
WHERE d.DEPARTMENT_ID = e.DEPARTMENT_ID(+)
ORDER BY d.DEPARTMENT_ID;

-- ANSI JOIN
SELECT d.DEPARTMENT_ID,
d.DEPARTMENT_NAME,
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL
FROM DEPARTMENTS d LEFT OUTER JOIN EMPLOYEES e
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
ORDER BY d.DEPARTMENT_ID;


/************************** RIGHT OUTER JOIN: แสดงรายชื่อพนักงานพร้อมรายละเอียดแผนก **************************/

-- แสดงรายชื่อพนักงานพร้อมรายละเอียดแผนก
SELECT 
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL,
d.DEPARTMENT_ID,
d.DEPARTMENT_NAME
FROM DEPARTMENTS d, EMPLOYEES e
WHERE d.DEPARTMENT_ID(+) = e.DEPARTMENT_ID
ORDER BY d.DEPARTMENT_ID;

-- ANSI JOIN
SELECT 
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL,
d.DEPARTMENT_ID,
d.DEPARTMENT_NAME
FROM DEPARTMENTS d RIGHT OUTER JOIN EMPLOYEES e
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
ORDER BY d.DEPARTMENT_ID;


-- แสดงรายชื่อพนักงานพร้อมรายละเอียดแผนก ของพนักงานที่รหัสพนักงานมากกว่า 150
SELECT 
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL,
d.DEPARTMENT_ID,
d.DEPARTMENT_NAME
FROM DEPARTMENTS d RIGHT OUTER JOIN EMPLOYEES e
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE e.EMPLOYEE_ID > 150
ORDER BY e.EMPLOYEE_ID;


-- แสดงรายละเอียดแผนกเท่านั้น ของพนักงานที่รหัสพนักงานมากกว่า 150
SELECT 
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL,
d.DEPARTMENT_ID,
d.DEPARTMENT_NAME
FROM DEPARTMENTS d RIGHT OUTER JOIN EMPLOYEES e
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
AND e.EMPLOYEE_ID > 150
ORDER BY e.EMPLOYEE_ID;


-- Left Outer Join
-- เลือกข้อมูลจาก TABLE_1 และ TABLE_2 โดยใช้ Left Outer Join
SELECT *
FROM TABLE_1 LEFT JOIN TABLE_2
ON COLUMN_1 = COLUMN_2
ORDER BY 1;

-- Right Outer Join
-- เลือกข้อมูลจาก TABLE_1 และ TABLE_2 โดยใช้ Right Outer Join
SELECT *
FROM TABLE_1 RIGHT JOIN TABLE_2
ON COLUMN_1 = COLUMN_2
ORDER BY 1;


/************************** FULL OUTER JOIN และ SELF JOIN **************************/

-- FULL OUTER JOIN: แสดงรายการพนักงานและแผนกพร้อมกับข้อมูลที่ขาดหายไป
-- ANSI JOIN
SELECT d.DEPARTMENT_ID,
d.DEPARTMENT_NAME,
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL
FROM DEPARTMENTS d FULL OUTER JOIN EMPLOYEES e
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
ORDER BY d.DEPARTMENT_ID;


-- FULL OUTER JOIN
-- เลือกข้อมูลจาก TABLE_1 และ TABLE_2 โดยใช้ FULL OUTER JOIN
SELECT *
FROM TABLE_1 FULL OUTER JOIN TABLE_2
ON COLUMN_1 = COLUMN_2
ORDER BY 1;

-- SELF JOIN: แสดงรายละเอียดพนักงานพร้อมรายละเอียดของผู้จัดการ
SELECT 
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL,
m.EMPLOYEE_ID as MGR_EMPLOYEE_ID, 
m.FIRST_NAME || ' ' || m.LAST_NAME MGR_NAME
FROM EMPLOYEES e, EMPLOYEES m
WHERE e.MANAGER_ID = m.EMPLOYEE_ID(+)
ORDER BY e.EMPLOYEE_ID;

-- ANSI JOIN
SELECT 
e.EMPLOYEE_ID, 
e.FIRST_NAME || ' ' || e.LAST_NAME NAME,
e.EMAIL,
m.EMPLOYEE_ID as MGR_EMPLOYEE_ID, 
m.FIRST_NAME || ' ' || m.LAST_NAME MGR_NAME
FROM EMPLOYEES e LEFT JOIN EMPLOYEES m
ON e.MANAGER_ID = m.EMPLOYEE_ID
ORDER BY e.EMPLOYEE_ID;


/************************** UNION และ UNION ALL: รวม Table  Locations และ Non-Functional Locations **************************/

/*
คำสั่ง UNION ALL เหมือนกับคำสั่ง UNION แต่ UNION ALL จะเลือกทุกค่าโดยไม่มีการลบค่าที่ซ้ำออก
ความแตกต่างระหว่าง UNION และ UNION ALL คือ UNION จะลบข้อมูลที่ซ้ำกัน ในขณะที่ UNION ALL จะเลือกข้อมูลทั้งหมดมาแสดง
*/


SELECT * FROM LOCATIONS;
SELECT * FROM NON_FUNCTIONAL_LOCATIONS;

-- แสดงเมืองที่มีใน Table  LOCATIONS แต่ไม่มีใน Table  NON_FUNCTIONAL_LOCATIONS
SELECT CITY FROM LOCATIONS
MINUS
SELECT CITY FROM NON_FUNCTIONAL_LOCATIONS;


-- แสดงเมืองและรหัสไปรษณีย์ที่มีใน Table  LOCATIONS แต่ไม่มีใน Table  NON_FUNCTIONAL_LOCATIONS
SELECT CITY, POSTAL_CODE FROM LOCATIONS
MINUS
SELECT CITY, TO_CHAR(POSTAL_CODE) FROM NON_FUNCTIONAL_LOCATIONS;


-- แสดงเมืองที่มีในทั้ง Table  LOCATIONS และ NON_FUNCTIONAL_LOCATIONS
SELECT CITY FROM LOCATIONS
INTERSECT
SELECT CITY FROM NON_FUNCTIONAL_LOCATIONS;


-- แสดงเมืองและรหัสไปรษณีย์ที่มีในทั้ง Table  LOCATIONS และ NON_FUNCTIONAL_LOCATIONS
SELECT CITY, POSTAL_CODE FROM LOCATIONS
INTERSECT
SELECT CITY, TO_CHAR(POSTAL_CODE) FROM NON_FUNCTIONAL_LOCATIONS;


/************************** Join หลายๆ  Table เพื่อเลือกข้อมูลของพนักงาน **************************/

SELECT E.FIRST_NAME || ' ' ||E.LAST_NAME AS EMPLOYEE_NAME,
E.EMAIL,
D.DEPARTMENT_NAME,
L.CITY AS DEPARTMENT_LOCATION,
J.JOB_TITLE,
M.FIRST_NAME || ' ' || M.LAST_NAME MANAGER_NAME,
C.COUNTRY_NAME
FROM EMPLOYEES E,
DEPARTMENTS D,
JOBS J,
EMPLOYEES M,
LOCATIONS L,
COUNTRIES C
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
AND E.JOB_ID = J.JOB_ID(+)
AND E.MANAGER_ID = M.EMPLOYEE_ID(+)
AND D.LOCATION_ID = L.LOCATION_ID(+)
AND L.COUNTRY_ID = C.COUNTRY_ID(+);


/************************** แปลง query ก่อนหน้าเป็น ANSI join query **************************/
SELECT E.FIRST_NAME || ' ' ||E.LAST_NAME AS EMPLOYEE_NAME,
E.EMAIL,
D.DEPARTMENT_NAME,
L.CITY AS DEPARTMENT_LOCATION,
J.JOB_TITLE,
M.FIRST_NAME || ' ' || M.LAST_NAME MANAGER_NAME,
C.COUNTRY_NAME
FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
LEFT JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
LEFT JOIN COUNTRIES C
ON L.COUNTRY_ID = C.COUNTRY_ID;