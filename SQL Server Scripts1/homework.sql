CREATE DATABASE UniversityDB;
GO

USE UniversityDB;
GO

CREATE TABLE Faculties (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE Departments (
    Id INT IDENTITY PRIMARY KEY,
    Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
    Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> ''),
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

CREATE TABLE Curators (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (Name <> ''),
    Surname NVARCHAR(MAX) NOT NULL CHECK (Surname <> '')
);

CREATE TABLE Teachers (
    Id INT IDENTITY PRIMARY KEY,
    IsProfessor BIT NOT NULL DEFAULT 0,
    Name NVARCHAR(MAX) NOT NULL CHECK (Name <> ''),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (Surname <> '')
);

CREATE TABLE Subjects (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE Groups (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (Name <> ''),
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE Students (
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (Name <> ''),
    Rating INT NOT NULL CHECK (Rating BETWEEN 0 AND 5),
    Surname NVARCHAR(MAX) NOT NULL CHECK (Surname <> '')
);

CREATE TABLE Lectures (
    Id INT IDENTITY PRIMARY KEY,
    Date DATE NOT NULL CHECK (Date <= GETDATE()),
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsCurators (
    Id INT IDENTITY PRIMARY KEY,
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

CREATE TABLE GroupsLectures (
    Id INT IDENTITY PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

CREATE TABLE GroupsStudents (
    Id INT IDENTITY PRIMARY KEY,
    GroupId INT NOT NULL,
    StudentId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (StudentId) REFERENCES Students(Id)
);


INSERT INTO Faculties (Name)
VALUES ('Computer Science'), ('Engineering');

INSERT INTO Departments (Building, Financing, Name, FacultyId)
VALUES 
(1, 150000, 'Software Development', 1),
(2, 90000, 'Cyber Security', 1),
(3, 200000, 'Mechanical Engineering', 2);

INSERT INTO Groups (Name, Year, DepartmentId)
VALUES 
('D221', 2, 1),
('S501', 5, 1),
('S502', 5, 1),
('C301', 3, 2);

INSERT INTO Curators (Name, Surname)
VALUES 
('John', 'Smith'),
('Anna', 'Brown'),
('Michael', 'Johnson');

INSERT INTO Teachers (IsProfessor, Name, Salary, Surname)
VALUES 
(1, 'Robert', 5000, 'Taylor'),
(1, 'William', 5500, 'Anderson'),
(0, 'Emily', 3000, 'Clark'),
(0, 'Daniel', 3500, 'White');

INSERT INTO Subjects (Name)
VALUES 
('Databases'),
('Algorithms'),
('Physics');

INSERT INTO Students (Name, Rating, Surname)
VALUES
('Alice', 5, 'Walker'),
('Bob', 4, 'Hall'),
('Charlie', 3, 'Allen'),
('David', 2, 'Young'),
('Eva', 5, 'King'),
('Frank', 1, 'Scott'),
('Grace', 4, 'Green'),
('Hannah', 3, 'Adams'),
('Ian', 5, 'Baker'),
('Jack', 4, 'Nelson'),
('Kate', 5, 'Carter'),
('Leo', 5, 'Mitchell');

INSERT INTO GroupsStudents (GroupId, StudentId)
VALUES
(1,1),(1,2),(1,3),
(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10),(2,11),(2,12),
(3,1),(3,2),(3,3),
(4,4),(4,5);

INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES
(1,1),(2,1),
(2,2),
(3,3);

INSERT INTO Lectures (Date, SubjectId, TeacherId)
VALUES
('2024-01-01',1,1),
('2024-01-02',1,1),
('2024-01-03',1,2),
('2024-01-04',2,2),
('2024-01-05',2,3),
('2024-01-06',3,4);

INSERT INTO GroupsLectures (GroupId, LectureId)
VALUES
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),
(3,1),(3,2),
(1,4),(1,5);

--1
SELECT Building
FROM Departments
GROUP BY Building
HAVING SUM(Financing) > 100000;

--2
SELECT g.Name
FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON gl.LectureId = l.Id
WHERE g.Year = 5 AND d.Name = 'Software Development'
GROUP BY g.Name
HAVING COUNT(gl.Id) > 10;

--3
SELECT g.Name
FROM Groups g
WHERE (
    SELECT AVG(s.Rating)
    FROM GroupsStudents gs
    JOIN Students s ON gs.StudentId = s.Id
    WHERE gs.GroupId = g.Id
) >
(
    SELECT AVG(s.Rating)
    FROM GroupsStudents gs
    JOIN Students s ON gs.StudentId = s.Id
    JOIN Groups gr ON gs.GroupId = gr.Id
    WHERE gr.Name = 'D221'
);

--4
SELECT Name, Surname
FROM Teachers
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Teachers
    WHERE IsProfessor = 1
);

--5
SELECT g.Name
FROM Groups g
JOIN GroupsCurators gc ON g.Id = gc.GroupId
GROUP BY g.Name
HAVING COUNT(gc.Id) > 1;

--6
SELECT g.Name
FROM Groups g
WHERE (
    SELECT AVG(s.Rating)
    FROM GroupsStudents gs
    JOIN Students s ON gs.StudentId = s.Id
    WHERE gs.GroupId = g.Id
) <
(
    SELECT MIN(avg_rating)
    FROM (
        SELECT AVG(s.Rating) AS avg_rating
        FROM Groups gr
        JOIN GroupsStudents gs ON gr.Id = gs.GroupId
        JOIN Students s ON gs.StudentId = s.Id
        WHERE gr.Year = 5
        GROUP BY gr.Id
    ) t
);

--7
SELECT f.Name
FROM Faculties f
WHERE (
    SELECT SUM(d.Financing)
    FROM Departments d
    WHERE d.FacultyId = f.Id
) >
(
    SELECT SUM(d.Financing)
    FROM Departments d
    JOIN Faculties f2 ON d.FacultyId = f2.Id
    WHERE f2.Name = 'Computer Science'
);

--8
SELECT s.Name AS SubjectName,
       t.Name + ' ' + t.Surname AS TeacherFullName
FROM Subjects s
JOIN Lectures l ON s.Id = l.SubjectId
JOIN Teachers t ON l.TeacherId = t.Id
GROUP BY s.Name, t.Name, t.Surname
HAVING COUNT(l.Id) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM Lectures
        GROUP BY SubjectId
    ) q
);

--9
SELECT TOP 1 s.Name
FROM Subjects s
JOIN Lectures l ON s.Id = l.SubjectId
GROUP BY s.Name
ORDER BY COUNT(l.Id) ASC;

--10
SELECT
(
    SELECT COUNT(DISTINCT gs.StudentId)
    FROM GroupsStudents gs
    JOIN Groups g ON gs.GroupId = g.Id
    JOIN Departments d ON g.DepartmentId = d.Id
    WHERE d.Name = 'Software Development'
) AS StudentsCount,
(
    SELECT COUNT(DISTINCT l.SubjectId)
    FROM GroupsLectures gl
    JOIN Groups g ON gl.GroupId = g.Id
    JOIN Departments d ON g.DepartmentId = d.Id
    JOIN Lectures l ON gl.LectureId = l.Id
    WHERE d.Name = 'Software Development'
) AS SubjectsCount;