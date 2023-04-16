-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Lena Hamilton
-- Description: IPPS database

DROP DATABASE ipps;

CREATE DATABASE ipps;

\c ipps

-- create tables
CREATE TABLE Providers (
    Rndrng_Prvdr_CCN INT(6) PRIMARY KEY,
    Rndrng_Prvdr_Org_Name VARCHAR(100),
    Rndrng_Prvdr_St VARCHAR(50),
    Rndrng_Prvdr_City VARCHAR(30),
    Rndrng_Prvdr_State_Abrvtn CHAR(2),
    Rndrng_Prvdr_State_FIPS CHAR(2),
    Rndrng_Prvdr_Zip5 INT(5),
    Rndrng_Prvdr_RUCA INT(1),
    Rndrng_Prvdr_RUCA_Desc VARCHAR(100)
);

CREATE TABLE Classifications (
    DRG_Cd CHAR(10) PRIMARY KEY,
    DRG_Desc TEXT
);

CREATE TABLE Costs (
    Tot_Dschrgs INT,
    Avg_Submtd_Cvrd_Chrg NUMERIC(10, 2),
    Avg_Tot_Pymt_Amt NUMERIC(10, 2),
    Avg_Mdcr_Pymt_Amt NUMERIC(10, 2)
);

-- create user with appropriate access to the tables
CREATE USER ipps WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE ipps TO ipps;

-- queries

-- a) List all diagnosis in alphabetical order.
SELECT
FROM
WHERE
ORDER BY 

-- b) List the names and correspondent states (including Washington D.C.) of all of the providers in alphabetical order (state first, provider name next, no repetition).
SELECT
FROM
WHERE

-- c) List the total number of providers.
SELECT COUNT(DISTINCT Rndrng_Prvdr_Org_Name)
FROM Providers;

-- d) List the total number of providers per state (including Washington D.C.) in alphabetical order (also printing out the state).
SELECT
FROM
WHERE
GROUP BY

-- e) List the providers names in Denver (CO) or in Lakewood (CO) in alphabetical order
SELECT Rndrng_Prvdr_Org_Name AS name
FROM Providers
WHERE (Rndrng_Prvdr_City = 'Denver' OR Rndrng_Prvdr_City = 'Lakewood')
    AND Rndrng_Prvdr_State_Abrvtn = 'CO'
ORDER BY Rndrng_Prvdr_Org_Name ASC;

-- f) List the number of providers per RUCA code (showing the code and description)
SELECT COUNT()
FROM
WHERE
GROUP BY 

-- g) Show the DRG description for code 308
SELECT DRG_Desc AS 308_description
FROM Classifications
WHERE DRG_Cd = '308'

-- h) List the top 10 providers (with their correspondent state) that charged (as described in Avg_Submtd_Cvrd_Chrg) the most for the DRG code 308. Output should display the provider name, their city, state, and the average charged amount in descending order.
SELECT
FROM
WHERE

-- i) List the average charges (as described in Avg_Submtd_Cvrd_Chrg) of all providers per state for the DRG code 308. Output should display the state and the average charged amount per state in descending order (of the charged amount) using only two decimals.
SELECT
FROM
WHERE

-- j) Which provider and clinical condition pair had the highest difference between the amount charged (as described in Avg_Submtd_Cvrd_Chrg) and the amount covered by Medicare only (as described in Avg_Mdcr_Pymt_Amt)?
SELECT
FROM
WHERE