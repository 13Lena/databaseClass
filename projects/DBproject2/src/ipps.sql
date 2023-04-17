-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Lena Hamilton
-- Description: IPPS database

DROP DATABASE IF EXISTS ipps;

CREATE DATABASE ipps;

\c ipps

-- create tables
CREATE TABLE Providers (
    Rndrng_Prvdr_CCN INT PRIMARY KEY,
    Rndrng_Prvdr_Org_Name VARCHAR(100),
    Rndrng_Prvdr_St VARCHAR(50),
    Rndrng_Prvdr_City VARCHAR(30),
    Rndrng_Prvdr_State_Abrvtn CHAR(2),
    Rndrng_Prvdr_State_FIPS CHAR(2),
    Rndrng_Prvdr_Zip5 INT,
    Rndrng_Prvdr_RUCA INT,
    Rndrng_Prvdr_RUCA_Desc VARCHAR(100)
);

CREATE TABLE Classifications (
    DRG_Cd CHAR(10) PRIMARY KEY,
    DRG_Desc TEXT
);

CREATE TABLE Costs (
    CNN INT,
    Dignosis_Code VARCHAR(10),
    Tot_Dschrgs INT,
    Avg_Submtd_Cvrd_Chrg NUMERIC(10, 2),
    Avg_Tot_Pymt_Amt NUMERIC(10, 2),
    Avg_Mdcr_Pymt_Amt NUMERIC(10, 2),
    FOREIGN KEY(CNN) REFERENCES Providers(Rndrng_Prvdr_CCN),
    FOREIGN KEY(Dignosis_Code) REFERENCES Classifications(DRG_Cd),
    PRIMARY KEY(CNN, Dignosis_Code)
);


-- create user with appropriate access to the tables
CREATE USER ipps WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE ipps TO ipps;

GRANT All ON TABLE Providers to ipps;
GRANT All ON TABLE Classifications to ipps;
GRANT All ON TABLE Costs to ipps;

-- queries

-- a) List all diagnosis in alphabetical order.
SELECT DISTINCT DRG_Desc AS diagnosis
FROM Classifications
ORDER BY diagnosis;

-- b) List the names and correspondent states (including Washington D.C.) of all of the providers in alphabetical order (state first, provider name next, no repetition).
SELECT Rndrng_Prvdr_State_Abrvtn AS state, Rndrng_Prvdr_Org_Name AS provider_name
FROM Providers
ORDER BY provider_name ASC;

-- c) List the total number of providers.
SELECT COUNT(DISTINCT Rndrng_Prvdr_Org_Name)
FROM Providers;

-- d) List the total number of providers per state (including Washington D.C.) in alphabetical order (also printing out the state).
SELECT Rndrng_Prvdr_State_Abrvtn AS state, COUNT(*)
FROM Providers
GROUP BY Rndrng_Prvdr_State_Abrvtn
ORDER BY Rndrng_Prvdr_State_Abrvtn ASC;

-- e) List the providers names in Denver (CO) or in Lakewood (CO) in alphabetical order
SELECT Rndrng_Prvdr_Org_Name AS provider_names_Denver_Lakewood
FROM Providers
WHERE (Rndrng_Prvdr_City = 'Denver' OR Rndrng_Prvdr_City = 'Lakewood')
    AND Rndrng_Prvdr_State_Abrvtn = 'CO'
ORDER BY Rndrng_Prvdr_Org_Name ASC;

-- f) List the number of providers per RUCA code (showing the code and description)
SELECT Rndrng_Prvdr_RUCA AS RUCA_code, Rndrng_Prvdr_RUCA_Desc AS description, COUNT(*)
FROM Providers
GROUP BY Rndrng_Prvdr_RUCA, Rndrng_Prvdr_RUCA_Desc;

-- g) Show the DRG description for code 308
SELECT DRG_Cd, DRG_Desc AS description
FROM Classifications
WHERE DRG_Cd = '308';

-- h) List the top 10 providers (with their correspondent state) that charged (as described in Avg_Submtd_Cvrd_Chrg) the most for the DRG code 308. Output should display the provider name, their city, state, and the average charged amount in descending order.
SELECT Providers.Rndrng_Prvdr_Org_Name AS provider_name, Providers.Rndrng_Prvdr_City AS city, Providers.Rndrng_Prvdr_State_Abrvtn AS state, Costs.Avg_Submtd_Cvrd_Chrg
FROM Providers
INNER JOIN Costs ON Providers.Rndrng_Prvdr_CCN = Costs.CNN
WHERE Costs.Dignosis_Code = '308'
ORDER BY Costs.Avg_Submtd_Cvrd_Chrg DESC LIMIT 10;

-- i) List the average charges (as described in Avg_Submtd_Cvrd_Chrg) of all providers per state for the DRG code 308. Output should display the state and the average charged amount per state in descending order (of the charged amount) using only two decimals.
SELECT Providers.Rndrng_Prvdr_State_Abrvtn AS state, ROUND(AVG(Avg_Submtd_Cvrd_Chrg)::numeric, 2) AS average_charges
FROM Providers, Costs
WHERE Dignosis_Code = '308' AND Providers.rndrng_prvdr_ccn = Costs.CNN
GROUP BY Providers.Rndrng_Prvdr_State_Abrvtn
ORDER BY average_charges DESC;

-- j) Which provider and clinical condition pair had the highest difference between the amount charged (as described in Avg_Submtd_Cvrd_Chrg) and the amount covered by Medicare only (as described in Avg_Mdcr_Pymt_Amt)?
SELECT Rndrng_Prvdr_Org_Name AS provider_name, DRG_Desc, (Avg_Submtd_Cvrd_Chrg - Avg_Mdcr_Pymt_Amt) AS difference
FROM Providers, Costs, Classifications
ORDER BY difference DESC LIMIT 1;
