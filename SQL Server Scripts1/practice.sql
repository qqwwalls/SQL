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

ALTER TABLE books
ADD price DECIMAL(10,2);
GO

UPDATE books SET price = 350.50 WHERE id = 1;
UPDATE books SET price = 280.00 WHERE id = 2;
UPDATE books SET price = 420.75 WHERE id = 3;
UPDATE books SET price = 150.00 WHERE id = 4;
GO

SELECT DISTINCT title
FROM books;
GO

SELECT TOP 5 *
FROM books;
GO

SELECT *
FROM books
WHERE price = (SELECT MAX(price) FROM books);
GO

SELECT AVG(price) AS AveragePrice
FROM books
WHERE [year] > 1830;
GO

SELECT
    COUNT(*) AS TotalBooks,
    SUM(price) AS TotalPrice,
    MIN(price) AS MinPrice,
    MAX(price) AS MaxPrice,
    AVG(price) AS AvgPrice
FROM books;
GO

SELECT
    a.name,
    a.surname,
    SUM(b.price) AS TotalPrice
FROM authors a
JOIN books b ON a.id = b.author_id
GROUP BY
    a.name,
    a.surname;