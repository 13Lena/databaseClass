"""
CS3810: Principles of Database Systems
Instructor: Thyago Mota
Student(s): Lena Hamilton
Description: A room reservation system
"""

import psycopg2
from psycopg2 import extensions, errors
import configparser as cp


def menu():
    """List user menu."""
    print('1. List')
    print('2. Reserve')
    print('3. Delete')
    print('4. Quit')


def db_connect():
    """Open start configs, and list prepared statements."""
    config = cp.RawConfigParser()
    config.read('ConfigFile.properties')
    params = dict(config.items('db'))
    conn = psycopg2.connect(**params)
    conn.autocommit = False
    with conn.cursor() as cur:
        cur.execute('''
            PREPARE QueryReservationExists AS
                SELECT * FROM Reservations
                WHERE abbr = $1 AND room = $2 AND date = $3 AND period = $4;
        ''')
        cur.execute('''
            PREPARE QueryReservationExistsByCode AS
                SELECT * FROM Reservations
                WHERE code = $1;
        ''')
        cur.execute('''
            PREPARE NewReservation AS
                INSERT INTO Reservations (abbr, room, date, period) VALUES
                ($1, $2, $3, $4);
        ''')
        cur.execute('''
            PREPARE UpdateReservationUser AS
                UPDATE Reservations SET "user" = $1
                WHERE abbr = $2 AND room = $3 AND date = $4 AND period = $5;
        ''')
        cur.execute('''
            PREPARE DeleteReservation AS
                DELETE FROM Reservations WHERE code = $1;
        ''')
    return conn


# TODO: display all reservations using information from ReservationsView
def list_op(conn):
    """Display all reservations using ReservationsView."""
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM ReservationsView;")
        rows = cur.fetchall()
        for row in rows:
            code, date, period, start, end, building, room, user = row


# TODO: reserve a room on a specific date and period
# TODO: also saving the user who the reservation is for
def reserve_op(conn):
    """Reserve room function."""
    with conn.cursor() as cur:
        date = input("Date (YYYY-MM-DD): ")
        period = input("Period (A-H): ")
        building = input("Building: ")
        room = input("Room: ")
        user = input("User: ")
        try:
            conn.set_isolation_level(extensions.ISOLATION_LEVEL_SERIALIZABLE)
            cur.execute("EXECUTE QueryReservationExists (%s, %s, %s, %s);",
                        (building, room, date, period))
            if cur.fetchone() is not None:
                conn.rollback()
                print("Room not available.")
                return
            cur.execute("EXECUTE NewReservation (%s, %s, %s, %s);",
                        (building, room, date, period))
            conn.commit()
            cur.execute("EXECUTE UpdateReservationUser (%s, %s, %s, %s, %s);",
                        (user, building, room, date, period))
            conn.commit()
            print("Reservation successful.")
        except errors.DeadlockDetected:
            conn.rollback()
            print("Reservation could not be secured.")


# TODO: delete a reservation given its code
def delete_op(conn):
    """Delete reservation function."""
    with conn.cursor() as cur:
        code = input("Reservation code: ")
        try:
            cur.execute("EXECUTE QueryReservationExistsByCode (%s);", (code,))
            if cur.fetchone() is None:
                print("No reservation exists.")
                return
            cur.execute("EXECUTE DeleteReservation (%s);", (code,))
            conn.commit()
            print("Reservation deleted.")
        except:
            conn.rollback()
            print("Reservation could not be deleted.")


if __name__ == "__main__":
    with db_connect() as conn:
        op = 0
        while op != 4:
            menu()
            op = int(input('? '))
            if op == 1:
                list_op(conn)
            elif op == 2:
                reserve_op(conn)
            elif op == 3:
                delete_op(conn)
