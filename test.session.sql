--SQL Guide

--@block
--PRIMARY KEY: id must be unique, not NULL;
--AUTO_INCREMENT: starts at 1, increases 1 each uniquely;
--VARCHAR(255) allows 255 characters (countable with 8 bit);
--NOT NULL: can't be null
--UNIQUE: must be unique (no duplicates)
--VARCHAR(2): max length of 2 is enforced
--@block
CREATE TABLE Users (
    id INT PRIMARY KEY AUTO_INCREMENT, 
    email VARCHAR(255) NOT NULL UNIQUE,
    bio TEXT,
    country VARCHAR(2)
);

--@block
--id is left out, mySQL creates id anyways
--must adhere to VARCHAR(length)
--running once updates table, each repeated run matters
--@block
INSERT INTO Users (email, bio, country)
VALUES ('hello4@world.com', 'i love this!', 'US'),
('hello123@world.com', 'i love that!', 'CA');


--@block
SELECT * FROM Users;


--@block
--LIMIT: custom amount of output
--ORDER BY name (ASC/DESC): orders by an input
--WHERE: certain equivalance condition
--AND/OR: additional filter
--All constraing contained within same select statement, then ;
--@block
SELECT email, id FROM USERS
WHERE country = 'US' AND id > 1
ORDER BY id DESC
LIMIT 2;


--@block
--LIKE: finds patterns
--LIKE 'h%': returns things that start with h
--@block
SELECT email, id FROM USERS
WHERE country = 'US'
AND email LIKE 'h%'
ORDER BY id DESC
LIMIT 2;


--@block
--Regular lookup be slow, especially for large query
--Index faster, requires more memory
--INDEX: lookup table for specific columns
--CREATE INDEX indexName ON table(column)
--@block
CREATE INDEX email_index ON Users(email);


--@block
--Create new table called Rooms
--Relation between Users and Rooms:
--    One to many
--    1 User can have many Rooms
--id is primary key, owner_id is foreign key
--foreign keys come from different tables
--    we have pointed id to PRIMARY KEY()
--    we have pointed owner_id to FOREIGN KEY()
--        but we must tell it where it comes from
--        REFERENCES table(column)
--@block
CREATE TABLE Rooms (
    id INT AUTO_INCREMENT,
    street VARCHAR(255),
    owner_id INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(owner_id) REFERENCES Users(id)
);

--@block
--populate with data
--all owned by same owner_id which is 1
--@block
INSERT INTO Rooms(owner_id, street) 
VALUES
(1, 'Whitekirk ST'),
(1, 'Trilebrough'),
(1, 'Hemmingway'),
(5, 'New York ST'),
(5, 'Chicago');

--@block
--a JOIN combines data from two tables
--types: left (includes middle), right (includes middle)
--inner (middle), outer (everything)
--   not all users own a room
--   we will connect Users(id) to Rooms(owner_id)

--this will return the Users table, with the additional columns from Rooms
--and the only rows that come back are 
--     where the owner_id from Rooms = the id from Users
--     representing all of the owners, and each room they own

--@block
SELECT * FROM Users
INNER JOIN Rooms
  ON Rooms.owner_id = Users.id;



--@block
--could also do a left join, i.e. get all users
--but users without a room will just have NULL values
--complete Users table, but only fills rows that satisfy ON condition
--when we have conflicting column names, mySQL fills it in with table.name

--@block
SELECT * FROM Users
LEFT JOIN Rooms
  ON Rooms.owner_id = Users.id;


--@block
--when we have conflicting column names, mySQL fills it in with table.name
--can change with AS (alias)
--@block
SELECT 
    Users.id as Owners,
    Rooms.id as Rooms
FROM Users
LEFT JOIN Rooms
  ON Rooms.owner_id = Users.id;


--@block
--reservations, acts as middle man
--2 foreign keys, REFERENCES Users and Rooms
--which user is reserving which room
--@block
CREATE TABLE Bookings (
    id INT AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATETIME,
    PRIMARY KEY(id),
    FOREIGN KEY (guest_id) REFERENCES Users(id),
    FOREIGN KEY (room_id) REFERENCES Rooms(id)
);


--@block
--finds rooms a user (1) has reserved
--@block
SELECT
    guest_id,
    street,
    check_in
FROM Bookings
INNER JOIN ROOMS 
ON Rooms.owner_id = Bookings.guest_id
WHERE guest_id = 1;

--@block
--finds history of room's users
--@block
SELECT
    room_id,
    guest_id,
    email,
    bio
FROM Bookings
INNER JOIN Users 
ON Users.id = guest_id
WHERE room_id = 1;


--@block
--delete table
--@block
DROP TABLE Users;
DROP TABLE Rooms;
DROP Table Bookings;