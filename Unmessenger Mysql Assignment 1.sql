CREATE DATABASE ORG;
USE ORG;

CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
Name VARCHAR(255),
Email VARCHAR(255),
JoinDate date
);

CREATE TABLE Products (
ProductID INT PRIMARY KEY,
Name VARCHAR(255),
Category VARCHAR(255),
Price DECIMAL(10, 2)
);

CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
TotalAmount DECIMAL(10, 2),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
PricePerUnit DECIMAL(10, 2),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES
(1, 'John Doe', 'johndoe@example.com', '2020-01-10'),
(2, 'Jane Smith', 'janesmith@example.com', '2020-01-15'),
(3, 'Alice Johnson', 'alicejohnson@example.com', '2020-02-20'),
(4, 'Bob Brown', 'bobbrown@example.com', '2020-03-25'),
(5, 'Emily Davis', 'emilydavis@example.com', '2020-04-30'),
(6, 'Michael Wilson', 'michaelwilson@example.com', '2020-05-05'),
(7, 'Sarah Martinez', 'sarahmartinez@example.com', '2020-06-10'),
(8, 'David Taylor', 'davidtaylor@example.com', '2020-07-15'),
(25, 'Jessica Garcia', 'jessicagarcia@example.com', '2020-08-20'),
(10, 'Alice Johnson', 'alicejohnson@example.com', '2020-03-05');

INSERT INTO Products (ProductID, Name, Category, Price) 
VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 499.99),
(3, 'Headphones', 'Electronics', 79.99),
(4, 'Backpack', 'Fashion', 39.99),
(5, 'Coffee Maker', 'Appliances', 129.99),
(6, 'Running Shoes', 'Sporting Goods', 89.99),
(7, 'Gaming Console', 'Electronics', 349.99),
(8, 'Watch', 'Fashion', 199.99),
(50, 'Blender', 'Appliances', 29.99),
(10, 'Desk Lamp', 'Home Decor', 29.99);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1, 1, '2020-02-15', 1499.98),
(2, 2, '2020-02-17', 499.99),
(3, 3, '2020-03-01', 279.99),
(4, 4, '2020-03-05', 169.99),
(5, 5, '2020-03-10', 699.99),
(6, 6, '2020-03-15', 119.99),
(7, 7, '2020-03-20', 849.99),
(8, 8, '2020-03-25', 299.99),
(25, 10, '2020-03-30', 429.99),
(10, 25, '2020-03-21', 78.99); 

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, PricePerUnit) 
VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 2, 1, 499.99),
(3, 2, 3, 1, 79.99),
(4, 3, 4, 1, 39.99),
(5, 4, 5, 1, 129.99),
(6, 5, 6, 1, 89.99),
(7, 6, 7, 1, 349.99),
(8, 8, 8, 1, 199.99),
(9, 10, 10, 1, 59.99),
(10, 25, 50, 2, 29.99);

-- 1. Basic Queries:

-- 1.1. 

Select * from Customers;

-- 1.2.

Select * From Products
Where Category = 'Electronics';

-- 1.3.

Select Count(*) As TotalOrders From Orders;

-- 1.4.

Select * From Orders 
Order By OrderDate Desc Limit 1;

-- 2. Joins and Relationships:

-- 2.1.

SELECT P.*, C.Name AS CustomerName
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID;

-- 2.2.

SELECT O.*
FROM Orders O
JOIN (
    SELECT OrderID
    FROM OrderDetails
    GROUP BY OrderID
    HAVING COUNT(*) > 1
) AS MultiProductOrders ON O.OrderID = MultiProductOrders.OrderID;

-- 2.3. 

SELECT C.CustomerID, C.Name AS CustomerName, SUM(OD.Quantity * OD.PricePerUnit) AS TotalSalesAmount
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
LEFT JOIN OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID, C.Name;

-- 3. Aggregation and Grouping:

-- 3.1. 

SELECT Category, SUM(Quantity * PricePerUnit) AS TotalRevenue
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY Category;

-- 3.2.

SELECT AVG(TotalAmount) AS Average_Order_Value 
FROM Orders; 

-- 3.3.

SELECT MONTH(OrderDate) AS Month, COUNT(*) AS NumberofOrders
FROM Orders 
GROUP BY MONTH(OrderDate)
ORDER BY NumberOfOrders DESC
LIMIT 1;

-- 4. Subqueries and Nested Queries:

-- 4.1.

SELECT * 
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

-- 4.2.

SELECT * 
FROM Products 
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);

-- 4.3.
 
SELECT P.*, SUM(OD.Quantity) AS TotalQuantitySold
FROM Products P
LEFT JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductID, P.Name, P.Category, P.Price
ORDER BY TotalQuantitySold DESC
LIMIT 3;

-- 5. Date and Time Functions:

-- 5.1

SELECT *
FROM Orders
WHERE OrderDate >= DATE_SUB('2020-04-1',INTERVAL 1 MONTH); 

-- CAN USE THIS BELOW CODE TOO IF YOU WANT TO FETCH DATE FROM CURRENT DATE.
-- SELECT *
-- FROM Orders
-- WHERE OrderDate >= DATE_SUB(CURRENT_DATE(),INTERVAL 1 MONTH);

-- 5.2.

SELECT *
FROM Customers
ORDER BY JoinDate
LIMIT 1;

-- 6. Advanced Queries:

-- 6.1.

SELECT C.*, SUM(OD.Quantity * OD.PricePerUnit) AS TotalSpending
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
LEFT JOIN OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID, C.Name
ORDER BY TotalSpending DESC;

-- 6.2.

SELECT Category, SUM(Quantity) AS TotalQuantitySold
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY Category
ORDER BY TotalQuantitySold DESC
LIMIT 1;

-- 6.3.

SELECT 
    MONTH(OrderDate) AS Month,
    SUM(TotalAmount) AS TotalSalesAmount,
    LAG(SUM(TotalAmount)) OVER (ORDER BY MONTH(OrderDate)) AS PreviousMonthSalesAmount,
    (SUM(TotalAmount) - LAG(SUM(TotalAmount)) OVER (ORDER BY MONTH(OrderDate))) / LAG(SUM(TotalAmount)) OVER (ORDER BY MONTH(OrderDate)) AS GrowthRate
FROM Orders
GROUP BY MONTH(OrderDate);

-- 7. Data Manipulation and Updates:

-- 7.1.

INSERT INTO Customers (CustomerID, Name, Email, JoinDate)
VALUES (11, 'New Customer', 'newcustomer@example.com', '2024-05-07');

-- 7.2

UPDATE Products
SET Price = 159.99
WHERE ProductID = 1;


