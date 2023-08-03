-- เลือกข้อมูลจากตาราง customers
SELECT * FROM customers;

-- เลือกข้อมูลจากตาราง stores
SELECT * FROM stores;

-- เลือกข้อมูลจากตาราง products
SELECT * FROM products;

-- เลือกข้อมูลจากตาราง orders
SELECT * FROM orders;

-- เลือกข้อมูลจากตาราง shipments
SELECT * FROM shipments;

-- เลือกข้อมูลจากตาราง inventory
SELECT * FROM inventory;

-- เลือกข้อมูลจากตาราง order_items
SELECT * FROM order_items;

-- ลบข้อมูลในตาราง order_items
truncate table order_items;

/************************** 2. Split full name into first name and last name **************************/
--ex: FIRST_NAME: Tammy , LAST_NAME: Bryant

-- แสดงข้อมูลที่ FIRST_NAME หรือ LAST_NAME ไม่เป็นค่าว่าง
SELECT *
FROM customers
WHERE FIRST_NAME IS NOT NULL
OR LAST_NAME     IS NOT NULL;

-- แยกชื่อและนามสกุลจากคอลัมน์ FULL_NAME
SELECT FULL_NAME,
  SUBSTR(FULL_NAME, 1, INSTR(FULL_NAME, ' ')-1) AS FIRST_NAME,
  SUBSTR(FULL_NAME, INSTR(FULL_NAME, ' ')   +1) AS LAST_NAME
FROM CUSTOMERS;

-- อัปเดตคอลัมน์ FIRST_NAME และ LAST_NAME
UPDATE CUSTOMERS
SET FIRST_NAME = SUBSTR(FULL_NAME, 1, INSTR(FULL_NAME, ' ')-1),
  LAST_NAME    = SUBSTR(FULL_NAME, INSTR(FULL_NAME, ' ')   +1);

COMMIT;

/************************** 3. Correct phone numbers and email which are not in proper format **************************/

-- เพิ่ม .com ในอีเมลที่ยังไม่มี
SELECT * 
FROM CUSTOMERS
WHERE upper(EMAIL_ADDRESS) LIKE upper('%.com%');

-- อัปเดตอีเมลที่ไม่มี .com
UPDATE CUSTOMERS
SET EMAIL_ADDRESS = EMAIL_ADDRESS || '.com'
WHERE upper(EMAIL_ADDRESS) NOT LIKE upper('%.com%');

COMMIT;

-- นับจำนวนเรคคอร์ดที่มี . ในเบอร์โทรศัพท์
SELECT COUNT(*) 
FROM CUSTOMERS
WHERE CONTACT_NUMBER LIKE '%.%';

-- แสดงเบอร์โทรศัพท์และลบ . ออก
SELECT CONTACT_NUMBER, SUBSTR(CONTACT_NUMBER, 1, INSTR(CONTACT_NUMBER, '.')-1)
FROM CUSTOMERS
WHERE CONTACT_NUMBER LIKE '%.%';

-- อัปเดตเบอร์โทรศัพท์ที่มี .
UPDATE CUSTOMERS
SET CONTACT_NUMBER = SUBSTR(CONTACT_NUMBER, 1, INSTR(CONTACT_NUMBER, '.')-1)
WHERE CONTACT_NUMBER LIKE '%.%';

COMMIT;

/************************** 4. Correct contact number and remove full name **************************/

-- นับจำนวนเรคคอร์ดที่มีจำนวนหลักน้อยกว่า 10
SELECT CONTACT_NUMBER, LENGTH(CONTACT_NUMBER) 
FROM customers
WHERE LENGTH(CONTACT_NUMBER) < 10;

-- อัปเดตเบอร์โทรศัพท์ที่มีจำนวนหลักน้อยกว่า 10 เป็น 9999999999
UPDATE CUSTOMERS
SET CONTACT_NUMBER = 9999999999
WHERE LENGTH(CONTACT_NUMBER) < 10;

COMMIT;

-- แสดงเบอร์โทรศัพท์ที่มีจำนวนหลักมากกว่า 10
SELECT CONTACT_NUMBER, LENGTH(CONTACT_NUMBER) 
FROM customers
WHERE LENGTH(CONTACT_NUMBER) > 10;

-- แสดงความยาวที่แตกต่างของเบอร์โทรศัพท์
SELECT distinct LENGTH(CONTACT_NUMBER) 
FROM customers;

-- ลบคอลัมน์ FULL_NAME ออกจากตาราง customers
ALTER TABLE customers DROP COLUMN FULL_NAME;

/************************** 5. Read BLOB column and fetch attribute details from regular tag **************************/

-- แสดงข้อมูลจากคอลัมน์ BLOB และแยกแอตทริบิวต์ออกมา
SELECT PRODUCT_ID,
  PRODUCT_NAME,
  UNIT_PRICE,
  PRODUCT_DETAILS,
  COLOUR_NAME,
  GENDER_TYPE
FROM PRODUCTS,
     JSON_TABLE 
      ( 
        PRODUCTS.PRODUCT_DETAILS 
        COLUMNS 
            ( COLOUR_NAME VARCHAR2(50) PATH '$.colour',
              GENDER_TYPE VARCHAR2(20) PATH '$.gender' ) 
        );

/************************** 6. Read BLOB column and fetch attribute details from nested columns **************************/

-- แสดงข้อมูลจากคอลัมน์ BLOB และแยกแอตทริบิวต์ออกมา
SELECT PRODUCT_ID, PRODUCT_NAME, UNIT_PRICE, PRODUCT_DETAILS, RATING, REVIEWS
FROM PRODUCTS, 
  json_table (
    PRODUCTS.PRODUCT_DETAILS, '$.reviews[*]'
    COLUMNS (
        RATING NUMBER PATH '$.rating',
        REVIEWS VARCHAR2(200) PATH '$.review'
      )
);

/***************** 7. Create separate tables for with blob attributes **************************/

-- สร้างตาราง PRODUCT_DETAILS สำหรับคอลัมน์ทั่วไป
CREATE TABLE PRODUCT_DETAILS AS
SELECT PRODUCT_ID,
  PRODUCT_NAME,
  UNIT_PRICE,
  COLOUR_NAME,
  GENDER_TYPE,
  BRAND,
  DESCRIPTION,
  SIZES
FROM PRODUCTS,
     JSON_TABLE 
      ( 
        PRODUCTS.PRODUCT_DETAILS 
        COLUMNS 
            ( COLOUR_NAME VARCHAR2(50) PATH '$.colour',
              GENDER_TYPE VARCHAR2(20) PATH '$.gender',
              brand,
              description,
              sizes FORMAT JSON
              )
        );
        
-- สร้างตาราง PRODUCT_RATING สำหรับคอลัมน์ซ้อนกัน
CREATE TABLE PRODUCT_RATING AS
SELECT PRODUCT_ID, RATING, REVIEWS
FROM PRODUCTS, 
  json_table (
    PRODUCTS.PRODUCT_DETAILS, '$.reviews[*]'
    COLUMNS (
        RATING NUMBER PATH '$.rating',
        REVIEWS VARCHAR2(200) PATH '$.review'
      )
);

-- เข้าร่วมตารางทั้งสอง
SELECT * FROM 
PRODUCT_DETAILS LEFT JOIN PRODUCT_RATING
ON PRODUCT_DETAILS.PRODUCT_ID = PRODUCT_RATING.PRODUCT_ID

/***************** 8. Remove invalid records from order_items where shipment_id is not mapped **************************/

-- นับจำนวนเรคคอร์ดที่ SHIPMENT_ID เป็นค่าว่าง
SELECT COUNT(*) 
FROM order_items
WHERE SHIPMENT_ID IS NULL;

-- แสดงเรคคอร์ดที่ SHIPMENT_ID เป็นค่าว่าง
SELECT * FROM order_items
WHERE SHIPMENT_ID IS NULL;

-- ลบเรคคอร์ดที่ SHIPMENT_ID เป็นค่าว่าง
DELETE FROM ORDER_ITEMS
WHERE SHIPMENT_ID IS NULL;

COMMIT;

/***************** 9. Map missing first name and last name with email id credentials **************************/

-- แสดงเรคคอร์ดที่ FIRST_NAME หรือ LAST_NAME เป็นค่าว่าง
SELECT * 
FROM customers
WHERE FIRST_NAME IS NULL
OR LAST_NAME IS NULL;

-- แยกชื่อและนามสกุลจากอีเมล
SELECT EMAIL_ADDRESS,
  SUBSTR(EMAIL_ADDRESS, 1, INSTR(EMAIL_ADDRESS, '.')-1) FIRST_NAME,
  SUBSTR(EMAIL_ADDRESS, INSTR(EMAIL_ADDRESS, '.')+1, 
                        INSTR(SUBSTR(EMAIL_ADDRESS, INSTR(EMAIL_ADDRESS, '.')+1), '@')-1) LAST_NAME
FROM customers
WHERE FIRST_NAME IS NULL
OR LAST_NAME IS NULL;

-- อัปเดตชื่อและนามสกุล
UPDATE CUSTOMERS 
SET FIRST_NAME = SUBSTR(EMAIL_ADDRESS, 1, INSTR(EMAIL_ADDRESS, '.')-1),
    LAST_NAME = SUBSTR(EMAIL_ADDRESS, INSTR(EMAIL_ADDRESS, '.')+1, 
                      INSTR(SUBSTR(EMAIL_ADDRESS, INSTR(EMAIL_ADDRESS, '.')+1), '@')-1)
WHERE FIRST_NAME IS NULL
OR LAST_NAME IS NULL;

COMMIT;