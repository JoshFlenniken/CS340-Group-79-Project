-- =====================================
-- Customers
-- =====================================
-- SELECT FROM CUSTOMERS
SELECT customerID, firstName, lastName, email, phoneNumber FROM Customers;

-- INSERT INTO CUSTOMERS
INSERT INTO Customers (firstName, lastName, email, phoneNumber)
VALUES (:firstName_input, :lastName_input, :email_input, :phoneNumber_input);

-- UPDATE CUSTOMERS
UPDATE Customers
SET firstName = :firstName_input, lastName = :lastName_input, email = :email_input, phoneNumber = :phoneNumber_input
WHERE customerID = :customerID_input;

-- DELETE FROM CUSTOMERS
DELETE FROM Customers WHERE customerID = :customerID_input;

-- =====================================
-- Employees
-- =====================================
-- SELECT FROM EMPLOYEES
SELECT employeeID, firstName, lastName, email, phoneNumber FROM Employees;

-- INSERT INTO EMPLOYEES
INSERT INTO Employees (firstName, lastName, email, phoneNumber)
VALUES (:firstName_input, :lastName_input, :email_input, :phoneNumber_input);

-- UPDATE EMPLOYEES
UPDATE Employees
SET firstName = :firstName_input, lastName = :lastName_input, email = :email_input, phoneNumber = :phoneNumber_input
WHERE employeeID = :employeeID_input;

-- DELETE FROM EMPLOYEES
DELETE FROM Employees WHERE employeeID = :employeeID_input;

-- =====================================
-- Orders
-- =====================================
-- SELECT FROM ORDERS
SELECT orderID, customerID, employeeID, orderDate FROM Orders;

-- INSERT INTO ORDERS
INSERT INTO Orders (customerID, employeeID, orderDate)
VALUES (:customerID_input, :employeeID_input, :orderDate_input);

-- UPDATE ORDERS
UPDATE Orders
SET customerID = :customerID_input, employeeID = :employeeID_input, orderDate = :orderDate_input
WHERE orderID = :orderID_input;

-- DELETE FROM ORDERS
DELETE FROM Orders WHERE orderID = :orderID_input;

-- =====================================
-- Products
-- =====================================
-- SELECT FROM PRODUCTS
SELECT productID, productName, productCategory, productPrice, productStock, isActive FROM Products;

-- INSERT INTO PRODUCTS
INSERT INTO Products (productName, productCategory, productPrice, productStock, isActive)
VALUES (:productName_input, :productCategory_input, :productPrice_input, :productStock_input, :isActive_input);

-- UPDATE PRODUCTS
UPDATE Products
SET productName = :productName_input, productCategory = :productCategory_input, productPrice = :productPrice_input, productStock = :productStock_input, isActive = :isActive_input
WHERE productID = :productID_input;

-- DELETE FROM PRODUCTS
DELETE FROM Products WHERE productID = :productID_input;

-- =====================================
-- OrderDetails
-- =====================================
-- SELECT FROM ORDERDETAILS
SELECT orderDetailsID, orderID, productID, orderQuantity FROM OrderDetails;

-- INSERT INTO ORDERDETAILS
INSERT INTO OrderDetails (orderID, productID, orderQuantity)
VALUES (:orderID_input, :productID_input, :orderQuantity_input);

-- UPDATE ORDERDETAILS
UPDATE OrderDetails
SET orderID = :orderID_input, productID = :productID_input, orderQuantity = :orderQuantity_input
WHERE orderDetailsID = :orderDetailsID_input;

-- DELETE FROM ORDERDETAILS
DELETE FROM OrderDetails WHERE orderDetailsID = :orderDetailsID_input;
