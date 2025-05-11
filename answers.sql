-- Database Design and Normalization Assignment
-- Database Design and Normalization Assignment

-- Question 1: Achieving 1NF (First Normal Form)
-- Task: Transform the ProductDetail table into 1NF

-- First, create the original table for reference
CREATE TABLE IF NOT EXISTS ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert the sample data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Solution: Transform to 1NF by creating a new table with one product per row
-- This can be done in multiple ways, here's one approach using a temporary table:

-- Create the 1NF compliant table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert data into the 1NF table (in a real scenario, you would use a stored procedure or
-- application code to split the comma-separated values)
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Select from the 1NF table to verify the transformation
SELECT * FROM ProductDetail_1NF;

-- Question 2: Achieving 2NF (Second Normal Form)
-- Task: Transform the OrderDetails table into 2NF

-- First, create the original table for reference
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

-- Insert the sample data
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Solution: Transform to 2NF by removing partial dependencies
-- Create two separate tables: Orders and OrderItems

-- Create the Orders table to store order information
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create the OrderItems table to store product details for each order
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into the Orders table (removing duplicates)
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM OrderDetails;

-- Insert data into the OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetails;

-- Select from the 2NF tables to verify the transformation
SELECT * FROM Orders;
SELECT * FROM OrderItems;

-- Join the tables to show the complete information
SELECT o.OrderID, o.CustomerName, oi.Product, oi.Quantity
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;