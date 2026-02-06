USE book__store;
GO

CREATE TABLE authors(
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(30) NOT NULL,
  surname NVARCHAR(30) NOT NULL
);
GO

CREATE TABLE genre(
  id INT PRIMARY KEY IDENTITY(1,1),
  genre NVARCHAR(30) NOT NULL
);
GO

CREATE TABLE books(
  id INT PRIMARY KEY IDENTITY(1,1),
  title NVARCHAR(30) NOT NULL,
  [year] INT NOT NULL 
        CHECK ([year] >= 1800 AND [year] <= YEAR(GETDATE())),
  author_id INT NOT NULL 
        FOREIGN KEY REFERENCES authors(id),
  genre_id INT NOT NULL 
        FOREIGN KEY REFERENCES genre(id)
);
GO


INSERT INTO genre (genre)
VALUES 
('Fantasy'),
('Detective'),
('Science Fiction'),
('Drama');
GO

INSERT INTO authors (name, surname)
VALUES
('J.K.', 'Rowling'),
('Arthur', 'Doyle'),
('Isaac', 'Asimov'),
('William', 'Shakespeare');
GO

INSERT INTO books (title, [year], author_id, genre_id)
VALUES
('Harry Potter', 1997, 1, 1),
('Sherlock Holmes', 1892, 2, 2),
('Foundation', 1951, 3, 3),
('Hamlet', 1803, 4, 4);  
GO

SELECT
    b.title AS Book,
    a.name + ' ' + a.surname AS Author,
    g.genre AS Genre
FROM books b
JOIN authors a ON b.author_id = a.id
JOIN genre g ON b.genre_id = g.id;
GO
