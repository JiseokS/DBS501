--Jiseok Shim
--122758170
--2022-10-05
--Q1
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE factorial(n IN NUMBER)AS              --create procedure that called factorial and the parameter is n (type is number)
total INT := 1;                                                  --declare total as integer type and make it as '1'
str VARCHAR(255) := n || '!' || ' = ' || 'fact(' || n ||') = ';  --make str format as above example "n! = fact(n) ="
BEGIN
 IF n = 0 THEN                                                    --initiate below command when num is 0
 DBMS_OUTPUT.PUT_LINE(n || '! = '|| n);                           --display "n! = n
 ELSE
   FOR i IN REVERSE  1.. n LOOP                                      --initiate i = n and when first loop is done i = i-1 until i = 1
   total := total*i;
     IF i = n THEN                                                   --IF i is n initiate below command 
     str := str || i;
     ELSE                                                            --IF i is not n initiate below command
     str := str || ' * ' || i;
     END IF;                                                         --End IF Loop
   END LOOP;                                                        --End Loop
 DBMS_OUTPUT.PUT_LINE(str || ' = ' || total);                     --display str = total
 factorial(n -1);                                                 --Recursion factorial function
 END IF;                                                          --End IF loop
EXCEPTION                                                         --Error handling if user input that is not number the procedure print ERROR!
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('ERROR!');
END;

execute factorial(3);
execute factorial(a);
-----------------------------------------------------------------------------------------------
--Q3
CREATE OR REPLACE PROCEDURE update_price(p_category_id IN products.category_id%TYPE, p_amount IN products.list_price%TYPE) AS  --Create procedure called update_price
v_count number;            
BEGIN

SELECT COUNT(category_id) INTO v_count FROM products WHERE category_id = p_category_id;                  --counting category_id and pass to v_count

IF p_amount > 0 AND v_count > 0 THEN
UPDATE products SET LIST_PRICE = LIST_PRICE + p_amount WHERE category_id = p_category_id;                --update list_price = list_price + p_amount
DBMS_OUTPUT.PUT_LINE('Rows Updated =' || SQL%ROWCOUNT);                                                  --display Rows Updated = the number of row

ELSE
DBMS_OUTPUT.PUT_LINE('Either there are no CATEGORY matching or the input price is lesser than zero');    
END IF;


EXCEPTION                                                                                                 --Exception control

WHEN NO_DATA_FOUND THEN                                                                                   --No data found exception
DBMS_OUTPUT.PUT_LINE('PRODUCTS not found.');
WHEN OTHERS THEN                                                                                          --Error handling
DBMS_OUTPUT.PUT_LINE('Stored PROCEDURE has errors. Please take a look');
end;

declare
p_category_id number := 3;
p_amount number := 0.5;
begin
update_price(p_category_id , p_amount );
end;

---------------------------------------------------------------------------------------------------------------
--Q4
CREATE OR REPLACE PROCEDURE update_price_under_avg AS                           --Create procedure that called update_price_under_avg
v_avg products.list_price%TYPE;                                                 
v_rate NUMBER;
BEGIN

SELECT AVG(LIST_PRICE) INTO v_avg FROM products ;                               --store in v_avg from average value of list_price in products table 

IF v_avg >= 1000 THEN
v_rate := 1.02;                                                                 --If avg is equal or more than 1000 the rate is 1.02
ELSE 
v_rate :=1.01;                                                                  --less than 1000 the rate is 1.01
END IF;

UPDATE products SET LIST_PRICE = LIST_PRICE * v_rate WHERE LIST_PRICE <= v_avg; --Update list_price = list_price * v_rate, only list_price is under average 
DBMS_OUTPUT.PUT_LINE('Rows Updated =' || SQL%ROWCOUNT);

EXCEPTION
WHEN NO_DATA_FOUND THEN                                                         --No data found exception handling
DBMS_OUTPUT.PUT_LINE('PRODUCTS not found.');
WHEN OTHERS THEN                                                                --Error handling
DBMS_OUTPUT.PUT_LINE('Stored PROCEDURE has errors. Please take a look');
END;

begin
update_price_under_avg;
end;

----------------------------------------------------------------------------------------------
--Q5
CREATE OR REPLACE PROCEDURE report_product AS                                                                --create procedure that called report_product
v_avg products.list_price%TYPE;
v_max products.list_price%TYPE;
v_min products.list_price%TYPE;
BEGIN

SELECT AVG(LIST_PRICE), MAX(LIST_PRICE), MIN(LIST_PRICE) INTO v_avg, v_max, v_min FROM products ;            --Average of list_price is v_avg, Minimum of list_price is v_min, and Maximum of list_price is v_max from products table

BEGIN
FOR r_product IN (
SELECT PRODUCT_ID, PRODUCT_NAME, DESCRIPTION, STANDARD_COST, LIST_PRICE, CATEGORY_ID, price_category          
FROM(
SELECT PRODUCT_ID, PRODUCT_NAME, DESCRIPTION, STANDARD_COST, LIST_PRICE, CATEGORY_ID
, CASE WHEN list_price <= (avg_price- min_price) / 2 THEN 'CHEAP'                                             --If list price is less than (avg_price- min_price), display CHEAP
WHEN list_price >= (max_price - avg_price) / 2 THEN 'FAIR'                                                    --If list price is more than (avg_price- min_price), display FAIR  
ELSE 'EXPENSIVE'
END AS price_category
FROM PRODUCTS
, (SELECT AVG(list_price) avg_price, MIN(list_price) min_price, MAX(list_price) max_price FROM products) agg
) rpt
ORDER BY price_category                                                                                       --Sorting by price_category
)
LOOP
dbms_output.put_line( r_product.product_name ||': $' || r_product.list_price||' : ' ||r_product.CATEGORY_ID ||' : ' ||r_product.price_category );           --Display 
END LOOP;
END;

EXCEPTION

WHEN NO_DATA_FOUND THEN                                                             --NO data found exception handling
DBMS_OUTPUT.PUT_LINE('PRODUCTS not found.');
WHEN OTHERS THEN                                                                    --Error handling
DBMS_OUTPUT.PUT_LINE('Stored PROCEDURE has errors. Please take a look');
end;

begin
report_product;
end;