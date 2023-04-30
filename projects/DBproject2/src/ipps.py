"""
CS3810: Principles of Database Systems
Instructor: Thyago Mota
Student(s): Lena Hamilton
Description: A data load script for the IPPS database
"""

import psycopg2
import configparser as cp
import csv

config = cp.RawConfigParser()
config.read('ConfigFile.properties')
params = dict(config.items('db'))

with open('../data/MUP_IHP_RY22_P02_V10_DY20_PrvSvc.csv') as csvfile:
    with psycopg2.connect(**params) as conn:
        print('Connection to Postgres database ' +
            params['dbname'] + ' was successful!')
        spamreader = csv.reader(csvfile, delimiter=',', quotechar='"')
        next(spamreader)
        with conn.cursor() as cur:
            cur.execute("""
                PREPARE i1 AS INSERT INTO Providers(Rndrng_Prvdr_CCN,
                Rndrng_Prvdr_Org_Name, Rndrng_Prvdr_St, Rndrng_Prvdr_City,
                Rndrng_Prvdr_State_Abrvtn, Rndrng_Prvdr_State_FIPS,
                Rndrng_Prvdr_Zip5, Rndrng_Prvdr_RUCA, Rndrng_Prvdr_RUCA_Desc)
                VALUES ($1, $2, $3, $4, $5, $6,$7, $8, $9)
                ON CONFLICT DO NOTHING;

                PREPARE i2 AS INSERT INTO Classifications(DRG_Cd, DRG_Desc)
                VALUES ($1, $2) ON CONFLICT DO NOTHING;

                PREPARE i3 AS INSERT INTO Costs(CnN, Dignosis_Code,
                Tot_Dschrgs, Avg_Submtd_Cvrd_Chrg, Avg_Tot_Pymt_Amt,
                Avg_Mdcr_Pymt_Amt)
                VALUES ($1, $2, $3, $4, $5, $6) ON CONFLICT DO NOTHING;
            """)
            for row in spamreader:
                cur.execute(
                    "EXECUTE i1(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                    (
                        float(row[0]),
                        row[1],
                        row[2],
                        row[3],
                        row[4],
                        row[5],
                        float(row[6]),
                        float(row[7]),
                        row[8]
                    )
                )
                cur.execute("EXECUTE i2(%s, %s)", (row[9], row[10]))
                cur.execute(
                    "EXECUTE i3 (%s, %s, %s, %s, %s, %s)",
                    (
                        float(row[0]),
                        row[9],
                        float(row[11]),
                        float(row[12]),
                        float(row[13]),
                        float(row[14])
                    )
                )
        print('Bye!')
