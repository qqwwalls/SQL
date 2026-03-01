CREATE DATABASE SportsStore;
GO

USE SportsStore;
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(150) NOT NULL,
    Position NVARCHAR(100) NOT NULL,
    HireDate DATE NOT NULL,
    Gender NVARCHAR(10) NOT NULL CHECK (Gender IN ('Male','Female')),
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0)
);
GO
CREATE TABLE ArchivedEmployees (
    EmployeeID INT,
    FullName NVARCHAR(150),
    Position NVARCHAR(100),
    HireDate DATE,
    Gender NVARCHAR(10),
    Salary DECIMAL(10,2),
    DismissalDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    SaleDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Sales_Employee
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees(EmployeeID)
);
GO

CREATE TRIGGER trg_MoveToArchive
ON Employees
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ArchivedEmployees (
        EmployeeID,
        FullName,
        Position,
        HireDate,
        Gender,
        Salary
    )
    SELECT 
        EmployeeID,
        FullName,
        Position,
        HireDate,
        Gender,
        Salary
    FROM deleted;
END;
GO

INSERT INTO Employees (FullName, Position, HireDate, Gender, Salary)
VALUES ('Ivan Petrenko', 'Sales Manager', '2022-05-01', 'Male', 15000);
GO

DELETE FROM Employees WHERE EmployeeID = 1;
GO

SELECT * FROM ArchivedEmployees;
GO