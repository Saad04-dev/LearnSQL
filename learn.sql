/*markdown
# SQL Consists of
- Data Definition Language (DDL)  
- Data Manipulation Language (DML)  
- Data Control Language (DCL)
*/

/*markdown
### DDL
- Create a relational database and change its schema  
### DML
- Insert, update and delete data  
- Retrieve data from the database (Query)  
### DCL
- Create users and define their roles in managing the database
*/

/*markdown
The SQL statement to define a database schema (set of relations)
*/

CREATE SCHEMA UNIVERSITY AUTHORIZATION 'Bahaa'; 
/* 
DROP SCHEMA UNIVERSITY CASCADE; (with all elements) 
DROP SCHEMA UNIVERSITY RESTRICT; (if no elements)
*/

/*markdown
Data Definition Using SQL (DDL)
*/

CREATE TABLE STUDENT(
	Id				INT, NOT NULL -- The not null keyword --
	Firstname		VARCHAR(200),
	Lastname		VARCHAR(200), 
	Email			CHAR(15)
	Gpa				FLOAT, NOT NULL
		CHECK (GPA > 0 AND GPA <= 4.3)
	Department		VARCHAR(200)
    UNIQUE(Email) -- To prevent duplicates --
    UNIQUE(Firstname, Lastname)
	CONSTRAINT STDPK -- To set a name for a constraint (optional) -- 
		PRIMARY KEY(Id) -- To set primary key -- ensures uniqueness and non-nullabiltly --
	);

CREATE TABLE PROFESSOR(
	Id 				INT, NOT NULL
	Firstname		VARCHAR(200)
	Lastname		VARCHAR(200)
	Email			VARCHAR(200)
	Department		VARCHAR(200)
	UNIQUE(Email)
	UNIQUE(Firstname, Lastname)
	PRIMARY KEY(Id)
)
/*
DROP TABLE PROFESSOR CASCADE; (All dependents dropped)
DROP TABLE PROFESSOR RESTRICT; (Dropped if no dependents)
*/

/*
DELETE TABLE PROFESSOR; (Deletes all tuples in the table, but it still exists)
*/

CREATE TABLE COURSE(
	Name				VARCHAR(100),
	Year				CHAR(4),
	Credit_hours		INT DEFAULT 3 -- The default keyword --
        CHECK (Credit_hours > 0 AND Credit_hours <= 4) -- A user defined condition -- Returns an error if not true --
	);

CREATE TABLE HOBBY(
	Student_id	INT NOT NULL,
	Hobby		VARCHAR(150) NOT NULL,
	PRIMARY KEY (Student_id, Hobby),
	FOREIGN KEY (Student_id) REFERENCES STUDENT (Id)
	ON DELETE RESTRICT ON UPDATE CASCADE -- See note --
	);

CREATE DOMAIN DSSN AS CHAR(9); -- To create a user defined domain --

/*markdown
**Note:** Actions taken on update or delete
- CASCADE: propagate the delete or update to referencing tuples if the referenced tuple is deleted or its primary key is updated
- RESTRICT: do not allow delete of referenced tuple or update of its primary key
- SET DEFAULT: set the value of the foreign key to the default value if the referenced tuple is deleted or its key is updated
- SET NULL: set the value of the foreign key to null if the referenced tuple is deleted or its key is updated
*/

/*markdown
Data Manipulation Using SQL (DML)
*/

INSERT INTO STUDENT (Id, Firstname, Lastname, Email, Gpa, Department) VALUES (235678, 'Alain', 'Malek', 'am00@aub.edu.lb', 3.6, 'Computer Science'); -- The attributes listed must exactly match the  values in order, number, and data types --

DELETE FROM STUDENT WHERE Id = 213467;
DELETE FROM COURSE WHERE Credit_hours > 3;
DELETE FROM STUDENT; -- Deletes all STUDENT --

UPDATE STUDENT SET Email = 'am01@aub.edu.lb' WHERE Id = 123476;
UPDATE COURSE SET Credit_hours = Credit_hours + 1 WHERE Credit_hours < 3;
UPDATE STUDENT SET Email = null; -- Updates all STUDENT --

SELECT Name, Year FROM COURSE WHERE Credit_hours <= 3; -- Quering based on a condition --
SELECT * FROM COURSE WHERE Credit_hours <=3 and Year > 2010; -- "*" instead of whole attribute list --
SELECT Name, Year FROM COURSE; -- Retrieve Name and Year from every course --
SELECT DISTINCT Name, Credit_hours FROM COURSE WHERE Credit_hours <= 3; -- Select without duplicates --
SELECT Name, Year, Credit_hours + 2 FROM COURSE; -- Applying arithmetic operations to numeric attributes --
SELECT * FROM COURSE WHERE Name LIKE 'CMPS 1%'; -- Retrieve tuples that one of their string attributes match a certain pattern by using the keyword LIKE in the where clause --
SELECT Firstname AS StudentName FROM STUDENT; -- To rename Firstname column --
SELECT STUDENT.Id FROM STUDENT, HOBBY WHERE STUDENT.Id = HOBBY.Student_id AND HOBBY.Hobby = 'BasketBall'; -- Joining relations implicitly --
SELECT STUDENT.Id FROM STUDENT JOIN HOBBY ON STUDENT.Id = HOBBY.Student_id WHERE HOBBY.Hobby = 'BasketBall'; -- Joining relations explicitly --
SELECT STUDENT.Id FROM STUDENT NATURAL JOIN HOBBY WHERE HOBBY.Hobby = 'BasketBall'; -- Performing a natural join --
SELECT STUDENT.Id, HOBBY.Hobby FROM STUDENT LEFT OUTER JOIN HOBBY ON STUDENT.Id = HOBBY.Student_id AND HOBBY.Hobby = 'BasketBall'; -- Performing a left outer join --
SELECT STUDENT.Id, HOBBY.Hobby FROM STUDENT FULL OUTER JOIN HOBBY ON STUDENT.Id = HOBBY.Student_id WHERE HOBBY.Hobby = 'BasketBall' OR HOBBY.Hobby IS NULL; -- Performing a full outer join --
SELECT Name, Year FROM COURSE WHERE Credit_hours <= 3 ORDER BY Name; -- To sort the result by name --
SELECT Name, Year FROM COURSE WHERE Credit_hours <= 3 ORDER BY Name DESC; -- To sort the result by name descendingly --
SELECT Name, Year FROM COURSE WHERE Credit_hours <= 3 ORDER BY Name DESC, Year ASC; -- To sort the result by name descendingly and year ascendingly --
SELECT COUNT(*) FROM COURSE WHERE Credit_hours = 3; -- To count the occurrences --
SELECT AVG(Gpa) FROM STUDENT; -- To calculate the average --
SELECT Department, MAX(Gpa) FROM STUDENT GROUP BY Department; -- To get maximum of a group --
SELECT Year, AVG(Credit_hours), FROM COURSE GROUP BY Year HAVING AVG(Credit_hours) > 2.5; -- Having keyword used to filter based on a condition --
SELECT Firstname, Lastname FROM PROFESSOR UNION SELECT Firstname, Lastname FROM STUDENT -- Performs a union operation on select queries, queries must have same number of columns --
SELECT Firstname, Lastname, Gpa FROM STUDENT WHERE Lastname = SELECT Lastname FROM PROFESSOR -- Subqueries inside nested queries --
SELECT Firstname, Lastname FROM STUDENT WHERE Firstname =ANY (SELECT Firstname FROM PROFESSOR); -- ANY operator --
SELECT Firstname, Lastname FROM STUDENT WHERE Firstname IN (SELECT Firstname FROM PROFESSOR); -- IN operator equivalent to =ANY --
SELECT Name, Year FROM COURSEWHERE Credit_hours > ALL (SELECT Credit_hours FROM COURSE WHERE Department = 'Computer Science'); -- ALL operator --
SELECT Firstname, Lastname FROM STUDENT WHERE EXISTS (SELECT * FROM HOBBY WHERE Student_id = Id); -- Exists operator --
CREATE VIEW CS_Students AS SELECT Firstname, Lastname, GPA FROM STUDENT WHERE Department = 'Computer Science'; -- Defining a view --

ALTER TABLE COURSE ADD COLUMN Professor_id INT; -- Alter a table by adding a column --
ALTER TABLE STUDENT DROP COLUMN EMAIL CASCADE; -- Remove columns, cascade means all dependent on the column are also dropped --
ALTER TABLE STUDENT DROP COLUMN EMAIL RESTRICT; -- Remove columns, cascade means the column is only dropped if it has no dependents --
ALTER TABLE COURSE ALTER COLUMN Credit_hours DROP DEFAULT; -- Alter column definition by dropping an existing default clause --
ALTER TABLE COURSE ALTER COLUMN Credit_hours SET DEFAULT; -- Alter column definition by defining a new default clause --
ALTER TABLE COURSE ADD CONSTRAINT FK_Course_Professor FOREIGN KEY (Professor_id) REFERENCES PROFESSOR(Id); -- Defining a constraint --
ALTER TABLE COURSE DROP CONSTRAINT FK_Course_Professor FOREIGN KEY (Professor_id) REFERENCES PROFESSOR(Id); -- Dropping a constraint --

/*markdown
**Note:** The data manipulation operations supported
- Insertion
- Deletion
- Update
- Retrieval (aka querying)

**Note:** If the list of attributes does not contain all attributes of the relation, the default value or the value null (if possible) is inserted for the missing attributes

**Note:** Omit the attribute list altogether, in which case the list of all attributes of the relation is assumed and their order is taken from the table definition 

**Note:** Arithmetic Operations can be applied to Numeric Attributes

**Note:** Set operations are:
- UNION
- INTERSECT
- EXCEPT

**Note:** Bag operations are:
- UNION ALL
- INTERSECT ALL
- EXCEPT ALL

**Note:** Operations can be negated using the NULL keyword

**Note:** Queries can be nested inside Inserts, Deletes, and Updates 

**Note:** A view is a virtual table created by a SQL query. It does not store data physically but acts as a saved query that can be referenced like a table.
*/