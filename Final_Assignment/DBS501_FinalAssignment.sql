--Jiseok Shim
--122758170
--DBS501NSA
--Q2
--Create procedure that called staff_add and insert new name, job, salary and comm
CREATE OR REPLACE PROCEDURE staff_add (m_name IN STAFF.NAME%TYPE, m_job IN STAFF.JOB%TYPE, m_salary IN STAFF.SALARY%TYPE, m_comm IN STAFF.COMM%TYPE)
AS
--Declare highest_id to make new id 
    highest_id NUMBER(38,0);
BEGIN
--select maximum value of id in staff table and the maximum value is highest_id
    SELECT MAX(id) INTO highest_id FROM staff;
--If highest_id is null then set highest_id = 0
    IF highest_id IS NULL THEN
      highest_id := 0;
    END IF;
--When user put wrong job type that are not from Sales, Clerk and Mgr
    CASE m_job
      WHEN 'Sales' THEN
        NULL;
      WHEN 'Clerk' THEN
        NULL;
      WHEN 'Mgr' THEN
        NULL;
      ELSE
        Raise_application_error(-20001, 'Job is not valid!'); --Display Error and display error message 'Job is not valid!'
    END CASE;
--Insert new data into staff table
    INSERT INTO staff
    VALUES (highest_id + 10, m_name, 90, m_job, 1, m_salary, m_comm);
END;

EXEC staff_add('Jiseok','what', 10000.00, 200.00);
--------------------------------------------------------------------------------------
--Q3
--Create trigger that called ins_job, Insert data into staff table 
CREATE OR REPLACE TRIGGER ins_job 
AFTER INSERT ON staff
FOR EACH ROW
--Declare new m_id that type is same as original id from staff table
DECLARE
m_id NUMBER(38,0);
m_incjob CHAR(5 BYTE); --Declare new m_incjob that type is same as original job type from staff table
BEGIN
 IF INSERTING THEN        --If insert data 
   m_id := :NEW.ID;        --Set m_id is new inserted id value
   m_incjob := :NEW.JOB;   --Set m_incjob is new inserted job value
 END IF;                   --end if

  IF INSERTING THEN           --If inserting data 
   IF m_incjob NOT IN ('Clerk', 'Sales', 'Mgr') THEN        --If m_incjob is not Clerk, Sales, and Mgr then
      INSERT INTO staffaudtbl VALUES(m_id, m_incjob);       --Insert m_id and m_incjob into staffaudtbl
   END IF; --End if loop
  END IF; --End if loop
END;  --End Trigger

INSERT INTO staff (ID, NAME, DEPT, JOB, YEARS, SALARY, COMM) VALUES (360, 'Jiseok', 1, 'Clerk', 1, 10000.00, 100.00);
INSERT INTO staff (ID, NAME, DEPT, JOB, YEARS, SALARY, COMM) VALUES (360, 'Jiseok', 1, 'Sales', 1, 10000.00, 100.00);
INSERT INTO staff (ID, NAME, DEPT, JOB, YEARS, SALARY, COMM) VALUES (360, 'Jiseok', 1, 'Mgr', 1, 10000.00, 100.00);
INSERT INTO staff (ID, NAME, DEPT, JOB, YEARS, SALARY, COMM) VALUES (360, 'Jiseok', 1, 'M', 1, 10000.00, 100.00);
INSERT INTO staff (ID, NAME, DEPT, JOB, YEARS, SALARY, COMM) VALUES (360, 'Jiseok', 1, 'err', 1, 10000.00, 100.00);

CREATE TABLE STAFFAUDTBL(ID NUMBER(38,0) NOT NULL, INCJOB CHAR (5 BYTE));

---------------------------------------------------------------------------------------
--Q4
--Create function that called total_cmp and insert id_in that type is number
CREATE OR REPLACE FUNCTION total_cmp (id_in IN NUMBER)
RETURN NUMBER                      --Return type is NUMBER
IS
  retval NUMBER;                   --Declare retval number type
  no_id EXCEPTION;
BEGIN
  SELECT sum(salary + comm)       --Get sum of salary and comm 
   INTO retval                     --sum of salary+comm is retval 
   FROM staff                      --From staff table
   WHERE id = id_in;               --which id is id_in
   IF retval =  NULL THEN
    RAISE no_id;
   END IF;
  RETURN retval;                  --Function total_cmp return value of retval
  EXCEPTION
   WHEN no_id THEN                         --Error handling when user input invalid id
    raise_application_error (-20001,'Invalid ID');     --Display 'Wrong ID!'
END; --End Function

SELECT total_cmp(350) FROM dual;
select * from staff where id = 350;


-----------------------------------------------------------------------------------------
--Q5
--Create procedure that called set_comm
CREATE OR REPLACE PROCEDURE set_comm
AS 
BEGIN
 UPDATE STAFF                         --Update table staff
 SET COMM = CASE                      --Update comm value to CASE(for example, salary*0.2)
  WHEN JOB = 'Mgr' THEN salary*0.2    --When job is 'Mgr' then set comm value to (salary*0.2)
  WHEN JOB = 'Clerk' THEN salary*0.1  --When job is 'Clerk' then set comm value to (salary*0.1)
  WHEN JOB = 'Sales' THEN salary*0.3  --When job is 'Sales' then set comm value to (salary*0.3)
  WHEN JOB = 'Prez' THEN salary*0.5   --When job is 'Prez' then set comm value to (salary*0.5)
 END;
END;
--Create trigger that called upd_comm
CREATE OR REPLACE TRIGGER upd_comm
AFTER UPDATE OF COMM ON STAFF         --Update COMM column of staff table
FOR EACH ROW
BEGIN
 INSERT INTO staffaudtbl VALUES (:OLD.ID, NULL,:OLD.COMM, :NEW.COMM);      --Insert new data into staffaudtbl table
END;                                                                       --Original id value, null, original comm value, new comm value

execute set_comm;                               --Execute set_comm procedure
select * from staffaudtbl;

ALTER TABLE staffaudtbl 
ADD OLDCOMM NUMBER(7,2)
ADD NEWCOMM NUMBER(7,2);
-----------------------------------------------------------------------------------------
--Q6
--Create trigger that called staff_trig, combined with ins_job trigger and upd_comm trigger
CREATE OR REPLACE TRIGGER staff_trig
AFTER INSERT OR UPDATE OF COMM OR DELETE ON staff --Trigger has insert, update, and delete state
FOR EACH ROW
--Declare new m_id that type is same as original id from staff table
DECLARE
m_id NUMBER(38,0);
m_incjob CHAR(5 BYTE); --Declare new m_incjob that type is same as original job type from staff table
m_action CHAR(3 BYTE);
BEGIN
 IF INSERTING THEN        --If insert data 
   m_id := :NEW.ID;        --Set m_id is new inserted id value
   m_incjob := :NEW.JOB;   --Set m_incjob is new inserted job value
 ELSIF DELETING THEN        --If insert data 
   m_id := :OLD.ID;        --Set m_id is new inserted id value
   m_incjob := :OLD.JOB;   --Set m_incjob is new inserted job value
 END IF;                   --end if
 
 IF INSERTING THEN           --If inserting data 
  m_action := 'I';
   IF m_incjob NOT IN ('Clerk', 'Sales', 'Mgr') THEN        --If m_incjob is not Clerk, Sales, and Mgr then
      INSERT INTO staffaudtbl VALUES(m_id, m_incjob);       --Insert m_id and m_incjob into staffaudtbl
   END IF; --End if loop
 ELSIF UPDATING THEN
  m_action := 'U';
  INSERT INTO staffaudtbl VALUES (:OLD.ID, NULL,:OLD.COMM, :NEW.COMM);      --Insert new data into staffaudtbl table
 ELSIF DELETING THEN
   m_action := 'D';
   INSERT INTO staffaudtbl VALUES (:OLD.ID, NULL,:OLD.COMM, :NEW.COMM); --Make record into a staffaudtbl
   DELETE FROM VACATION WHERE m_id = :OLD.ID;  --Delete data which is v_empno is original EMPNO
  END IF;
END;

-----------------------------------------------------------------------------------------
--Q7
--Create function that called fun_name and input is in_name(type-varchar2)
CREATE OR replace FUNCTION fun_name ( 
in_name  IN VARCHAR2
)return VARCHAR2   --Return type is varchar2
IS 
BEGIN
     return regexp_replace(initcap(regexp_replace(in_name,'(..)','\1 ')),'(..) ','\1'); --Return value that is " regexp_replace(initcap(regexp_replace(in_name,'(..)','\1 ')),'(..) ','\1')"
end;                        --Use "regexp_replace" to replace in_name alphabet split, Use initcap to make first character in each word to be converted to uppercase    
                             --And Use "regexp_replace" to make words together                              

SELECT fun_name('Smith') from dual;      --Call function fun_name with parameter 'Smith'; 
SELECT fun_name('Robertson') from dual;  --Call function fun_name with parameter 'Robertson';

-----------------------------------------------------------------------------------------
--Q8
--Create function that called vowel_cnt, and input column name (string1)
CREATE OR REPLACE FUNCTION vowel_cnt (string1 IN VARCHAR2) 
RETURN NUMBER
IS
  i NUMBER(3) := 0;     --i is type number and value is 0
  j NUMBER(3) := 0;     --j is type number and value is 0
BEGIN
  WHILE i < LENGTH(string1) LOOP     --Make a loop when stop the loop i is reach number that rows of input column
     IF SUBSTR(string1, i, 1) IN ('A','a','E','e','I','i','O','o','U','u') THEN  --If the "i"th row of string1 meets the vowel, add 1 to j
        j := j + 1;
     END IF; --End if loop
     i := i +1; --Add 1 to i
  END LOOP;  --End WHILE loop
  RETURN j; --Function return j value
   IF j = 0 THEN          --When j is 0 that is mean string1 column has no rows
    Raise_application_error(-20001, 'There is no row in this column');  --Display error message
  END IF;  --End if loop
END; --End Function

SELECT vowel_cnt(NAME) FROM staff;
SELECT vowel_cnt(JOB) FROM staff;
-----------------------------------------------------------------------------------------
--Q9
--Create package that called staff_pck 
CREATE OR REPLACE PACKAGE staff_pck IS   --Write package specification, This package contain 2 procedures and 3 functions
PROCEDURE staff_add (m_name IN STAFF.NAME%TYPE, m_job IN STAFF.JOB%TYPE, m_salary IN STAFF.SALARY%TYPE, m_comm IN STAFF.COMM%TYPE); --Procedure staff_add
PROCEDURE set_comm;   --Procedure set_comm
FUNCTION total_cmp (id_in IN NUMBER) --Procedure total_cmp
RETURN NUMBER;
FUNCTION fun_name (in_name  IN VARCHAR2) --Procedure fun_name
return VARCHAR2;
FUNCTION vowel_cnt (string1 IN VARCHAR2)  --Procedure vowel_cnt
RETURN NUMBER;
END staff_pck; --End package specification

--Create package body
CREATE OR REPLACE PACKAGE BODY staff_pck IS
PROCEDURE staff_add (m_name IN STAFF.NAME%TYPE, m_job IN STAFF.JOB%TYPE, m_salary IN STAFF.SALARY%TYPE, m_comm IN STAFF.COMM%TYPE)
AS
--Declare highest_id to make new id 
    highest_id NUMBER(38,0);
BEGIN
--select maximum value of id in staff table and the maximum value is highest_id
    SELECT MAX(id) INTO highest_id FROM staff;
--If highest_id is null then set highest_id = 0
    IF highest_id IS NULL THEN
      highest_id := 0;
    END IF;
--When user put wrong job type that are not from Sales, Clerk and Mgr
    CASE m_job
      WHEN 'Sales' THEN
        NULL;
      WHEN 'Clerk' THEN
        NULL;
      WHEN 'Mgr' THEN
        NULL;
      ELSE
        Raise_application_error(-20001, 'Job is not valid!'); --Display Error and display error message 'Job is not valid!'
    END CASE;
--Insert new data into staff table
    INSERT INTO staff
    VALUES (highest_id + 10, m_name, 90, m_job, 1, m_salary, m_comm);
END staff_add;

PROCEDURE set_comm
AS 
BEGIN
 UPDATE STAFF                         --Update table staff
 SET COMM = CASE                      --Update comm value to CASE(for example, salary*0.2)
  WHEN JOB = 'Mgr' THEN salary*0.2    --When job is 'Mgr' then set comm value to (salary*0.2)
  WHEN JOB = 'Clerk' THEN salary*0.1  --When job is 'Clerk' then set comm value to (salary*0.1)
  WHEN JOB = 'Sales' THEN salary*0.3  --When job is 'Sales' then set comm value to (salary*0.3)
  WHEN JOB = 'Prez' THEN salary*0.5   --When job is 'Prez' then set comm value to (salary*0.5)
 END;
END set_comm;

FUNCTION total_cmp (id_in IN NUMBER)
RETURN NUMBER                      --Return type is NUMBER
IS
  retval NUMBER;                   --Declare retval number type
  no_id EXCEPTION;
BEGIN
  SELECT sum(salary + comm)       --Get sum of salary and comm 
   INTO retval                     --sum of salary+comm is retval 
   FROM staff                      --From staff table
   WHERE id = id_in;               --which id is id_in
   IF retval =  NULL THEN
    RAISE no_id;
   END IF;
  RETURN retval;                  --Function total_cmp return value of retval
  EXCEPTION
   WHEN no_id THEN                         --Error handling when user input invalid id
    raise_application_error (-20001,'Invalid ID');     --Display 'Wrong ID!'
END total_cmp;

FUNCTION fun_name ( 
in_name  IN VARCHAR2
)return VARCHAR2   --Return type is varchar2
IS 
BEGIN
     return regexp_replace(initcap(regexp_replace(in_name,'(..)','\1 ')),'(..) ','\1'); --Return value that is " regexp_replace(initcap(regexp_replace(in_name,'(..)','\1 ')),'(..) ','\1')"
END fun_name;                        --Use "regexp_replace" to replace in_name alphabet split, Use initcap to make first character in each word to be converted to uppercase And Use "regexp_replace" to make words together   
    
FUNCTION vowel_cnt (string1 IN VARCHAR2) 
RETURN NUMBER
IS
  i NUMBER(3) := 0;     --i is type number and value is 0
  j NUMBER(3) := 0;     --j is type number and value is 0
BEGIN
  WHILE i < LENGTH(string1) LOOP     --Make a loop when stop the loop i is reach number that rows of input column
     IF SUBSTR(string1, i, 1) IN ('A','a','E','e','I','i','O','o','U','u') THEN  --If the "i"th row of string1 meets the vowel, add 1 to j
        j := j + 1;
     END IF; --End if loop
     i := i +1; --Add 1 to i
  END LOOP;  --End WHILE loop
  RETURN j; --Function return j value
   IF j = 0 THEN          --When j is 0 that is mean string1 column has no rows
    Raise_application_error(-20001, 'There is no row in this column');  --Display error message
  END IF;  --End if loop
END vowel_cnt; --End Function    
END staff_pck;  --End package body

