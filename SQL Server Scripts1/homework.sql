CREATE DATABASE Academy
USE Academy ;
CREATE TABLE [Group] (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    Rating INT NOT NULL CHECK (Rating >= 0 AND Rating <= 5),
    Year INT NOT NULL CHECK (Year > 0 AND Year <= 5)
);
INSERT INTO [Group] (Name, Rating, Year)
VALUES
('G1', 1, 1),
('G2', 2, 2),
('G3', 3, 3);

SELECT * FROM [Group];
GO

CREATE TABLE Departments
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Financing MONEY NOT NULL 
        CONSTRAINT DF_Departments_Financing DEFAULT 0
        CHECK (Financing >= 0),
    Name NVARCHAR(100) NOT NULL
        UNIQUE
        CHECK (LEN(Name) > 0)
);

GO 
INSERT INTO Departments (Name, Financing)
VALUES
('Computer Science', 120000),
('Mathematics', 80000),
('Physics', 95000),
('Chemistry', 60000),
('Biology', 70000),
('History', 30000),
('Philosophy', 20000),
('Economics', 110000),
('Law', 90000),
('Engineering', 150000);

SELECT * FROM Departments;

GO

CREATE TABLE Faculties
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

INSERT INTO Faculties (Name)
VALUES
('CS'),
('Math'),
('Phys'),
('Chem'),
('Bio'),
('Law'),
('Econ'),
('Hist'),
('Phil'),
('Eng');

SELECT * FROM Faculties;

GO

CREATE TABLE Teachers
(
    Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,

    EmploymentDate DATE NOT NULL
        CHECK (EmploymentDate >= '1990-01-01'),

    Name NVARCHAR(MAX) NOT NULL
        CHECK (LEN(Name) > 0),

    Premium MONEY NOT NULL
        CONSTRAINT DF_Teachers_Premium DEFAULT 0
        CHECK (Premium >= 0),

    Salary MONEY NOT NULL
        CHECK (Salary > 0),

    Surname NVARCHAR(MAX) NOT NULL
        CHECK (LEN(Surname) > 0)
);
GO 

INSERT INTO Teachers (EmploymentDate, Name, Premium, Salary, Surname)
VALUES
('1995-03-12', 'Ivan', 500, 12000, 'Petrenko'),
('2001-07-25', 'Olena', 0, 15000, 'Shevchenko'),
('2010-09-01', 'Mykola', 300, 11000, 'Bondarenko'),
('1998-11-18', 'Iryna', 1000, 17000, 'Tkachenko'),
('2005-02-14', 'Serhii', 0, 13000, 'Kovalchuk'),
('2018-06-30', 'Natalia', 200, 14000, 'Melnyk'),
('1992-01-05', 'Andrii', 750, 16000, 'Kravchenko'),
('2020-09-10', 'Viktor', 0, 12500, 'Lysenko'),
('1999-04-21', 'Tetiana', 400, 13500, 'Moroz'),
('2003-12-03', 'Dmytro', 600, 15500, 'Polishchuk');

SELECT * FROM Teachers;