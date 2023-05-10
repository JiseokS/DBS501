--Jiseok Shim
--122758170
--DBS501NSA
--2022-09-28
/*Q1*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE even_odd(Input IN NUMBER) AS            --make procedure that named even_odd and parameter is Input(number)
BEGIN
 IF MOD(Input, 2) = 0                                               --Use MOD to devide Input by 2
 THEN 
 DBMS_OUTPUT.PUT_LINE('The number is even');                        --If Input /2 = 0 display "The number is even."
 ELSE
 DBMS_OUTPUT.PUT_LINE('The number is odd');                         --If Input /2 != 0 display "The number is odd."
 END IF;                                                            --End if loop 
END;

EXECUTE even_odd(20);                                               
EXECUTE even_odd(7);


/*Q2*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE factorial(n IN NUMBER)AS              --create procedure that called factorial and the parameter is n (type is number)
total INT := 1;                                                  --declare total as integer type and make it as '1'
str VARCHAR(255) := n || '!' || ' = ' || 'fact(' || n ||') = ';  --make str format as above example "n! = fact(n) ="
BEGIN
 IF n = 0 THEN                                                    --initiate below command when num is 0
 DBMS_OUTPUT.PUT_LINE(n || '! = '|| n);                           --display "n! = n
 ELSE
   FOR i IN REVERSE 1.. n LOOP                                      --initiate i = n and when first loop is done i = i-1 until i = 1
   total := total*i;
     IF i = n THEN                                                   --IF i is n initiate below command 
     str := str || i;
     ELSE                                                            --IF i is not n initiate below command
     str := str || ' * ' || i;
     END IF;                                                         --End IF Loop
   END LOOP;                                                        --End Loop
 DBMS_OUTPUT.PUT_LINE(str || ' = ' || total);                     --display str = total
 END IF;                                                          --End IF loop
EXCEPTION                                                         --Error handling if user input that is not number the procedure print ERROR!
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR!');
END;

EXECUTE factorial(0);
EXECUTE factorial(3);
EXECUTE factorial(a);

/*Q3*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE calculate_salary(emp_id IN NUMBER) AS          --make procedure that called calculate_salary and parameter is emp_id 
fname VARCHAR(255 BYTE);
lname VARCHAR(255 BYTE);
salary NUMBER(8,2) := 10000;
hiredate DATE;
careeryear INT;
BEGIN
  SELECT first_name, last_name, hire_date INTO fname, lname, hiredate     --Get values from first_name last_name and hire_date and put values into fname, lname, and hiredate
  FROM employees
  WHERE employee_id = emp_id;                                             --only when employee_id is emp_id
  careeryear := FLOOR(MONTHS_BETWEEN(SYSDATE,hiredate)/12);               --calculate months between today and hiredate and divide by 12 = years. and use floor to make it integer value
  FOR i IN 1.. careeryear LOOP                                            --Use FOR LOOP start with i = 1 and when first loop is done i= i + 1 until i = careeryears 
    salary := salary * 1.05;                                              
  END LOOP;                                                               --End FOR LOOP
DBMS_OUTPUT.PUT_LINE ('First Name: ' || fname);                           --display firstname , lastname, and salary
DBMS_OUTPUT.PUT_LINE ('Last Name: '|| lname);
DBMS_OUTPUT.PUT_LINE ('Salary: $' || salary);
EXCEPTION
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE ('ERROR!');                                         --When calculate_salary function is not working display ERROR!
END;

BEGIN
calculate_salary(100);
END;

/*Q4*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE find_employee(empNumber IN NUMBER) AS               --Make prodecure that called find_employee and the parameter is empNumber(number)
firstName VARCHAR(256 BYTE);                                                    --Make firstname that is char type and size is 256 byte
lastName VARCHAR (256 BYTE);                                                    --Make lastName that is char type and size is 256 byte
EmailAddress VARCHAR (256 BYTE);                                                --Make EmailAddress that is char type and size is 256 byte
PhoneNumber VARCHAR (256 BYTE);                                                 --Make PhoneNumber that is char type and size is 256 byte
hireDate VARCHAR (256 BYTE);                                                    --Make hireDate that is char type and size is 256 byte
jobTitle VARCHAR (256 BYTE);                                                    --Make jobTitle that is char type and size is 256 byte

BEGIN
  SELECT first_name, last_name, email, phone, hire_date, job_Title              --Copy values of first_name, last_name, email, phone, hire_date and job_title 
  INTO firstName,lastName,EmailAddress,PhoneNumber,hireDate,jobTitle            --to firstName, lastName, EmailAddress, PhoneNumber, hireDate, jobTitle
  FROM employees
  WHERE employee_id = empNumber;                                                

  DBMS_OUTPUT.PUT_LINE ('First Name: '|| firstName);                            --Display firstname
  DBMS_OUTPUT.PUT_LINE ('Last Name: '|| lastName);                              --Display lastName
  DBMS_OUTPUT.PUT_LINE ('Email: '|| EmailAddress);                              --Display EmailAddress
  DBMS_OUTPUT.PUT_LINE ('Phone: '|| PhoneNumber);                               --Display PhoneNumber
  DBMS_OUTPUT.PUT_LINE ('Hire Date: '|| hireDate);                              --Display hireDate
  DBMS_OUTPUT.PUT_LINE ('Job Title: '|| jobTitle);                              --Display jobTitle

IF SQL %ROWCOUNT = 0                                                            --For implicit cursors
THEN 
DBMS_OUTPUT.PUT_LINE ('Employee ID '|| empNumber||'Not found');                 --If rowcount is 0 display employee ID -- not found.
END IF;
EXCEPTION  
WHEN OTHERS
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR!');                                                --Display ERROR!
END;

BEGIN
find_employee(107);                                                             --Select employee number 107 and display information
END;