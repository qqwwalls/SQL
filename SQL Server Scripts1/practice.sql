CREATE DATABASE AcademyDB;
GO

USE AcademyDB;
GO

CREATE TABLE Faculties
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT CK_Faculties_Name_NotEmpty CHECK (Name <> '')
);

CREATE TABLE Departments
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
    Name NVARCHAR(100) NOT NULL UNIQUE,
    FacultyId INT NOT NULL,
    CONSTRAINT CK_Departments_Name_NotEmpty CHECK (Name <> ''),
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

CREATE TABLE Groups
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL UNIQUE,
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    CONSTRAINT CK_Groups_Name_NotEmpty CHECK (Name <> ''),
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE Subjects
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT CK_Subjects_Name_NotEmpty CHECK (Name <> '')
);

CREATE TABLE Teachers
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,
    Salary MONEY NOT NULL CHECK (Salary > 0),
    CONSTRAINT CK_Teachers_Name_NotEmpty CHECK (Name <> ''),
    CONSTRAINT CK_Teachers_Surname_NotEmpty CHECK (Surname <> '')
);

CREATE TABLE Lectures
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    DayOfWeek INT NOT NULL CHECK (DayOfWeek BETWEEN 1 AND 7),
    LectureRoom NVARCHAR(MAX) NOT NULL,
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    CONSTRAINT CK_Lectures_Room_NotEmpty CHECK (LectureRoom <> ''),
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsLectures
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);


INSERT INTO Faculties (Name)
VALUES 
('Computer Science'),
('Engineering');

INSERT INTO Departments (Financing, Name, FacultyId)
VALUES
(50000, 'Software Development', 1),
(30000, 'Cyber Security', 1),
(20000, 'Mechanical Systems', 2);

INSERT INTO Groups (Name, Year, DepartmentId)
VALUES
('SD101', 1, 1),
('SD201', 2, 1),
('CS101', 1, 2),
('MS101', 1, 3);

INSERT INTO Subjects (Name)
VALUES
('C# Programming'),
('Databases'),
('Algorithms'),
('Physics');

INSERT INTO Teachers (Name, Surname, Salary)
VALUES
('Dave', 'McQueen', 3000),
('Jack', 'Underhill', 3500),
('Anna', 'Smith', 2800);

INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId)
VALUES
(1, 'D201', 1, 1),
(2, 'D202', 2, 1),
(3, 'D201', 3, 2),
(4, 'A101', 4, 3),
(5, 'D201', 2, 2);

INSERT INTO GroupsLectures (GroupId, LectureId)
VALUES
(1,1),(1,2),
(2,1),(2,3),
(3,3),(3,5),
(4,4);


--1
SELECT COUNT(T.Id) AS TeacherCount
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON G.Id = GL.GroupId
JOIN Departments D ON G.DepartmentId = D.Id
WHERE D.Name = 'Software Development';

--2
SELECT COUNT(*) AS LectureCount
FROM Lectures L
JOIN Teachers T ON L.TeacherId = T.Id
WHERE T.Name = 'Dave' AND T.Surname = 'McQueen';

--3
SELECT COUNT(*) AS LectureCount
FROM Lectures
WHERE LectureRoom = 'D201';

--4
SELECT LectureRoom, COUNT(*) AS LectureCount
FROM Lectures
GROUP BY LectureRoom;

--5
SELECT COUNT(DISTINCT G.Id) AS StudentGroupsCount
FROM Lectures L
JOIN Teachers T ON L.TeacherId = T.Id
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON G.Id = GL.GroupId
WHERE T.Name = 'Jack' AND T.Surname = 'Underhill';

--6
SELECT AVG(T.Salary) AS AverageSalary
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON G.Id = GL.GroupId
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE F.Name = 'Computer Science';

--7
SELECT MIN(StudentCount) AS MinStudents,
       MAX(StudentCount) AS MaxStudents
FROM
(
    SELECT COUNT(GL.Id) AS StudentCount
    FROM Groups G
    LEFT JOIN GroupsLectures GL ON G.Id = GL.GroupId
    GROUP BY G.Id
) AS GroupCounts;

--8
SELECT AVG(Financing) AS AverageFinancing
FROM Departments;

--9
SELECT T.Name + ' ' + T.Surname AS FullName,
       COUNT(DISTINCT L.SubjectId) AS SubjectsCount
FROM Teachers T
LEFT JOIN Lectures L ON T.Id = L.TeacherId
GROUP BY T.Name, T.Surname;

--10
SELECT DayOfWeek,
       COUNT(*) AS LectureCount
FROM Lectures
GROUP BY DayOfWeek
ORDER BY DayOfWeek;

--11
SELECT L.LectureRoom,
       COUNT(DISTINCT D.Id) AS DepartmentsCount
FROM Lectures L
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON G.Id = GL.GroupId
JOIN Departments D ON G.DepartmentId = D.Id
GROUP BY L.LectureRoom;

--12
SELECT F.Name,
       COUNT(DISTINCT S.Id) AS SubjectsCount
FROM Faculties F
JOIN Departments D ON D.FacultyId = F.Id
JOIN Groups G ON G.DepartmentId = D.Id
JOIN GroupsLectures GL ON GL.GroupId = G.Id
JOIN Lectures L ON L.Id = GL.LectureId
JOIN Subjects S ON S.Id = L.SubjectId
GROUP BY F.Name;

--13
SELECT 
    T.Name + ' ' + T.Surname AS Teacher,
    L.LectureRoom,
    COUNT(*) AS LectureCount
FROM Lectures L
JOIN Teachers T ON L.TeacherId = T.Id
GROUP BY T.Name, T.Surname, L.LectureRoom;