CREATE DATABASE Academy_;
GO

USE Academy_;
GO

CREATE TABLE Faculties(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Financing MONEY NOT NULL DEFAULT 0 CHECK(Financing >= 0)
);
GO

CREATE TABLE Departments(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Financing MONEY NOT NULL DEFAULT 0 CHECK(Financing >= 0),
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);
GO

CREATE TABLE Groups(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL UNIQUE,
    Year INT NOT NULL CHECK(Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);
GO

CREATE TABLE Teachers(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,
    Salary MONEY NOT NULL CHECK(Salary > 0)
);
GO

CREATE TABLE Subjects(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Lectures(
    Id INT IDENTITY PRIMARY KEY,
    LectureRoom NVARCHAR(MAX) NOT NULL,
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);
GO

CREATE TABLE GroupsLectures(
    Id INT IDENTITY PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);
GO

CREATE TABLE Curators(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL
);
GO

CREATE TABLE GroupsCurators(
    Id INT IDENTITY PRIMARY KEY,
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);
GO

INSERT INTO Faculties(Name, Financing)
VALUES 
('Computer Science', 100000),
('Engineering', 80000);
GO

INSERT INTO Departments(Name, Financing, FacultyId)
VALUES
('Software Development', 60000, 1),
('Artificial Intelligence', 50000, 1),
('Mechanical Engineering', 90000, 2);
GO

INSERT INTO Groups(Name, Year, DepartmentId)
VALUES
('P107', 1, 1),
('P205', 5, 1),
('A301', 5, 2);
GO

INSERT INTO Teachers(Name, Surname, Salary)
VALUES
('Samantha', 'Adams', 5000),
('John', 'Smith', 4500),
('Emily', 'Brown', 4700);
GO

INSERT INTO Subjects(Name)
VALUES
('Theory of Databases'),
('Algorithms'),
('Physics');
GO

INSERT INTO Lectures(LectureRoom, SubjectId, TeacherId)
VALUES
('B103', 1, 1),
('A201', 2, 2),
('B103', 3, 3);
GO

INSERT INTO GroupsLectures(GroupId, LectureId)
VALUES
(1,1),
(2,1),
(2,2),
(3,3);
GO

INSERT INTO Curators(Name, Surname)
VALUES
('Michael','Johnson'),
('Laura','Wilson');
GO

INSERT INTO GroupsCurators(CuratorId, GroupId)
VALUES
(1,1),
(2,2);
GO

--1
SELECT t.Name + ' ' + t.Surname, g.Name
FROM Teachers t
CROSS JOIN Groups g;
GO

--2
SELECT f.Name
FROM Faculties f
JOIN Departments d ON d.FacultyId = f.Id
GROUP BY f.Id, f.Name, f.Financing
HAVING SUM(d.Financing) > f.Financing;
GO

--3
SELECT c.Surname, g.Name
FROM Curators c
JOIN GroupsCurators gc ON gc.CuratorId = c.Id
JOIN Groups g ON g.Id = gc.GroupId;
GO

--4
SELECT DISTINCT t.Surname
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
WHERE g.Name = 'P107';
GO

--5
SELECT DISTINCT t.Surname, f.Name
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
JOIN Departments d ON d.Id = g.DepartmentId
JOIN Faculties f ON f.Id = d.FacultyId;
GO

--6
SELECT d.Name, g.Name
FROM Departments d
JOIN Groups g ON g.DepartmentId = d.Id;
GO

--7
SELECT DISTINCT s.Name
FROM Subjects s
JOIN Lectures l ON l.SubjectId = s.Id
JOIN Teachers t ON t.Id = l.TeacherId
WHERE t.Name = 'Samantha' AND t.Surname = 'Adams';
GO

--8
SELECT DISTINCT d.Name
FROM Departments d
JOIN Groups g ON g.DepartmentId = d.Id
JOIN GroupsLectures gl ON gl.GroupId = g.Id
JOIN Lectures l ON l.Id = gl.LectureId
JOIN Subjects s ON s.Id = l.SubjectId
WHERE s.Name = 'Theory of Databases';
GO

--9
SELECT g.Name
FROM Groups g
JOIN Departments d ON d.Id = g.DepartmentId
JOIN Faculties f ON f.Id = d.FacultyId
WHERE f.Name = 'Computer Science';
GO

--10
SELECT g.Name, f.Name
FROM Groups g
JOIN Departments d ON d.Id = g.DepartmentId
JOIN Faculties f ON f.Id = d.FacultyId
WHERE g.Year = 5;
GO

--11
SELECT t.Surname, s.Name, g.Name
FROM Teachers t
JOIN Lectures l ON l.TeacherId = t.Id
JOIN Subjects s ON s.Id = l.SubjectId
JOIN GroupsLectures gl ON gl.LectureId = l.Id
JOIN Groups g ON g.Id = gl.GroupId
WHERE l.LectureRoom = 'B103';
GO