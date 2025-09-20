show databases;
create database  restaurants;
use  restaurants;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(50)
);


CREATE TABLE Menu (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(50),
    Category VARCHAR(30),
    Price DECIMAL(8,2)
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATETIME DEFAULT NOW(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ItemID INT,
    Quantity INT,
    FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY(ItemID) REFERENCES Menu(ItemID)
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Role VARCHAR(30),
    Salary DECIMAL(10,2)
);

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ReservationDate DATETIME,
    TableNo INT,
    Guests INT,
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PaymentMode VARCHAR(20), -- Cash, Card, UPI
    Amount DECIMAL(10,2),
    PaymentDate DATETIME DEFAULT NOW(),
    FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Contact VARCHAR(20)
);

CREATE TABLE Inventory (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    Ingredient VARCHAR(50),
    QuantityAvailable INT,
    SupplierID INT,
    FOREIGN KEY(SupplierID) REFERENCES Suppliers(SupplierID)
);


INSERT INTO Customers (Name, Phone, Email) VALUES
('Akhila', '9876543210', 'akhila@email.com'),
('Ravi', '9123456789', 'ravi@email.com'),
('Priya', '9001122334', 'priya@email.com'),
('Anil', '7894561230', 'anil@email.com'),
('Meena', '8529637410', 'meena@email.com'),
('Suresh', '7412589630', 'suresh@email.com'),
('Neha', '9638527410', 'neha@email.com'),
('Rahul', '7891234560', 'rahul@email.com');

-- Menu
INSERT INTO Menu (ItemName, Category, Price) VALUES
('Pizza', 'Main Course', 250.00),
('Burger', 'Snacks', 120.00),
('Pasta', 'Main Course', 200.00),
('Coke', 'Drinks', 50.00),
('Coffee', 'Drinks', 80.00),
('Fried Rice', 'Main Course', 180.00),
('Sandwich', 'Snacks', 90.00),
('Ice Cream', 'Dessert', 100.00),
('Brownie', 'Dessert', 120.00);


INSERT INTO Orders(CustomerID,TotalAmount) VALUES
(1, 300.00),
(2, 370.00),
(3, 250.00),
(4, 500.00),
(5, 180.00),
(6, 450.00),
(7, 290.00),
(8, 320.00);

INSERT INTO OrderDetails (OrderID, ItemID, Quantity) VALUES
(1, 1, 1),  
(1, 4, 1), 
(2, 2, 2), 
(2, 4, 1), 
(3, 3, 1), 
(4, 6, 2),  
(4, 9, 1),  
(5, 7, 2),  
(6, 1, 1), 
(6, 8, 2),  
(7, 2, 1),  
(7, 5, 1),  
(8, 3, 1), 
(8, 9, 1); 

INSERT INTO Staff (Name, Role, Salary) VALUES
('Kiran', 'Chef', 25000.00),
('Sneha', 'Waiter', 15000.00),
('Manoj', 'Manager', 35000.00),
('Aarti', 'Chef', 27000.00),
('Deepak', 'Waiter', 16000.00),
('Rohit', 'Cashier', 20000.00);

INSERT INTO Reservations (CustomerID, ReservationDate, TableNo, Guests) VALUES
(1, '2025-09-25 19:00:00', 5, 4),   -- Akhila
(2, '2025-09-26 20:00:00', 3, 2),   -- Ravi
(3, '2025-09-27 18:30:00', 1, 3),   -- Priya
(4, '2025-09-27 21:00:00', 6, 5),   -- Anil
(5, '2025-09-28 19:30:00', 2, 2);   -- Meena

INSERT INTO Payments (OrderID, PaymentMode, Amount) VALUES
(1, 'Cash', 300.00),
(2, 'UPI', 370.00),
(3, 'Card', 250.00),
(4, 'UPI', 500.00),
(5, 'Cash', 180.00),
(6, 'Card', 450.00),
(7, 'UPI', 290.00),
(8, 'Cash', 320.00);

INSERT INTO Suppliers (Name, Contact) VALUES
('Fresh Farms', '9876543210'),
('Daily Dairy', '9123456789'),
('Grain Hub', '9001122334'),
('Beverage Co', '7894561230'),
('Sweet Treats', '8529637410');

INSERT INTO Inventory (Ingredient, QuantityAvailable, SupplierID) VALUES
('Cheese', 50, 1),
('Milk', 100, 2),
('Wheat Flour', 200, 3),
('Coke Bottles', 80, 4),
('Coffee Beans', 40, 4),
('Rice', 150, 3),
('Ice Cream Powder', 60, 5),
('Chocolate Syrup', 30, 5);

-- Count total menu items
SELECT COUNT(*) AS Total_items
FROM Menu;

-- Find cheapest menu item
SELECT *
FROM Menu
WHERE Price = (SELECT MIN(Price) FROM Menu);

-- Find most expensive menu item
SELECT *
FROM Menu
WHERE Price = (SELECT MAX(Price) FROM Menu);

-- Menu items priced above 150
SELECT ItemName, Price 
FROM Menu
WHERE Price > 150;

-- Staff ordered by salary descending
SELECT * 
FROM Staff
ORDER BY Salary DESC;

-- Staff member with highest salary
SELECT Name, Role, Salary
FROM Staff
WHERE Salary = (SELECT MAX(Salary) FROM Staff);

-- Total number of orders
SELECT COUNT(*) AS Total_Orders
FROM Orders;

-- Total revenue from all orders
SELECT SUM(TotalAmount) AS Total_Revenue
FROM Orders;

-- Customers who placed orders
SELECT DISTINCT c.CustomerID, c.Name, c.Phone, c.Email
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Count of orders per customer
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;

-- Most ordered menu item
SELECT m.ItemName, COUNT(*) AS TimesOrdered
FROM OrderDetails od
JOIN Menu m ON od.ItemID = m.ItemID
GROUP BY m.ItemName
ORDER BY TimesOrdered DESC
LIMIT 1;

-- List upcoming reservations with customer names
SELECT r.ReservationID, c.Name, r.ReservationDate, r.TableNo, r.Guests
FROM Reservations r
JOIN Customers c ON r.CustomerID = c.CustomerID;

-- Total payments grouped by payment mode
SELECT PaymentMode, SUM(Amount) AS TotalRevenue
FROM Payments
GROUP BY PaymentMode;

-- Ingredients with low stock (less than 50)
SELECT Ingredient, QuantityAvailable
FROM Inventory
WHERE QuantityAvailable < 50;

-- Suppliers providing more than one ingredient
SELECT s.Name, COUNT(i.ItemID) AS IngredientsSupplied
FROM Suppliers s
JOIN Inventory i ON s.SupplierID = i.SupplierID
GROUP BY s.Name
HAVING COUNT(i.ItemID) > 1;








