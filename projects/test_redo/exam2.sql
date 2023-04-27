-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student: Lena Hamilton
-- Description: Exam 2 Take Home

CREATE DATABASE exam2;

\c exam2

-- todo 1. Create all the tables after normalization and populate them with the information from the (unnormalized) table.
CREATE TABLE Cars (
    plate_number CHAR(7) NOT NULL,
    car_type VARCHAR(10) NOT NULL,
    base_rent INT NOT NULL,
    PRIMARY KEY (plate_number)
)

INSERT INTO Cars VALUES
    ('XYZ-123', 'sedan', 40),
    ('ZZW-444', 'suv', 60),
    ('KKK-001', 'suv', 60);

CREATE TABLE Customers (
    cust_id INT NOT NULL,
    cust_name VARCHAR(50),
    PRIMARY KEY (cust_id)
)

INSERT INTO Customers VALUES
    (101, 'Sam'),
    (202, 'Jill');

CREATE TABLE Dates (
    date_rental CHAR(10) NOT NULL,
    feature_id INT NOT NULL,
    PRIMARY KEY (feature_id)
)

INSERT INTO Dates VALUES
    ('2023-01-01', 1),
    ('2023-01-01', 2),
    ('2023-01-01', 3),
    ('2023-01-02', 1),
    ('2023-03-05', 1),
    ('2023-02-05', 2),
    ('2023-02-05', 4);

CREATE TABLE Features (
    feature_id INT NOT NULL,
    feature_desc VARCHAR(30) NOT NULL,
    feature_price INT NOT NULL,
    PRIMARY KEY (feature_id)
);

INSERT INTO Features VALUES
    (1, 'gps', 10),
    (2, 'full tank', 40),
    (3, 'ezpas', 15),
    (4, 'self-driving', 200);

CREATE TABLE Rentals (
    plate_number FOREIGN KEY (plate_number) REFERENCES Cars(plate_number)
    cust_id FOREIGN KEY (cust_id) REFERENCES Customers(cust_id)
    date_rental FOREIGN KEY (date_rental) REFERENCES Dates(date_rental)
    feature_id FOREIGN KEY (feature_id) REFERENCES Features(feature_id)
);

-- todo2. Create and populate table Employees. Create trigger function doit and trigger trigger_doit. Simulate the insert of the new employee named Paul and copy and paste the result of querying Paul's salary (as a comment in the script).

CREATE TABLE Employees (
    ssn INT PRIMARY KEY,
    name TEXT NOT NULL,
    sal DECIMAL(10, 2) NOT NULL,
    sup int,
    FOREIGN KEY (sup) REFERENCES Employees (ssn)
);

INSERT INTO Employees VALUES
    (123456, 'Joe', 65.00),
    (456789, 'Marta', 75.00);

CREATE FUNCTION doit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE sup_sal DECIMAL(10, 2);
    BEGIN
        sup_sal := (
            SELECT sal FROM Employees WHERE ssn = NEW.sup
        );
        IF NEW.sup IS NOT NULL AND NEW.sup > sup_sal THEN
            NEW.sal = sup_sal;
        END IF;
        RETURN NEW;
    END;
$$;

CREATE TRIGGER trigger_doit
    BEFORE INSERT ON Employees
    FOR EACH ROW
        EXECUTE PROCEDURE doit();

--   ssn   | name |  sal
-- --------|------|-------
--  678901 | Paul | 75.00 


-- todo3. Create and populate table Visitors. Write all SQL statements asked in the exam (a, b, and c).

CREATE TABLE Visitors (
    id SERIAL PRIMARY KEY,
    date_time TIMESTAMP NOT NULL,
    floor INT NOT NULL,
    left_building BOOLEAN
);

INSERT INTO Visitors VALUES
    (1, 2023-04-01 10:00:00, 5, f),
    (2, 2023-04-01 10:15:00, 3, t),
    (3, 2023-04-01 10:15:00, 3, t),
    (4, 2023-04-01 11:15:00, 2, f),
    (5, 2023-04-01 13:15:00, 3, t),
    (6, 2023-04-02 07:15:00, 6, t),
    (7, 2023-04-02 09:15:00, 1, f);

SELECT COUNT(*) AS visitors 
FROM Visitors

SELECT DATE(date_time) AS day, COUNT(*) AS visitors
FROM Visitors
GROUP BY day
ORDER BY day

SELECT Count(*) AS visitors_still_in_the_building
FROM Visitors
WHERE Visitors.left_building = 'f' AND DATE(date_time) = '2023-04-02'

-- todo4. Create and populate tables Specialties and MadScientists. Write all SQL statements asked in the exam (a, b, and c). Copy and paste the result of query c (as a comment in the script).