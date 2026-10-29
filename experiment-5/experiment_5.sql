CREATE DATABASE IF NOT EXISTS EcommerceDB;
USE EcommerceDB;

DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Seller;

CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL,
    Parent_ID INT NULL,
    FOREIGN KEY (Parent_ID) REFERENCES Category(Category_ID) ON DELETE SET NULL
);

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    Seller_ID INT NOT NULL,
    Category_ID INT,
    FOREIGN KEY (Seller_ID) REFERENCES Seller(Seller_ID),
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID) ON DELETE SET NULL
);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);

CREATE TABLE OrderItem (
    Order_ID INT,
    Product_ID INT,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

INSERT INTO Seller VALUES (1, 'Tech Store', 'tech@example.com');
INSERT INTO Customer VALUES (1, 'Aditi Sharma', 'aditi@example.com');
INSERT INTO Category VALUES (1, 'Electronics', NULL), (2, 'Laptops', 1);
INSERT INTO Product VALUES (1, 'Engineering Laptop', 75000, 1, 2);
INSERT INTO Orders VALUES (1, 1, CURRENT_DATE);
INSERT INTO OrderItem VALUES (1, 1, 1);

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = DATABASE();
SELECT o.Order_ID, c.Customer_Name, p.Product_Name, oi.Quantity
FROM Orders o JOIN Customer c ON c.Customer_ID = o.Customer_ID
JOIN OrderItem oi ON oi.Order_ID = o.Order_ID
JOIN Product p ON p.Product_ID = oi.Product_ID;

