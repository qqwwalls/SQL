CREATE DATABASE Library_PV521;
USE Library_PV521;
GO

CREATE TABLE genres(
  id INT PRIMARY KEY IDENTITY(1,1),
  title NVARCHAR(50) NOT NULL
)

GO

CREATE TABLE authors(
  id INT PRIMARY KEY IDENTITY(1,1),
  name NVARCHAR(30) NOT NULL,
  surname NVARCHAR(30) NOT NULL
);

GO

CREATE TABLE books(
  id INT PRIMARY KEY IDENTITY(1,1),
  title NVARCHAR(50) NOT NULL,
  [year] int NOT NULL,
  price decimal(10,2) NOT NULL,
  id_author int FOREIGN KEY REFERENCES authors(id)
  ON DELETE CASCADE ON UPDATE CASCADE
);

GO

CREATE TABLE booktToGenres(
  id INT PRIMARY KEY IDENTITY(1,1),
  id_book INT FOREIGN KEY REFERENCES books(id),
  id_genre INT FOREIGN KEY REFERENCES genres(id)
);

INSERT INTO genres (title) VALUES 
('Fantasy'),
('Science Fiction'),
('Detective'),
('Romance'),
('Horror'),
('Historical'),
('Adventure'),
('Drama');

INSERT INTO authors (name, surname) VALUES
('Stephen', 'King'),
('Agatha', 'Christie'),
('J.K.', 'Rowling'),
('George', 'Orwell'),
('Jane', 'Austen'),
('Ernest', 'Hemingway'),
('Mark', 'Twain'),
('Arthur', 'Doyle');


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


INSERT INTO booktToGenres (id_book, id_genre) VALUES
(1, 5),  -- The Shining -> Horror
(2, 3),  -- Murder on the Orient Express -> Detective
(3, 1),  -- Harry Potter -> Fantasy
(3, 7),  -- Harry Potter -> Adventure
(4, 2),  -- 1984 -> Science Fiction
(4, 8),  -- 1984 -> Drama
(5, 4),  -- Pride and Prejudice -> Romance
(6, 8),  -- The Old Man and the Sea -> Drama
(7, 7),  -- Huckleberry Finn -> Adventure
(8, 3),  -- Sherlock Holmes -> Detective
(9, 2),  -- Animal Farm -> Science Fiction
(10, 5); -- It -> Horror

SELECT b.id, b.title, b.year, b.price, g.title FROM books b
INNER JOIN booktToGenres bg
ON b.id=bg.id_book
INNER JOIN genres g
ON bg.id_genre=g.id;

GO
SELECT b.id, b.title, b.year, b.price, g.title
FROM books b, genres g, booktToGenres bg
WHERE b.id=bg.id_book AND g.id=bg.id_genre

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
LEFT JOIN books b 
    ON a.id = b.id_author
LEFT JOIN booktToGenres bg 
    ON b.id = bg.id_book
GROUP BY 
    a.id,
    a.name,
    a.surname
ORDER BY a.id;

GO
SELECT 
    b.title,
    b.price,
    g.title AS genre
FROM books b
JOIN booktToGenres bg ON b.id = bg.id_book
JOIN genres g ON bg.id_genre = g.id
WHERE b.price = (
    SELECT MAX(price) 
    FROM books
);
GO

CREATE VIEW books_authors_view
AS
SELECT b.id, b.title, b.price, a.surname FROM books b
INNER JOIN authors a
ON b.id_author=a.id

GO
SELECT title FROM books_authors_view WHERE price>16;

GO

CREATE VIEW books_genres_view AS
SELECT 
    b.id AS book_id,
    b.title AS book_title,
    b.price,
    STRING_AGG(g.title, ', ') AS genres
FROM books b
JOIN booktToGenres bg ON b.id = bg.id_book
JOIN genres g ON bg.id_genre = g.id
GROUP BY b.id, b.title, b.price;
GO

SELECT *
FROM books_genres_view
WHERE price > 12
  AND genres NOT LIKE '%Fantasy%';
GO
--
ALTER TABLE books
ADD is_active BIT DEFAULT(1);

GO
SELECT * FROM books;
GO

UPDATE books SET is_active=1;

GO

ALTER TABLE books

GO
CREATE TRIGGER booksDeleteTrigger
ON books
INSTEAD OF DELETE
AS
BEGIN
  -- inserted, deleted
  UPDATE books SET is_active=0
  WHERE id IN(
  SELECT id FROM deleted)
END

GO

DROP TRIGGER  booksDeleteTrigger
GO

DELETE FROM books WHERE id IN(2,3);

SELECT * FROM books;

GO 
--
ALTER TABLE authors
ADD discount DECIMAL(5,2) NOT NULL DEFAULT 0;
GO

ALTER TABLE books
ADD base_price DECIMAL(10,2);
GO

UPDATE books
SET base_price = price;
GO

CREATE TRIGGER trg_UpdateAuthorDiscount
ON authors
AFTER UPDATE
AS
BEGIN
    IF UPDATE(discount)
    BEGIN
        UPDATE b
        SET b.price = b.base_price - (b.base_price * i.discount / 100)
        FROM books b
        INNER JOIN inserted i ON b.id_author = i.id
    END
END
GO

UPDATE authors
SET discount = 15
WHERE id = 1;

SELECT * FROM books;