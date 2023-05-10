--DBS501 Assignment3
--Jiseok Shim
--122758170
--Part2
SET SERVEROUTPUT ON;                   
CREATE OR REPLACE TRIGGER varpaychk      --Create trigger that called varpaychk
 AFTER INSERT OR UPDATE ON employee      --record is inserted or updated into employee table
 FOR EACH ROW

DECLARE                                  --Declare new column and type same as original column in employee table
 v_bonus decimal(9,2);
 v_commission decimal(9,2);
 v_errorcode char(1);
 v_salary decimal(9,2);
 v_operation char(1);
 v_empid char(6);
 v_workdept char(3);
BEGIN
  IF INSERTING THEN                       --When Insert data into employee table
    v_empid := :NEW.empno;                --Set v_empid is new inserted empno
    v_salary := :NEW.salary;              --Set v_salary is new inserted salary
    v_commission := :NEW.comm;             --Set v_commission is new inserted comm
    v_bonus := :NEW.bonus;                 --Set v_bonus is new inserted bonus
    v_workdept := :NEW.workdept;           --Set v_workdept is new inserted workdept
  end if;
   IF UPDATING THEN                       --When update data in employee table
    v_empid := :OLD.empno;                --Set v_empid is original data from employee 
    v_salary := :NEW.salary;              --Set v_salary is new updated salary data
    v_commission := :NEW.comm;            --Set v_commission is new updated comm data
    v_bonus := :NEW.bonus;                --Set v_bonus is new updated bonus
    v_workdept := :NEW.workdept;          --Set v_workdept is new updated workdept data
  end if;
    if (v_bonus + v_commission) >= (v_salary*40/100) then      --If v_bonus plus v_commission is equal or greater than 40% of v_salary
      v_errorcode := 'S';                                      --v_errorcode is S
    elsif v_bonus >= (v_salary*20/100) then                    --If v_bonus is equal or greater than 20% of v_salary
      v_errorcode := 'B';                                      --Set v_errorcode is B
    elsif v_commission >= (v_salary*25/100) then               --If v_commission is equal or greater than 25% of v_salary
      v_errorcode := 'C';                                      --Set v_errorcode is C
    end if;
    if v_errorcode = 'B' OR v_errorcode ='S' OR v_errorcode = 'C' then     --Only when v_errocode is B or S or C 
     if inserting then                                                     --When insert data into employee
      v_operation := 'I';                                                  --Set v_operation is I
      insert into empaudit values(v_empid, v_errorcode, v_operation, v_workdept ,v_salary, v_bonus, v_commission);  --Insert new data into empaudit table
      end if;
     if updating then                                                       --When update data 
      UPDATE empaudit SET ERRORCODE = v_errorcode WHERE v_empid = :OLD.EMPNO;--Update new ERRORCODE value
      UPDATE empaudit SET OPERATION = 'U' WHERE v_empid = :OLD.EMPNO;         --Update new OPERATION to U 
      UPDATE empaudit SET SALARY = v_salary WHERE v_empid = :OLD.EMPNO;         --Update new SALARY value
      UPDATE empaudit SET BONUS = v_bonus WHERE v_empid = :OLD.EMPNO;        --Update new BONUS value
      UPDATE empaudit SET COMM = v_commission WHERE v_empid = :OLD.EMPNO;    --Update new COMM value
     end if;
    end if;  
    EXCEPTION
    WHEN NO_DATA_FOUND THEN                                  --Error handling when trigger cannot find data 
      RAISE_APPLICATION_ERROR(-20001,'NO DATA FOUND');       --Then Display NO DATA FOUND
END;
--insert data
INSERT into employee (EMPNO , FIRSTNAME , MIDINIT , LASTNAME , WORKDEPT , PHONENO , HIREDATE , JOB , EDLEVEL , SEX , BIRTHDATE , SALARY , BONUS , COMM)
values('333332','EILEEN','W','HENDERSON','E11','5498',to_date(20000815),'MANAGER ',16,'F',to_date(19710515),0009750.00,0003600.00,0002380.00);
--update data
update employee SET BONUS = 2500 WHERE EMPNO = '111111';
--multi row insert
INSERT all
into employee (EMPNO , FIRSTNAME , MIDINIT , LASTNAME , WORKDEPT , PHONENO , HIREDATE , JOB , EDLEVEL , SEX , BIRTHDATE , SALARY , BONUS , COMM)
values('111114','EILEEN','W','HENDERSON','E11','5498',to_date(20000815),'MANAGER ',16,'F',to_date(19710515),0010000.00,0000000.00,0002500.00)
into employee (EMPNO , FIRSTNAME , MIDINIT , LASTNAME , WORKDEPT , PHONENO , HIREDATE , JOB , EDLEVEL , SEX , BIRTHDATE , SALARY , BONUS , COMM) 
values('111115','EILEEN','W','HENDERSON','E11','5498',to_date(20000815),'MANAGER ',16,'F',to_date(19710515),0010000.00,0000000.00,0002500.00)
select * from dual;

---------------------------------------------------------------------------------------------------------------------------------------------
--Part3
CREATE OR REPLACE TRIGGER nomgr                    --Create trigger that called nomgr 
AFTER INSERT OR UPDATE OR DELETE ON employee       --Insert or Update or Delete data in employee table
FOR EACH ROW
DECLARE                                           
 v_count INTEGER;
 v_job CHAR(8);
 v_workdept CHAR(3);
BEGIN
 -- If inserting or updating, check if there is a manager for the work dept
 IF INSERTING OR UPDATING THEN
   SELECT COUNT(*) INTO v_count
   FROM employee
   WHERE job = 'MANAGER'
   AND workdept = :NEW.WORKDEPT;

   -- If there is not a manager, update the record to set the work dept to 000
   IF v_count = 0 THEN
   :NEW.WORKDEPT := '000';

     -- Insert a record into the empaudit table
     INSERT INTO empaudit
     VALUES (:new.empno, :old.workdept, 'NOMGR');
   END IF;
 END IF;

 -- If deleting, check if the deleted row is a manager
 IF DELETING THEN
   v_job := :old.job;
   v_workdept := :old.workdept;

   -- If the deleted row is a manager, update all employees in that dept to 000
   IF v_job = 'MANAGER' THEN 
   FOR emp IN (SELECT * FROM employee WHERE workdept = v_workdept) LOOP
       UPDATE employee
       SET workdept = '000'
       WHERE empno = emp.empno;

       -- Insert a record into the empaudit table
       INSERT INTO empaudit
       VALUES (emp.empno, v_workdept, 'NOMGR');
     END LOOP;
   END IF;
 END IF;
END;
drop trigger nomgr;

-------------------------------------------------------------------------------------------------------------
--Part4
CREATE OR REPLACE TRIGGER empvac                 --Create trigger that called empvac
AFTER INSERT OR UPDATE OR DELETE ON EMPLOYEE     --Record inserted or updated or deleted on employee table
FOR EACH ROW
DECLARE                             --Declare new column and type same as original column in employee table
    v_empno char(6);
    v_hiredate DATE;
    v_vacationdays NUMBER(3);
BEGIN
    IF INSERTING THEN                      --When insert data into employee table
        v_empno := :NEW.EMPNO;             --Set v_empno is new inserted empno data
        v_hiredate := :NEW.HIREDATE;       --Set v_hiredate is new inserted HIREDATE data
    ELSIF UPDATING THEN
        v_empno := :OLD.EMPNO;             --Set v_empno is OLD empno data
        v_hiredate := :NEW.HIREDATE;       --Set v_hiredate is new updated HIREDATE data
    ELSIF DELETING THEN
        v_empno := :OLD.EMPNO;             --Set v_empno is OLD empno data
        v_hiredate := :OLD.HIREDATE;       --Set v_hiredate is OLD HIREDATE data
    END IF;
    IF SYSDATE - v_hiredate < 3650 THEN     --If SYSDATE(today) - v_hiredate is less than 10years(= 3650 days)
        v_vacationdays := 15;               --Set v_vacationdays is 15days
    ELSIF SYSDATE - v_hiredate < 7300 THEN  --If SYSDATE(today) - v_hiredate is greater than 10 years and less than 19years(= 7300 days)
        v_vacationdays := 20;                --Set v_vacationdays is 15days
    ELSIF SYSDATE - v_hiredate < 10950 THEN  --If SYSDATE(today) - v_hiredate is greater than 20 and less than 29years(= 10950 days)
        v_vacationdays := 25;                --Set v_vacationdays is 15days
    ELSE                                     --If SYSDATE(today) - v_hiredate is greater than 30years
        v_vacationdays := 30;                --Set v_vacationdays is 15days
    END IF;
    IF INSERTING THEN                    --When insert new data into employee 
        INSERT INTO VACATION VALUES (v_empno, v_hiredate, v_vacationdays);  --Insert data into vacation table 
    ELSIF UPDATING THEN                  --When update data in employee
        UPDATE VACATION SET VACATION_DAYS = v_vacationdays WHERE v_empno = :OLD.EMPNO; --Update VACATION_DAYS = new v_vacationdays which v_empno is original empno
        UPDATE VACATION SET HIREDATE = v_hiredate WHERE v_empno = :OLD.EMPNO;    --Update HIREDATE = new v_hiredate which v_empno is original empno
    ELSIF DELETING THEN                  --When delete data in employee 
        DELETE FROM VACATION  WHERE v_empno = :OLD.EMPNO;     --Delete data which is v_empno is original EMPNO
    END IF;
     EXCEPTION
    WHEN NO_DATA_FOUND THEN                                  --Error handling when trigger cannot find data 
      RAISE_APPLICATION_ERROR(-20001,'NO DATA FOUND');       --Then Display NO DATA FOUND
END;
--insert data
INSERT into employee (EMPNO , FIRSTNAME , MIDINIT , LASTNAME , WORKDEPT , PHONENO , HIREDATE , JOB , EDLEVEL , SEX , BIRTHDATE , SALARY , BONUS , COMM)
values('333332','EILEEN','W','HENDERSON','E11','5498',to_date(20220815),'MANAGER ',16,'F',to_date(19710515),0009750.00,0003600.00,0002380.00);
--update data
update employee set HIREDATE = to_date(19800815) where EMPNO = '33333333';
--delete data
delete from employee where empno = '333333';