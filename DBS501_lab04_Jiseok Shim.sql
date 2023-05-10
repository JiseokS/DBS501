--Q1
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION pig_latin(m_name CHAR)       --create function that is called pig_latin and input m_name 
RETURN CHAR                                             --return type is char
IS 
 v char;                                                
 new_name char;
BEGIN
     v := substr(m_name,1);                             --v is the first character from m_name
     IF(v in('a', 'e', 'i', 'o', 'u'))THEN              --if v is one of the vowel 
       new_name := m_name || 'ay';                      --new_name is m_name add 'ay' 
     ELSE                                               --if v is not one of the vowel 
       new_name := substr(m_name,2,9) || 'ay';          --get second character to last character from m_name and add 'ay'
     END IF;                                            --end if loop
     RETURN new_name;                                   --return new_name
      EXCEPTION 
    -- Catch Exception
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20393,'ENTER A NAME');
END;                                                    --end function

SET SERVEROUTPUT ON;                                    --Execute pig_latin function
DECLARE 
 input CHAR:= 'Anderson';
 output CHAR;
 BEGIN
  output := pig_latin(input);
  DBMS_OUTPUT.PUT_LINE(output);
END;
-------------------------------------------------------------------
--Q2
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION                                   --CREATE a function that is called exercise 
exercise(input INT)                                          --parameter is input and int type
RETURN CHAR                                                  --returning type is char
AS
m_years INT;
status CHAR(255);
BEGIN
   SELECT years INTO m_years FROM staff where input = id;    --move value of years into m_years that from staff table
   
   if( m_years <= 4) THEN                                    --if m_years is less than 4 status is Junior
    status := 'Junior';
   ELSIF (5<= m_years AND m_years <= 9)THEN                  --if m_years is equal and more than 5 and less than 9 status is Intermediate
    status := 'Intermediate';
   ELSIF(10<=m_years)THEN                                    --if m_years is equal and more than 10 status is Experienced
    status := 'Experienced'; 
   END IF;                                                   --End if loop
   RETURN status;                                            --exercise function return status
   EXCEPTION 
    -- Catch Exception if there is not staff corresponding to the EMP_NO
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20393,'ENTER A VALID EMPLOYEE NUMBER');
END;
    
VARIABLE Status CHAR                                         --Execute exercise function 
EXECUTE :Status := exercise(210)
PRINT Status
