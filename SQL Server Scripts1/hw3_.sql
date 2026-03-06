CREATE DATABASE Library__PV521;
GO

USE Library__PV521;
GO

CREATE TABLE genres(
  id INT PRIMARY KEY IDENTITY(1,1),
  title NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE authors(
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(30) NOT NULL,
  surname NVARCHAR(30) NOT NULL,
  discount DECIMAL(5,2) DEFAULT 0
);
GO

CREATE TABLE books(
  id INT PRIMARY KEY IDENTITY(1,1),
  title NVARCHAR(50) NOT NULL,
  [year] INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  id_author INT FOREIGN KEY REFERENCES authors(id)
  ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE booktToGenres(
  id INT PRIMARY KEY IDENTITY(1,1),
  id_book INT FOREIGN KEY REFERENCES books(id),
  id_genre INT FOREIGN KEY REFERENCES genres(id)
);
GO

INSERT INTO genres (title) VALUES 
('Fantasy'),
('Science Fiction'),
('Detective'),
('Romance'),
('Horror'),
('Historical'),
('Adventure'),
('Drama');
GO

INSERT INTO authors (name, surname) VALUES
('Stephen', 'King'),
('Agatha', 'Christie'),
('J.K.', 'Rowling'),
('George', 'Orwell'),
('Jane', 'Austen'),
('Ernest', 'Hemingway'),
('Mark', 'Twain'),
('Arthur', 'Doyle');
GO

INSERT INTO books (title, [year], price, id_author) VALUES
('The Shining', 1977, 15.99, 1),
('Murder on the Orient Express', 1934, 12.50, 2),
('Harry Potter and the Philosopher''s Stone', 1997, 20.00, 3),
('1984', 1949, 14.30, 4),
('Pride and Prejudice', 1813, 10.99, 5),
('The Old Man and the Sea', 1952, 13.45, 6),
('Adventures of Huckleberry Finn', 1884, 11.25, 7),
('Sherlock Holmes: A Study in Scarlet', 1887, 16.75, 8),
('Animal Farm', 1945, 9.99, 4),
('It', 1986, 18.60, 1);
GO

INSERT INTO booktToGenres (id_book, id_genre) VALUES
(1, 5),
(2, 3),
(3, 1),
(3, 7),
(4, 2),
(4, 8),
(5, 4),
(6, 8),
(7, 7),
(8, 3),
(9, 2),
(10, 5);
GO

SELECT b.id, b.title, b.year, b.price, g.title
FROM books b
INNER JOIN booktToGenres bg ON b.id = bg.id_book
INNER JOIN genres g ON bg.id_genre = g.id;
GO

SELECT b.id, b.title, b.year, b.price, g.title
FROM books b, genres g, booktToGenres bg
WHERE b.id = bg.id_book AND g.id = bg.id_genre;
GO

SELECT 
    b.title,
    a.name,
    a.surname,
    COUNT(bg.id_genre) AS genre_count
FROM books b
JOIN authors a ON b.id_author = a.id
LEFT JOIN booktToGenres bg ON b.id = bg.id_book
GROUP BY b.title, a.name, a.surname;
GO

SELECT 
    a.id,
    a.name,
    a.surname,
    COUNT(DISTINCT bg.id_genre) AS genre_count
FROM authors a
LEFT JOIN books b ON a.id = b.id_author
LEFT JOIN booktToGenres bg ON b.id = bg.id_book
GROUP BY a.id, a.name, a.surname
ORDER BY a.id;
GO

SELECT 
    b.title,
    b.price,
    g.title AS genre
FROM books b
JOIN booktToGenres bg ON b.id = bg.id_book
JOIN genres g ON bg.id_genre = g.id
WHERE b.price = (SELECT MAX(price) FROM books);
GO

CREATE VIEW books_authors_view
AS
SELECT b.id, b.title, b.price, a.surname 
FROM books b
INNER JOIN authors a ON b.id_author = a.id;
GO

SELECT title 
FROM books_authors_view 
WHERE price > 16;
GO

CREATE VIEW books_genres_view
AS
SELECT 
    b.id,
    b.title,
    b.price,
    g.title AS genre
FROM books b
JOIN booktToGenres bg ON b.id = bg.id_book
JOIN genres g ON bg.id_genre = g.id;
GO

SELECT *
FROM books_genres_view
WHERE price > 12
AND genre <> 'Fantasy';
GO

CREATE TRIGGER trg_UpdateBookPrices
ON authors
AFTER UPDATE
AS
BEGIN
    IF UPDATE(discount)
    BEGIN
        UPDATE b
        SET b.price = b.price - (b.price * i.discount / 100)
        FROM books b
        JOIN inserted i ON b.id_author = i.id
    END
END;
GO