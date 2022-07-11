/*QUERIES SQL FOR EXAM 16-03-2022*/


/*MODIFICACIONES DE UNA BASE DE DATOS (DDL)*/


SELECT * 
FROM customers, payments
WHERE customers.customerNumber = payments.customerNumber;

SELECT * 
FROM customers, orders
WHERE customers.customerNumber = orders.customerNumber;

SELECT customers.customerName, orders.orderDate 
FROM customers, orders
WHERE customers.customerNumber = orders.customerNumber AND orders.orderDate > '2003-12-31';  #Currdate()

SELECT *
FROM customers
LEFT JOIN payments
ON customers.customerNumber = payments.customerNumber;

SELECT customers.customerName, customers.customerNumber, employees.firstName
FROM customers, employees
WHERE customers.salesRepEmployeeNumber = employees.employeeNumber;


SELECT orders.orderNumber, SUM(orderdetails.priceEach * orderdetails.quantityOrdered)
FROM orders, orderdetails
WHERE orders.orderNumber = orderdetails.orderNumber
GROUP BY (orders.orderNumber);

SELECT orders.orderNumber, SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS TOTAL
FROM orders, orderdetails
WHERE orders.orderNumber = orderdetails.orderNumber
GROUP BY (orders.orderNumber)
HAVING total > 20000; #no podemos usar where porque hemos usado una funcion, le asignamos un nombre y lo usammos con el having

#REVISAR CON LA ACTIVIDAD, FUNCIONA DE MANERA DIFERENTE
SELECT products.productName, orderdetails.*
FROM products, orderdetails
WHERE products.productCode = orderdetails.productCode
AND (products.productCode = 'S10_2016')
ORDER BY (products.productName);

#REVISAR --> corregido (GROUP BY)
SELECT customers.customerName, count(orders.orderNumber) as qty
FROM customers, orders
WHERE customers.customerNumber = orders.customerNumber
group by(customers.customerNumber);

#REVISAR
SELECT customers.customerName, SUM(orderdetails.priceEach * orderdetails.quantityOrdered)
FROM customers, orderdetails, orders
WHERE customers.customerNumber = orders.customerNumber
AND orders.orderNumber = orderdetails.orderNumber
GROUP BY(customers.customerNumber);

SELECT customers.customerName, SUM(orderdetails.priceEach * orderdetails.quantityOrdered)
FROM customers, orderdetails, orders
WHERE customers.customerNumber = orders.customerNumber
AND orders.orderNumber = orderdetails.orderNumber
AND customers.country = 'France'
GROUP BY(customers.customerNumber);


SELECT MIN(products.buyPrice), products.productName
FROM products;


#12 reu el codi i nom dels productes que el seu preu és el mínim (exemple: si el preu mínim és 100, treure aquells productes que el seu preu és 100)
SELECT products.productCode, products.productName
FROM products
WHERE products.MSRP = (SELECT MIN(MSRP) FROM products);


#13 Treu el preu mínim, preu màxim i preu mitjà d’entre els preus de les ventes

SELECT MIN(priceEach), MAX(priceEach), AVG(priceEach)
FROM orderdetails;


/*14 Selecciona el nombre de comanda, el nom del producte i la quantitat comanada de cada un dels productes, 
de totes aquelles comandes que no han estat servides.*/

SELECT orderdetails.orderNumber, orderdetails.quantityOrdered ,products.productName, orders.shippedDate
FROM orderdetails, products, orders
WHERE (orderdetails.productCode = products.productCode)
AND (orderdetails.orderNumber = orders.orderNumber) AND orders.shippedDate IS NULL;


/*15 - Selecciona el nombre de comanda, el nom del producte i la quantitat comanada de cada un dels productes, de totes aquelles 
comandes que no han estat servides i que la quantitat del producte en stock és menor a 3300 (imaginam que 3300 és 
la quantitat que sempre solen tenir com a garantia de poder servir les comandes).*/

SELECT orders.orderNumber, products.productName, orderdetails.quantityOrdered, products.quantityInStock
FROM orderdetails,products, orders
WHERE (
orders.orderNumber = orderdetails.orderNumber AND
orderdetails.productCode = products.productCode 
AND orders.shippedDate IS NULL 
AND products.quantityInStock < 3300
);


#16 Selecciona el nombre de comandes de cada un dels anys 

SELECT count(orderNumber), year(orderDate) AS YEARORDERED
FROM orders
GROUP BY (YEARORDERED);


#17 Selecciona per a cada any el total venut (el que s’ha cobrat). Ha de sortir ordenat per any

SELECT SUM(payments.amount), YEAR(orders.orderDate) AS EVERYYEAR
FROM orders, payments
WHERE orders.orderNumber = orderdetails.orderNumber
GROUP BY EVERYYEAR
ORDER BY EVERYYEAR;


#18 La mateixa consulta que abans , però sols ha de treure els anys en que els ingressos superen els 1800000

SELECT SUM(payments.amount) AS TOTAL, YEAR(orders.orderDate) AS EVERYYEAR
FROM orders, payments
WHERE orders.orderNumber = orderdetails.orderNumber
GROUP BY EVERYYEAR
HAVING TOTAL > 70000000
ORDER BY EVERYYEAR;

/*19 Mostra els empleats que varen vendre algun producte el 2005. Suposarem que a un client 
sempre li ven l’empleat que és responsable d’ell (salesRepEmployeeNumber).*/


SELECT distinct employees.firstName AS VENDENDOR, orders.orderDate AS DATESELL, customers.customerName AS CLIENTE
FROM employees, orders, customers
WHERE (customers.salesRepEmployeeNumber = employees.employeeNumber 
AND customers.customerNumber = orders.customerNumber)
HAVING year(DATESELL) = 2005;

/*20 Selecciona cada empleat quants de clients té. Ordena de major a menor nombre de clients. 
O sigui primer ha de sortir l’empleat que té més clients.  REPASAR!!!!! */

SELECT employees.firstName AS VENDENDOR, COUNT(customers.customerNumber) AS CLIENTES
FROM employees, customers
WHERE (customers.salesRepEmployeeNumber = employees.employeeNumber)
GROUP BY employees.employeeNumber
ORDER BY COUNT(customers.customerNumber) DESC;


/*21 Mostra per a cada producte (codi, nom) el total que s’ha venut (els ingressos per aquest producte) l’any 2005. */
#resolver solo


/*22 Mostra el nom dels clients que varen comprar el producte $10_1678*/
#CORREGIR
SELECT customers.customerName, products.productCode
FROM customers, products
WHERE (customers.customerNumber = orders.customerNumber
AND orders.orderNumber = orderdetails.orderNumber
AND orderdetails.productCod = products.productCode 
AND products.productCode = '$10_1678' );


/*23 Selecciona els empleats que no tenen cap client assignat*/

SELECT employees.firstName, customers.customerName
FROM employees, customers
WHERE customers.salesRepEmployeeNumber = employees.employeeNumber 
AND customers.salesRepEmployeeNumber IS NULL;
/*CORRECTLY*/
SELECT DISTINCT em. employeeNumber, em.lastName, em.firstName
FROM employees AS em WHERE NOT EXISTS (
SELECT * FROM customers WHERE em.employeeNumber = customers.salesRepEmployeeNumber
);



/*AUTOCOMMIT, ROLLBACK*/
USE classicmodels;
SET autocommit=0;
SELECT country, customerNumber FROM customers WHERE customerNumber=103;
UPDATE customers SET country='USA' WHERE customerNumber=103;
SELECT country FROM customers WHERE customerNumber=103;
ROLLBACK;
SELECT country FROM customers WHERE customerNumber=103;


/*25 Treu el codi i nom dels empleats que no tenen cap client associat*/

SELECT DISTINCT employees.employeeNumber, employees.firstName
FROM employees
WHERE NOT EXISTS 
(
SELECT salesRepEmployeeNumber FROM customers 
WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
);

/*26 Treu els empleats que tenen clients associats però aquests clients no han fet cap comanda. */
 
SELECT employees.firstName, employees.lastName
FROM employees, customers
WHERE customers.salesRepEmployeeNumber = employees.employeeNumber
AND NOT EXISTS (SELECT * FROM orders WHERE customers.customerNumber = orders.customerNumber);

/*27 Mostra el codi de client i “Menor”, “Major” en funció de si el seu límit de crèdit és major o 
menor a 100000*/

SELECT customerNumber,
CASE
    WHEN customers.creditLimit > 100000 THEN 'La quantitat es major que 100000'
    WHEN customers.creditLimit < 100000 THEN 'La quantitat es menor que 100000'
    ELSE 'La quantitat 100000'
    END AS RESULTAT
FROM customers;

/*28 Selecciona el nombre de client i les seves dues adreces. Les seves adreces han de sortir en una 
sola columna separades per els caràcters **. Alerta que hi ha camps que poden ser null
*/

SELECT * FROM classicmodels.customers;

SELECT customers.customerNumber, 
CONCAT(COALESCE(customers.addressLine1,''), "**", COALESCE(customers.addressLine2,'')) AS DIRECCIONS
FROM customers;



/*29 Fes una taula que contingui un resum de les vendes. 
Camps: codi client, import_total (import del total venut), any. 
Has d’emplenar aquest taula a partir dels valors de les demés*/

CREATE TABLE resum_ventes (
clientId int(11),
import_total decimal(10,2),
data_any year
);
/*REVISAR*/
INSERT INTO resum_ventes (clientId, import_total, data_any)
SELECT 
customers.customerNumber, 
SUM(orderdetails.priceEach * orderdetails.quantityOrdered),  
YEAR(orders.orderDate)
FROM customers, orderdetails, orders
WHERE (customers.customerNumber = orders.customerNumber)
GROUP BY (customers.customerNumber);



/*30 Quins clients tenen el seu creditLimit per damunt de tots els clients del representant 1165*/ 
#Tambien se puede hacer con el > ALL
SELECT customers.customerName, customers.creditLimit, customers.customerName, customers.salesRepEmployeeNumber
FROM customers
WHERE  customers.creditLimit > (SELECT MAX(customers.creditLimit) FROM customers WHERE  customers.salesRepEmployeeNumber = '1165');

#SELECT MAX(customers.creditLimit) FROM customers WHERE  customers.salesRepEmployeeNumber = '1165'


/*31 Mostra els clients que tenen el seu creditLimit per damunt d’algun dels clients del representant 1165.
*/

SELECT customers.customerName, customers.creditLimit, customers.customerName, customers.salesRepEmployeeNumber
FROM customers
WHERE  customers.creditLimit > (SELECT MIN(customers.creditLimit) FROM customers WHERE  customers.salesRepEmployeeNumber = '1165');


/*32 Mostra en un sols llistat:  els codis, noms dels clients que han fet algun pagament 
i els codis, noms dels clients que han fet una comanda.  No ha de mostrar els repetits*/
#TAMBIEN SE PUEDE HACER CON EL OR
SELECT DISTINCT customers.customerNumber, customers.contactFirstName
FROM customers, payments
WHERE (customers.customerNumber = payments.customerNumber)
UNION
SELECT DISTINCT customers.customerNumber, customers.contactFirstName
FROM customers, orders
WHERE (customers.customerNumber = orders.customerNumber);


/*33 Mostra en un sols llistat:  
els codis, noms dels clients que han fet algun pagament i els codis, 
noms dels clients que han fet una comanda.  
A devora els clients de pagament ha de posar pagament i a devora els d’orders ha de posar orders.
*/	
#SE PUDE USAR CON CASE/ ME SALEN REPETIDOS, A CORREGIR
SELECT customers.customerNumber, customers.customerName, 'Pagament' AS TIPUS
FROM customers,payments
WHERE (customers.customerNumber = payments.customerNumber)
UNION ALL
SELECT customers.customerNumber, customers.customerName , 'Comanda' AS TIPUS
FROM customers, orders
WHERE (customers.customerNumber = orders.orderNumber);


/* 34 Treu per a cada employee el nombre de clients que té. També has de treure el total. */
 
SELECT 
	employees.employeeNumber, 
	COUNT(customers.salesRepEmployeeNumber) AS CLIENTS
FROM 
	employees, 
    customers
WHERE (customers.salesRepEmployeeNumber = employees.employeeNumber)
GROUP BY employees.employeeNumber WITH ROLLUP;


/*35 Selecciona les comandes (orders) de l’oficina de la ciutat de San Francisco*/

SELECT orders.orderNumber, offices.city
FROM orders, offices, customers, employees
WHERE orders.customerNumber = customers.customerNumber
AND customers.salesRepEmployeeNumber = employees.employeeNumber
AND employees.officeCode = offices.officeCode 
AND offices.city = (SELECT offices.city FROM offices WHERE city = 'San Francisco');

/* 36 Selecciona les comandes (orders) de l’oficina de San Francisco del producte Motorcycles. */

SELECT orders.orderNumber, products.productName, 
