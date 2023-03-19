-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Lena Hamilton
-- Description: SQL for the In-N-Out Store

DROP DATABASE innout;

CREATE DATABASE innout;

\c innout

-- TODO: table create statements
CREATE TABLE Customers (
    id_num SERIAL PRIMARY key,
    name VARCHAR(30) NOT NULL,
    gender CHAR(1) NOT NULL
);

CREATE TABLE Items (
    code CHAR(10) PRIMARY KEY,
    description VARCHAR(100) NOT NULL,
    price NUMERIC(5, 2) NOT NULL,
    category_code CHAR(3) REFERENCES category(code),
    current_price NUMERIC(5, 2) NOT NULL
);

CREATE TABLE Categories (
    code CHAR(3) PRIMARY KEY,
    description TEXT NOT NULL
);

CREATE TABLE Sales (
    customer_id_num NUMERIC REFERENCES Customers(id_num),
    item_code CHAR(10) REFERENCES Items(code),
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    quantity INT NOT NULL,
    sale_price NUMERIC(5, 2) NOT NULL,
    PRIMARY KEY ()
);

-- TODO: table insert statements
INSERT INTO Customers (name, gender) VALUES (
    ('Luke Skywalker',      'M'),
    ('Princess Leia',       'F'),
    ('Anakin Skywalker',    'M'),
    ('Obi Wan Kenobi',      'M'),
    ('Emperor Palpatine',   'M'),
    ('Darth Vader',         'M'),
    ('Lando Calrissian',    'M'),
    ('Boba Fett',           'M'),	
    ('C-3PO',               '?'),	
    ('R2 D2',               '?'),	
    ('Jar Jar Binks',       '?'),	
    ('Padme Amidala',       'F'),
    ('Yoda',                'M')
);

INSERT INTO Items (code, description, price, category_code, current_price) VALUES (
    ('2ltrck',      '2 Liter Coke',     1.99,   'BVR',  1.99),
    ('lrgcff',      'Large Coffee',     0.99,   'BVR',  0.99)
    ('1gllnmlk',    '1 Gallon Milk',    3.99,   'DRY',  3.99),
    ('chddrchs',    'Cheddar Cheese',   4.99,   'DRY',  4.99),
    ('prslpzza',    'Personal Pizza',   3.99,   'FRZ',  3.99),
    ('chctc',       'Choco Taco',       1.99,   'FRZ',  1.99),
    ('wndrbrd',     'Wonder Bread',     2.99,   'BKY',  2.99),
    ('vnlcnchs',    'Vanilla Conchas',  0.99,   'BKY',  0.99),
    ('blgn',        'Bologna',          2.99,   'MEA',  2.99),
    ('hnyhm',       'Honey Ham',        3.99,   'MEA',  3.99),
    ('srptchkds',   'Sour Patch Kids',  1.99,   'CAN',  1.99),
    ('twx',         'Twix',             1.99,   'CAN',  1.99),
    ('fnyns',       'Funyuns',          1.99,   'SNK',  1.99),
    ('chzt',        'Cheez It',         2.99,   'SNK',  2.99),
    ('fxflt',       'Fix-a-Flat',       12.99,  '',     12.99)
);

INSERT INTO Categories (code, description) VALUES (
    ('BVR', 'Beverages'),
    ('DRY', 'Dairy'),
    ('PRD', 'Produce'),
    ('FRZ', 'Frozen'),
    ('BKY', 'Bakery'),
    ('MEA', 'Meat'),
    ('CAN', 'Candy'),
    ('SNK', 'Snacks')
);

INSERT INTO Sales (customer_id_num, item_code, sale_date, sale_time, quantity, sale_price) VALUES (
    (1,     'BRO',  )
)

-- TODO: SQL queries

-- a) all customer names in alphabetical order

-- b) number of items (labeled as total_items) in the database 

-- c) number of customers (labeled as number_customers) by gender

-- d) a list of all item codes (labeled as code) and descriptions (labeled as description) followed by their category descriptions (labeled as category) in numerical order of their codes (items that do not have a category should not be displayed)

-- e) a list of all item codes (labeled as code) and descriptions (labeled as description) in numerical order of their codes for the items that do not have a category

-- f) a list of the category descriptions (labeled as category) that do not have an item in alphabetical order

-- g) set a variable named "ID" and assign a valid customer id to it; then show the content of the variable using a select statement

-- h) a list describing all items purchased by the customer identified by the variable "ID" (you must used the variable), showing, the date of the purchase (labeled as date), the time of the purchase (labeled as time and in hh:mm:ss format), the item's description (labeled as item), the quantity purchased (labeled as qtt), the item price (labeled as price), and the total amount paid (labeled as total_paid).

-- i) the total amount of sales per day showing the date and the total amount paid in chronological order

-- j) the description of the top item (labeled as item) in sales with the total sales amount (labeled as total_paid)

-- k) the descriptions of the top 3 items (labeled as item) in number of times they were purchased, showing that quantity as well (labeled as total)

-- l) the name of the customers who never made a purchase 