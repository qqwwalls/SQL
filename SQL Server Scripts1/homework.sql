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
GO 

ALTER TABLE Teachers
ADD IsAssistant BIT NOT NULL CONSTRAINT DF_Teachers_IsAssistant DEFAULT 0;
GO

ALTER TABLE Teachers
ADD IsProfessor BIT NOT NULL CONSTRAINT DF_Teachers_IsProfessor DEFAULT 0;
GO

ALTER TABLE Teachers
ADD Position NVARCHAR(MAX) NOT NULL CONSTRAINT DF_Teachers_Position DEFAULT 'No Position'
    CHECK (LEN(Position) > 0);
GO

UPDATE Teachers
SET Position = 'Assistant', IsAssistant = 1
WHERE Name IN ('Ivan', 'Natalia');

UPDATE Teachers
SET Position = 'Professor', IsProfessor = 1
WHERE Name IN ('Iryna', 'Andrii');

UPDATE Teachers
SET Position = 'Lecturer'
WHERE Position = 'No Position';
GO

SELECT * FROM Teachers;
GO

ALTER TABLE Faculties
ALTER COLUMN Name NVARCHAR(100) NOT NULL;
GO

ALTER TABLE Faculties
ADD Dean NVARCHAR(MAX) NOT NULL CONSTRAINT DF_Faculties_Dean DEFAULT 'No Dean'
    CHECK (LEN(Dean) > 0);
GO

UPDATE Faculties
SET Dean = 'Dr. Ivanov'
WHERE Name = 'CS';

UPDATE Faculties
SET Dean = 'Dr. Petrenko'
WHERE Name = 'Math';

UPDATE Faculties
SET Dean = 'Dr. Shevchenko'
WHERE Dean = 'No Dean';
GO

SELECT * FROM Faculties;
GO

INSERT INTO [Group] (Name, Rating, Year)
VALUES
('G5A', 3, 5),
('G5B', 4, 5);
GO

INSERT INTO Departments (Name, Financing)
VALUES ('Software Development', 20000);
GO

INSERT INTO Faculties (Name, Dean)
VALUES ('Computer Science', 'Dr. Brown');
GO

INSERT INTO Teachers
(EmploymentDate, Name, Premium, Salary, Surname,
 IsAssistant, IsProfessor, Position)
VALUES
('2019-01-01','Test1',200,500,'Smallpay',1,0,'Assistant'),
('2018-02-02','Test2',150,400,'Lowmoney',1,0,'Assistant');
GO

-- 1. Таблиця кафедр у зворотному порядку полів
SELECT Financing, Name, Id
FROM Departments;
GO

-- 2. Назви груп та рейтинги з псевдонімами
SELECT Name AS [Group Name],
       Rating AS [Group Rating]
FROM [Group];
GO

-- 3. Прізвище + відсоток ставки від надбавки та від загальної зарплати
SELECT Surname,
       (Salary * 100.0 / NULLIF(Premium,0)) AS [Salary% of Premium],
       (Salary * 100.0 / (Salary + Premium)) AS [Salary% of Total]
FROM Teachers;
GO

-- 4. Факультети одним рядком
SELECT 'The dean of faculty ' + Name + ' is ' + Dean + '.'
       AS FacultyInfo
FROM Faculties;
GO

-- 5. Прізвища професорів зі ставкою > 1050
SELECT Surname
FROM Teachers
WHERE IsProfessor = 1
  AND Salary > 1050;
GO

-- 6. Назви кафедр з фінансуванням <11000 або >25000
SELECT Name
FROM Departments
WHERE Financing < 11000
   OR Financing > 25000;
GO

-- 7. Назви факультетів, окрім "Computer Science"
SELECT Name
FROM Faculties
WHERE Name <> 'Computer Science';
GO

-- 8. Прізвища та посади не професорів
SELECT Surname, Position
FROM Teachers
WHERE IsProfessor = 0;
GO

-- 9. Асистенти з Premium між 160 і 550
SELECT Surname, Position, Salary, Premium
FROM Teachers
WHERE IsAssistant = 1
  AND Premium BETWEEN 160 AND 550;
GO

-- 10. Прізвища та ставки асистентів
SELECT Surname, Salary
FROM Teachers
WHERE IsAssistant = 1;
GO

-- 11. Викладачі прийняті до 2000 року
SELECT Surname, Position
FROM Teachers
WHERE EmploymentDate < '2000-01-01';
GO

-- 12. Назви кафедр перед "Software Development"
SELECT Name AS [Name of Department]
FROM Departments
WHERE Name < 'Software Development'
ORDER BY Name;
GO

-- 13. Асистенти із зарплатою (Salary+Premium) ≤ 1200
SELECT Surname
FROM Teachers
WHERE IsAssistant = 1
  AND (Salary + Premium) <= 1200;
GO

-- 14. Групи 5 курсу з рейтингом 2–4
SELECT Name
FROM [Group]
WHERE Year = 5
  AND Rating BETWEEN 2 AND 4;
GO

-- 15. Асистенти зі ставкою <550 або Premium <200
SELECT Surname
FROM Teachers
WHERE IsAssistant = 1
  AND (Salary < 550 OR Premium < 200);
GO

