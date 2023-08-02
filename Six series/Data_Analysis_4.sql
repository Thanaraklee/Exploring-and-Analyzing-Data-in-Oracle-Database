/************************** 2. ลบคุณสมบัติที่ไม่ต้องการ **************************/

--1. สร้างตารางใหม่ที่มีคอลัมน์ที่จำเป็นเท่านั้น
CREATE TABLE ANIMAL_BITES_USERFUL_FEATURE AS
SELECT ID, BITE_DATE, SPECIESIDDESC, BREEDIDDESC, BREED, GENDERIDDESC, COLOR, VICTIM_ZIP, WHEREBITTENIDDESC, ENTRY_ID
FROM ANIMAL_BITES;


--2. ลบคอลัมน์ที่ไม่ต้องการ

--สร้างตารางสำรอง
CREATE TABLE ANIMAL_BITES_BACKUP
AS
SELECT * FROM ANIMAL_BITES;

--ลบคอลัมน์เดียว
ALTER TABLE ANIMAL_BITES DROP COLUMN vaccination_yrs;

--ลบคอลัมน์หลายคอลัมน์
ALTER TABLE ANIMAL_BITES DROP (vaccination_date, AdvIssuedYNDesc, quarantine_date, DispositionIDDesc, head_sent_date, release_date, ResultsIDDesc, FollowupYNDesc, ENTRY_ID);


/************************** 3. ลบข้อมูลที่ซ้ำกัน **************************/

--สร้างตารางใหม่ที่มีข้อมูลที่ต้องการ
CREATE TABLE ANIMAL_BITES_UNIQUE AS
SELECT ID, BITE_DATE, SPECIESIDDESC, BREEDIDDESC, BREED, GENDERIDDESC, COLOR, VICTIM_ZIP, WHEREBITTENIDDESC
FROM
  (SELECT T.*,
    ROW_NUMBER () OVER (PARTITION BY id ORDER BY BITE_DATE DESC) rn
  FROM ANIMAL_BITES T
  ) T
WHERE RN = 1; 
    
--ลบข้อมูลที่ซ้ำกัน
DELETE
FROM ANIMAL_BITES
WHERE ROWID IN
  (SELECT ROWID
  FROM
    (SELECT T.*,
      ROW_NUMBER () OVER (PARTITION BY id ORDER BY BITE_DATE DESC) rn
    FROM ANIMAL_BITES T
    )
  WHERE RN > 1
  );


/************************** 4. ลบข้อมูลที่ขาดหายไป **************************/  

--สร้างตารางใหม่ที่มีเพียงแถวที่มีข้อมูลที่ต้องการ
CREATE TABLE ANIMAL_BITES_MANDATORY AS
SELECT *
FROM ANIMAL_BITES
WHERE BITE_DATE   IS NOT NULL
AND SPECIESIDDESC IS NOT NULL
AND VICTIM_ZIP    IS NOT NULL;

--ลบแถวที่ข้อมูลขาดหายไปใน bite_date, SpeciesIDDesc, victim_zip
DELETE
FROM ANIMAL_BITES
WHERE BITE_DATE  IS NULL
OR SPECIESIDDESC IS NULL
OR VICTIM_ZIP    IS NULL;


/************************** 5. การเติมข้อมูลที่ขาดหาย **************************/

SELECT COUNT(*) FROM ANIMAL_BITES WHERE BREEDIDDESC IS NULL;

UPDATE ANIMAL_BITES
SET BREEDIDDESC = 'UNKNOWN'
WHERE BREEDIDDESC IS NULL;

SELECT COUNT(*) FROM ANIMAL_BITES WHERE BREED IS NULL;

UPDATE ANIMAL_BITES
SET BREED = 'UNKNOWN'
WHERE BREED IS NULL;

SELECT COUNT(*) FROM ANIMAL_BITES WHERE GENDERIDDESC IS NULL;

UPDATE ANIMAL_BITES
SET GENDERIDDESC = 'UNKNOWN'
WHERE GENDERIDDESC IS NULL;

SELECT COUNT(*) FROM ANIMAL_BITES WHERE COLOR IS NULL;

UPDATE ANIMAL_BITES
SET COLOR = 'UNKNOWN'
WHERE COLOR IS NULL;

SELECT COUNT(*) FROM ANIMAL_BITES WHERE WHEREBITTENIDDESC IS NULL;

UPDATE ANIMAL_BITES
SET WHEREBITTENIDDESC = 'UNKNOWN'
WHERE WHEREBITTENIDDESC IS NULL;


/************************** 7. การแปลงแถวเป็นคอลัมน์ **************************/

--จำนวนเงินเฉลี่ยตามตำแหน่งงาน
SELECT JOB_ID, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEES
WHERE job_id in ('AD_VP', 'FI_ACCOUNT' , 'PU_CLERK')
GROUP BY JOB_ID;


SELECT * 
FROM 
  (
  SELECT 'ค่าเงินเฉลี่ยตามตำแหน่งงาน' หัวข้อ, JOB_ID, SALARY FROM EMPLOYEES
  )
PIVOT
  (
    AVG(SALARY) FOR JOB_ID IN ('AD_VP', 'FI_ACCOUNT', 'PU_CLERK')
  );


--จำนวนแผนกและตำแหน่งงานตามจำนวนเงินเฉลี่ย
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
AND job_id in ('AD_VP', 'FI_ACCOUNT' , 'PU_CLERK')
GROUP BY JOB_ID, DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


SELECT * 
FROM 
  (
  SELECT 'จำนวนแผนกและตำแหน่งงานตามจำนวนเงินเฉลี่ย' หัวข้อ, DEPARTMENT_ID, JOB_ID, SALARY FROM EMPLOYEES
  WHERE DEPARTMENT_ID IS NOT NULL
  AND job_id in ('AD_VP', 'FI_ACCOUNT' , 'PU_CLERK')
  )
PIVOT
  (
    AVG(SALARY) FOR JOB_ID IN ('AD_VP', 'FI_ACCOUNT', 'PU_CLERK')
  )
  ORDER BY DEPARTMENT_ID;

--จำนวนแผนกตามสถานที่
SELECT LOCATION_ID, COUNT(*)
FROM DEPARTMENTS
GROUP BY LOCATION_ID;

select * from (
  SELECT 'จำนวนแผนกตามสถานที่' คำอธิบาย, LOCATION_ID
  FROM DEPARTMENTS t
)
PIVOT 
( 
  COUNT(*) FOR LOCATION_ID IN (1700,1400,2400,1500,1800,2500,2700) 
);



/************************** 8. แปลงแถวเป็นคอลัมน์พร้อมกับการรวมตาราง **************************/

SELECT LISTAGG(CITY)
FROM
  ( SELECT DISTINCT ''''
    ||L.CITY
    ||''',' AS CITY
  FROM DEPARTMENTS D,
    LOCATIONS l
  WHERE D.LOCATION_ID = L.LOCATION_ID
  );

/************************** 8. ยกเลิกการแปลงแถวเป็นคอลัมน์ **************************/

SELECT * 
FROM (
  SELECT 'จำนวนแผนกตามสถานที่' คำอธิบาย, 
  L.CITY
  FROM  DEPARTMENTS D, 
        LOCATIONS l
  WHERE D.LOCATION_ID = L.LOCATION_ID
)
PIVOT (
  COUNT(*) FOR CITY IN ('Seattle' AS Seattle,'Toronto' AS Toronto,'London' AS London, 'Southlake' AS Southlake,
                        'South San Francisco' AS South_San_Francisco, 'Munich' AS Munich, 'Oxford' AS Oxford)
  );


SELECT *
FROM
  (SELECT EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    PHONE_NUMBER,
    JOB_ID,
    TO_CHAR(HIRE_DATE, 'DD/MON/YYYY') AS HIRE_DATE,
    TO_CHAR(SALARY)         AS SALARY,
    TO_CHAR(COMMISSION_PCT) AS COMMISSION_PCT,
    TO_CHAR(MANAGER_ID)     AS MANAGER_ID,
    TO_CHAR(DEPARTMENT_ID)  AS DEPARTMENT_ID
  FROM EMPLOYEES
  ) UNPIVOT ( 
      ATTRIBUTE_NAME FOR ATRIBUTE_VALUE IN ("FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","JOB_ID","HIRE_DATE","SALARY","COMMISSION_PCT","MANAGER_ID","DEPARTMENT_ID") 
      );
