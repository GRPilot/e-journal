--
-- File generated with SQLiteStudio v3.2.1 on Thu Apr 9 17:42:43 2020
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: students
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id          INTEGER       PRIMARY KEY AUTOINCREMENT
                              NOT NULL
                              DEFAULT (0),
    [full name] VARCHAR (255) NOT NULL
                              DEFAULT ('name is not found'),
    [group]     VARCHAR (255) NOT NULL,
    curator     VARCHAR (255) NOT NULL
);


-- Table: teachers
DROP TABLE IF EXISTS teachers;

CREATE TABLE teachers (
    id          INTEGER       PRIMARY KEY AUTOINCREMENT
                              NOT NULL
                              DEFAULT (0) 
                              REFERENCES users ON DELETE NO ACTION
                                               ON UPDATE NO ACTION
                                               MATCH SIMPLE,
    username    VARCHAR (32)  NOT NULL
                              DEFAULT ('unknown'),
    [full name] VARCHAR (255) NOT NULL
                              DEFAULT username,
    subjects    VARCHAR (255),
    groups      VARCHAR (255) 
);

INSERT INTO teachers (id, username, "full name", subjects, groups) VALUES (0, 'test', 'test test', 'test', 'test');
INSERT INTO teachers (id, username, "full name", subjects, groups) VALUES (1, 'test2', 'test2 test2', 'test2', 'test2');

-- Table: users
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    username VARCHAR (32)  NOT NULL,
    password VARCHAR (255) NOT NULL
);

INSERT INTO users (username, password) VALUES ('test', 'testest');
INSERT INTO users (username, password) VALUES ('user2', 'test2');
INSERT INTO users (username, password) VALUES ('test1', 'test1');

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
