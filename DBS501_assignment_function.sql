--Q2 my_median function
CREATE OR REPLACE TYPE NUM_TBL AS TABLE OF NUMBER;
create or replace
TYPE t_median AS OBJECT
(
  g_nums num_tbl,

  STATIC FUNCTION ODCIAggregateInitialize(sctx  IN OUT  t_median)
    RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateIterate(self   IN OUT  t_median,
                                       value  IN      NUMBER )
     RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateTerminate(self         IN   t_median,
                                         returnValue  OUT  NUMBER,
                                         flags        IN   NUMBER)
    RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateMerge(self  IN OUT  t_median,
                                     ctx2  IN      t_median)
    RETURN NUMBER
);
/

create or replace
TYPE BODY t_median IS
  STATIC FUNCTION ODCIAggregateInitialize(sctx  IN OUT  t_median)
    RETURN NUMBER IS
  BEGIN
    -- set sctx to an empt array of numbers
    sctx := t_median(num_tbl());
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateIterate(self   IN OUT  t_median,
                                       value  IN      NUMBER )
    RETURN NUMBER IS
  BEGIN
    -- add a new element and assign its value to the parameter value (the current record)
    SELF.g_nums.EXTEND;
    SELF.g_nums(SELF.g_nums.LAST) := value;
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateTerminate(self         IN   t_median,
                                         returnValue  OUT  NUMBER,
                                         flags        IN   NUMBER)
    RETURN NUMBER IS
    l_num_tbl num_tbl;
  BEGIN
    -- order the elements of the array in ascending order
    select cast ( multiset( select *
                              from table( self.g_nums )
                             order by 1
                          ) as num_tbl)
      into l_num_tbl
      from dual;
    
    -- set returnValue to the middle array element.
    returnValue := l_num_tbl(floor(l_num_tbl.LAST / 2));
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateMerge(self  IN OUT  t_median,
                                     ctx2  IN      t_median)
    RETURN NUMBER IS
  BEGIN
    -- combine the two arrays
    SELF.g_nums := SELF.g_nums MULTISET UNION ctx2.g_nums;
    RETURN ODCIConst.Success;
  END;
END;
/

create or replace FUNCTION median
( p_number IN NUMBER
)
RETURN NUMBER
PARALLEL_ENABLE AGGREGATE USING t_median;
/
with tst as(select 3 lvl,  2 grp FROM DUAL
            UNION ALL
            select 5 lvl,  2 grp FROM DUAL
            UNION ALL
            select 8 lvl,  2 grp FROM DUAL
            UNION ALL
            select 15 lvl,  2 grp FROM DUAL
            UNION ALL
            select 16 lvl,  2 grp FROM DUAL


     ) 
        

SELECT median(lvl)
  FROM tst
GROUP BY grp
=================================================================================
--Q3 my_mode function
CREATE OR REPLACE TYPE array AS VARRAY(10) OF NUMBER;  --create array
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION my_mode(input IN INT)       --create function that called my_mode
RETURN INT;                                            --return type is INT
AS
NUMBER :=array[0] INT;                                 --number is the first elements of array
COUNT :=1 INT;                                         --count is 1 and int type
COUNTMOD := INT;                                       --countmod is int
MODE := NUMBER INT;                                    
BEGIN
 FOR i IN 1..SIZE LOOP                                 --start for loop from i is 1 to size
     IF (array[i]=number)THEN                          --if array ist element is equal number
       COUNTER := COUNTER+1;                           --add 1 to counter
     ELSE 
       IF COUNT>COUNTMOD THEN                          --IF counter is more than countmod
         COUNTMOD := COUNT;                            --countermod is count
         MODE:= NUMBER;                                --mod is number
       END IF;                                        
     END IF;                     
   END LOOP;
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20393,'ENTER A VALID COLUMN NAME'); --Exception when input column can not founded
RETURN MODE;                                           --return mode 
END;
=================================================================================
--Q4 my_math_all procedure
CREATE OR REPLACE PROCEDURE my_math_all(m_column VARCHAR) --create procedure that called my_math_all and m_column is input
AS
m_salary NUMBER;                                          
m_median VARCHAR(200);
m_my_mode VARCHAR(200);
BEGIN
 m_median := my_median(m_column);                         --call my_median function and m_column is input
 DBMS_OUTPUT.PUT_LINE(m_median);                          --display the output of my_median(m_column)
 m_my_mode := my_mode(m_column);                          --call my_mode function and m_column is input
 DBMS_OUTPUT.PUT_LINE(m_my_mode);                         --display the output of my_mode(m_column)
 select AVG(m_column)into m_salary FROM employee;         --calculate average of m_column(is salary), into m_salary from employee table
 DBMS_OUTPUT.PUT_LINE('Average salary : '|| m_salary);    --display average salary 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20393,'ENTER A VALID COLUMN NAME'); --Exception when input column can not founded
END;
