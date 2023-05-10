--Part2
CREATE OR REPLACE PROCEDURE Emloyee_Compensation (EMP_NO IN NUMBER, RATING IN NUMBER, OLD_SAL OUT NUMBER, OLD_BONUS OUT NUMBER, OLD_COMM OUT NUMBER, 
NEW_SAL OUT NUMBER, NEW_BONUS OUT NUMBER, NEW_COMM OUT NUMBER) 
IS
    -- Declare Variables
    V_SAL NUMBER(9,2); V_BONUS NUMBER(9,2);
    V_COMM NUMBER(9,2); V_NEW_SAL NUMBER(9,2);
    V_NEW_BONUS NUMBER(9,2); V_NEW_COMM NUMBER(9,2);
BEGIN
    -- SQL Query to search Employee Record
    SELECT SALARY, BONUS, COMM INTO V_SAL, V_BONUS, V_COMM
    FROM EMPLOYEE
    WHERE EMPNO = EMP_NO;
    -- Check for Valid Rating Value entered and RAISE ERROR if Necessary
    IF (RATING IS NULL OR RATING < 1 OR RATING > 3) THEN
        RAISE_APPLICATION_ERROR(-20394,'ENTER A VALID RATING');
    ELSIF (RATING=1) THEN
        -- Calculations for Valid Update
        NEW_SAL := V_SAL+10000;
        NEW_BONUS := V_BONUS + 300;
        NEW_COMM := V_COMM+(V_SAL * 0.05);
        OLD_SAL := V_SAL;
        OLD_BONUS := V_BONUS;
        OLD_COMM := V_COMM;
        -- Update Record
        UPDATE EMPLOYEE SET SALARY = NEW_SAL, BONUS = NEW_BONUS, COMM = NEW_COMM
        WHERE EMPNO = EMP_NO;
        DBMS_OUTPUT.PUT_LINE('RATING IS 1');
    ELSIF (RATING=2) THEN
     -- Calculations for Valid Update
        NEW_SAL := V_SAL+5000;
        NEW_BONUS := V_BONUS + 200;
        NEW_COMM := V_COMM+(V_SAL * 0.02);
        OLD_SAL := V_SAL;
        OLD_BONUS := V_BONUS;
        OLD_COMM := V_COMM;
        -- Update Record
        UPDATE EMPLOYEE SET SALARY = NEW_SAL, BONUS = NEW_BONUS, COMM = NEW_COMM
        WHERE EMPNO = EMP_NO;
        DBMS_OUTPUT.PUT_LINE('RATING IS 2');
    ELSIF (RATING=3) THEN
    -- Calculations for Valid Update
        NEW_SAL := V_SAL+2000;
        NEW_BONUS := V_BONUS;
        NEW_COMM := V_COMM;
        OLD_SAL := V_SAL;
        OLD_BONUS := V_BONUS;
        OLD_COMM := V_COMM;
        -- Update Record
        UPDATE EMPLOYEE SET SALARY = NEW_SAL
        WHERE EMPNO = EMP_NO;
        DBMS_OUTPUT.PUT_LINE('RATING IS 3');
    END IF;
    EXCEPTION 
    -- Catch Exception if there is not Employee corresponding to the EMP_NO
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20393,'ENTER A VALID EMPLOYEE NUMBER');
END;

--execute employee compensation
SET SERVEROUTPUT ON;
DECLARE
    EMP_NO CHAR(6) := 10;
    RATING NUMBER(1) := 9;
    OLD_SAL NUMBER(9,2); OLD_BONUS NUMBER(9,2);
    OLD_COMM NUMBER(9,2); NEW_SAL NUMBER(9,2);
    NEW_BONUS NUMBER(9,2); NEW_COMM NUMBER(9,2);
BEGIN
    Emloyee_Compensation (EMP_NO, RATING, OLD_SAL, OLD_BONUS, OLD_COMM, NEW_SAL, NEW_BONUS, NEW_COMM);
    DBMS_OUTPUT.PUT_LINE('EMP OLD SAL OLD BONUS OLD COMM NEW SAL NEW BONUS NEW COMM');
    DBMS_OUTPUT.PUT_LINE(EMP_NO ||CHR(9)||OLD_SAL||CHR(9)||OLD_BONUS||CHR(9)||OLD_COMM||CHR(9)|| NEW_SAL||CHR(9)||NEW_BONUS||CHR(9)|| NEW_COMM);
END;
--Part3

CREATE OR REPLACE PROCEDURE Emloyee_EduLevel (EMP_NO IN NUMBER, EDLEVEL IN CHAR, OLD_EDLEVEL OUT NUMBER, NEW_EDLEVEL OUT NUMBER) 
IS
    -- Declare Variables
    V_EDLEVEL CHAR := EDLEVEL;
    CUR_EDLEVEL NUMBER(38,0);
BEGIN
    -- SQL Query to search Employee Record
    SELECT EDLEVEL INTO CUR_EDLEVEL
    FROM EMPLOYEE
    WHERE EMPNO = EMP_NO;
    -- Check for Valid Education Upgrade Level Value entered and RAISE ERROR if Necessary
    IF (V_EDLEVEL IS NULL OR V_EDLEVEL NOT IN('H', 'C', 'U', 'M', 'P')) THEN
        RAISE_APPLICATION_ERROR(-20395,'ENTER A VALID EDUCATION LEVEL ( H, C, U, M, P)');
    ELSIF (V_EDLEVEL = 'H') THEN
        -- Calculations for Valid Update
        IF CUR_EDLEVEL < 16 THEN
            -- Update Record
            OLD_EDLEVEL := CUR_EDLEVEL;
            NEW_EDLEVEL := 16;
            UPDATE EMPLOYEE SET EDLEVEL = NEW_EDLEVEL WHERE EMPNO = EMP_NO;
        ELSE
            RAISE_APPLICATION_ERROR(-20396, 'The Education Level is already UP to the Standard');
        END IF;
    ELSIF (V_EDLEVEL = 'C') THEN
        -- Calculations for Valid Update
        IF CUR_EDLEVEL < 19 THEN
            -- Update Record
            OLD_EDLEVEL := CUR_EDLEVEL;
            NEW_EDLEVEL := 19;
            UPDATE EMPLOYEE SET EDLEVEL = NEW_EDLEVEL WHERE EMPNO = EMP_NO;
        ELSE
            RAISE_APPLICATION_ERROR(-20396, 'The Education Level is already UP to the Standard');
        END IF;
    ELSIF (V_EDLEVEL = 'U') THEN
        -- Calculations for Valid Update
        IF CUR_EDLEVEL < 20 THEN
            -- Update Record
            OLD_EDLEVEL := CUR_EDLEVEL;
            NEW_EDLEVEL := 20;
            UPDATE EMPLOYEE SET EDLEVEL = NEW_EDLEVEL WHERE EMPNO = EMP_NO;
        ELSE
            RAISE_APPLICATION_ERROR(-20396, 'The Education Level is already UP to the Standard');
        END IF;
    ELSIF (V_EDLEVEL = 'M') THEN
        -- Calculations for Valid Update
        IF CUR_EDLEVEL < 23 THEN
            -- Update Record
            OLD_EDLEVEL := CUR_EDLEVEL;
            NEW_EDLEVEL := 23;
            UPDATE EMPLOYEE SET EDLEVEL = NEW_EDLEVEL WHERE EMPNO = EMP_NO;
        ELSE
            RAISE_APPLICATION_ERROR(-20396, 'The Education Level is already UP to the Standard');
        END IF;
    ELSIF (V_EDLEVEL = 'P') THEN
        -- Calculations for Valid Update
        IF CUR_EDLEVEL < 25 THEN
            -- Update Record
            OLD_EDLEVEL := CUR_EDLEVEL;
            NEW_EDLEVEL := 25;
            UPDATE EMPLOYEE SET EDLEVEL = NEW_EDLEVEL WHERE EMPNO = EMP_NO;
        ELSE
            RAISE_APPLICATION_ERROR(-20396, 'The Education Level is already UP to the Standard');
        END IF;
    END IF;
    EXCEPTION 
    -- Catch Exception if there is not Employee corresponding to the EMP_NO
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20393,'ENTER A VALID EMPLOYEE NUMBER');
END;


--execute employee_edulevel
SET SERVEROUTPUT ON;
DECLARE
    EMP_NO CHAR(6) := 10;
    EDLEVEL CHAR(1) := 'G';
    OLD_EDLEVEL NUMBER(38,2); 
    NEW_EDLEVEL NUMBER(38,2); 

BEGIN
    Emloyee_EduLevel (EMP_NO, EDLEVEL, OLD_EDLEVEL, NEW_EDLEVEL);
    DBMS_OUTPUT.PUT_LINE('EMP OLD_EDUCATION NEW EDUCATION');
    DBMS_OUTPUT.PUT_LINE(EMP_NO ||CHR(9)||OLD_EDLEVEL||CHR(9)||NEW_EDLEVEL);
END;

--find_product
CREATE PROCEDURE find_product(product_id IN NUMBER, price OUT products.list_price%type)
IS
BEGIN
SELECT p.list_price into price from products p where p.product_id = product_id;
EXCEPTION
WHEN no_data_found THEN
price:= 0;
END;

--add_order
CREATE PROCEDURE add_order(customer_id IN NUMBER, new_order_id OUT NUMBER)
IS
max_order_id NUMBER;
BEGIN
select max(order_id) into max_order_id from orders;
INSERT INTO orders values(max_order_id+1, customer_id, 'Shipped', 56, SYSDATE);
new_order_id:=max_order_id+1;
END;

--add_order_item
CREATE PROCEDURE add_order_item(orderId IN order_items.order_Id%type,
itemId IN order_items.item_Id%type,
productId IN order_items.product_Id%type,
quantity IN order_items.quantity%type,
price IN order_items.price%type)
IS
BEGIN
INSERT INTO order_items values(orderId, itemId, productId, quantity, price);
END;

--find_customer
CREATE PROCEDURE find_customer(customer_id IN NUMBER, found OUT NUMBER)
IS
BEGIN
SELECT 1 into found from customers c where c.customer_id = customer_id;
EXCEPTION
WHEN no_data_found THEN
found:= 0;
END;


--display_order

SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE display_order(orderid IN NUMBER) AS
orderid orders.order_id%type;
customerid orders.customer_id%type;
itemid order_items.item_id%type;
productid order_items.product_id%type;
quan order_items.quantity%type;
prices order_items.unit_price%type;

BEGIN
SELECT o.order_id , o.customer_id, oi.item_id, oi.product_id, oi.quantity, oi.unit_price 
into orderid, customerid, itemid, productid, quan, prices 
from orders o JOIN order_items oi ON o.order_id = oi.order_id
where o.order_id = orderid;

DBMS_OUTPUT.PUT_LINE ("Order Id: "|| orderid);
DBMS_OUTPUT.PUT_LINE ("Customer Id: "|| customerid);
DBMS_OUTPUT.PUT_LINE ("Item Id: "|| itemid);
DBMS_OUTPUT.PUT_LINE ("Product Id: "|| productid);
DBMS_OUTPUT.PUT_LINE ("Quantity: "|| quan);
DBMS_OUTPUT.PUT_LINE ("Price: "|| prices);
END;

-- master_proc

SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE master_proc (task IN NUMBER,parm1 IN NUMBER)AS
BEGIN
  IF (Task IS NULL OR Task < 1 OR Task > 4) THEN
        RAISE_APPLICATION_ERROR(-20394,'ENTER A VALID RATING');
    ELSIF (RATING=1) THEN
        execute find_customer(parm1);
    ELSIF (RATING=2) THEN
        execute find_product(param1);
    ELSIF (RATING=3) THEN
        execute add_order(param1);
    ELSIF (RATING=4) THEN
        execute display_order(param1);
    END IF;
END;