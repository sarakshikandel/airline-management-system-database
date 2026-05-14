/*
-- CS4400: Introduction to Database Systems (Spring 2025)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 3, 2025 @ 17:00 EST

-- Team 199
-- Tina Chen (tchen609)
-- Sarakshi Kandel (skandel6)
-- Diego Ruiz (druiz35)
*/

SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET GLOBAL SQL_MODE = 'ANSI,TRADITIONAL';
SET NAMES utf8mb4;
SET SQL_SAFE_UPDATES = 0;

SET @thisDatabase = 'airline_management';
DROP DATABASE IF EXISTS airline_management;
CREATE DATABASE IF NOT EXISTS airline_management;
USE airline_management;

-- Define the database structures

DROP TABLE IF EXISTS Airline;
CREATE TABLE Airline (
    airlineID VARCHAR(50) PRIMARY KEY, 
    revenue DECIMAL(15,2) NOT NULL CHECK (revenue > 0)
);

DROP TABLE IF EXISTS Location;
CREATE TABLE Location (
    locID VARCHAR(50) PRIMARY KEY 
);

DROP TABLE IF EXISTS Person;
CREATE TABLE Person (
    personID VARCHAR(50) PRIMARY KEY, 
    occupies VARCHAR(50) NOT NULL, 
    first VARCHAR(100) NOT NULL,
    last VARCHAR(100),
    FOREIGN KEY (occupies) REFERENCES Location(locID)
        ON DELETE RESTRICT	# noted
        ON UPDATE CASCADE	# noted
);

DROP TABLE IF EXISTS Route;
CREATE TABLE Route (
    routeID VARCHAR(50) PRIMARY KEY 
);

DROP TABLE IF EXISTS Flight;
CREATE TABLE Flight (
    flightID VARCHAR(50) PRIMARY KEY, 
    cost INT NOT NULL CHECK (cost > 0), 
    follows VARCHAR(50) NOT NULL, 
    FOREIGN KEY (follows) REFERENCES Route(routeID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Airport;
CREATE TABLE Airport (
    airportID VARCHAR(3) PRIMARY KEY, 
    locID VARCHAR(50) UNIQUE, 
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(3) NOT NULL,
    FOREIGN KEY (locID) REFERENCES Location(locID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Leg;
CREATE TABLE Leg (
    legID VARCHAR(50) PRIMARY KEY,
    departure VARCHAR(3) NOT NULL,
    arrival VARCHAR(3) NOT NULL,
    distance INT NOT NULL CHECK (distance > 0), 
    FOREIGN KEY (departure) REFERENCES Airport(airportID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (arrival) REFERENCES Airport(airportID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Airplane;
CREATE TABLE Airplane (
    tail_num VARCHAR(10),
    owner VARCHAR(50) NOT NULL,
    supports VARCHAR(50),
    locID VARCHAR(50),
    speed INT NOT NULL CHECK (speed > 0), 
    seat_cap INT NOT NULL CHECK (seat_cap > 0), 
    PRIMARY KEY(tail_num, owner),
    FOREIGN KEY (owner) REFERENCES Airline(airlineID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (locID) REFERENCES Location(locID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (supports) REFERENCES Flight(flightID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Pilot;
CREATE TABLE Pilot (
    taxID VARCHAR(11) NOT NULL,
    personID VARCHAR(50) NOT NULL,
    commands VARCHAR(50),
    experience INT CHECK (experience >= 0), 
    PRIMARY KEY (taxID),
    FOREIGN KEY (personID) REFERENCES Person(personID)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY (commands) REFERENCES Flight(flightID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Passenger;
CREATE TABLE Passenger (
    personID VARCHAR(50),
    funds INT CHECK (funds >= 0), 
    miles INT CHECK (miles >= 0), 
    PRIMARY KEY(personID),
    FOREIGN KEY (personID) REFERENCES Person(personID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Boeing;
CREATE TABLE Boeing (
    tail_num VARCHAR(10) NOT NULL, 
    owner VARCHAR(50) NOT NULL, 
    model DECIMAL(3,0) NOT NULL, 
    maintained BOOLEAN NOT NULL, 
    PRIMARY KEY (tail_num, owner), 
    FOREIGN KEY (tail_num, owner) REFERENCES Airplane(tail_num, owner)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Airbus;
CREATE TABLE Airbus (
    tail_num VARCHAR(10) NOT NULL, 
    owner VARCHAR(50) NOT NULL, 
    isNeoVariant BOOLEAN NOT NULL,
    PRIMARY KEY (tail_num, owner),
    FOREIGN KEY (tail_num, owner) REFERENCES Airplane(tail_num, owner)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Contains;
CREATE TABLE Contains (
    sequence INT NOT NULL CHECK (sequence >= 0),
    routeID VARCHAR(50) NOT NULL,
    legID VARCHAR(50) NOT NULL,
    PRIMARY KEY (sequence, routeID, legID),
    FOREIGN KEY (routeID) REFERENCES Route(routeID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (legID) REFERENCES Leg(legID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS License;
CREATE TABLE License (
    license_type VARCHAR(50) NOT NULL,
    taxID VARCHAR(11),
    PRIMARY KEY (taxID, license_type),
    FOREIGN KEY (taxID) REFERENCES Pilot(taxID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Vactaion;
CREATE TABLE Vacation (
    location VARCHAR(3) NOT NULL,
    personID VARCHAR(50),
    destination VARCHAR(100) NOT NULL,
    sequence INT NOT NULL CHECK (sequence >= 0), 
    PRIMARY KEY (location, personID),
    FOREIGN KEY (location) REFERENCES Airport(airportID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (personID) REFERENCES Passenger(personID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Airline (airlineID, revenue) VALUES
('Delta', 53000),
('United', 48000),
('British Airways', 24000),
('Lufthansa', 35000),
('Air_France', 29000),
('KLM', 29000),
('Ryanair', 10000),
('Japan Airlines', 9000),
('China Southern Airlines', 14000),
('Korean Air Lines', 10000),
('American', 52000);

INSERT INTO Route (routeID) VALUES
('americas_one'),
('americas_three'),
('americas_two'),
('euro_north'),
('euro_south'),
('big_europe_loop'),
('pacific_rim_tour'),
('germany_local'),
('south_euro_loop'),
('americas_hub_exchange'),
('texas_local'),
('korea_direct');

INSERT INTO LOCATION VALUES 
('plane_1'),  
('plane_2'),  
('plane_3'),  
('plane_4'),  
('plane_5'),  
('plane_6'),  
('plane_7'),  
('plane_8'),
('plane_10'),  
('plane_13'),  
('plane_18'),  
('plane_20'),  
('port_1'),  
('port_2'),  
('port_3'),  
('port_4'),  
('port_6'),  
('port_7'),  
('port_10'),  
('port_11'),  
('port_12'),  
('port_13'),  
('port_14'),  
('port_15'),  
('port_16'),  
('port_17'),  
('port_18'),  
('port_20'),  
('port_21'),  
('port_22'),  
('port_23'),  
('port_24'),  
('port_25');

INSERT INTO FLIGHT (flightID, follows, cost) VALUES 
('dl_10', 'americas_one', 200),
('un_38', 'americas_three', 200),
('ba_61', 'americas_two', 200),
('lf_20', 'euro_north', 300),
('km_16', 'euro_south', 400),
('ba_51', 'big_europe_loop', 100),
('ja_35', 'pacific_rim_tour', 300),
('ry_34', 'germany_local', 100),
('aa_12', 'americas_hub_exchange', 150),
('dl_42', 'texas_local', 220),
('ke_64', 'korea_direct', 500),
('lf_67', 'euro_north', 900);

INSERT INTO PERSON VALUES 
('p1', 'port_1', 'Jeanne', 'Nelson'),
('p2', 'port_1', 'Roxanne', 'Byrd'),
('p3', 'port_1', 'Tanya', 'Nguyen'),
('p4', 'port_1', 'Kendra', 'Jacobs'),
('p5', 'port_1', 'Jeff', 'Burton'),
('p6', 'port_1', 'Randal', 'Parks'),
('p7', 'port_2', 'Sonya', 'Owens'),
('p8', 'port_2', 'Bennie', 'Palmer'),
('p9', 'port_3', 'Marlene', 'Warner'),
('p10', 'port_3', 'Lawrence', 'Morgan'),
('p11', 'port_3', 'Sandra', 'Cruz'),
('p12', 'port_3', 'Dan', 'Ball'),
('p13', 'port_3', 'Bryant', 'Figueroa'),
('p14', 'port_3', 'Dana', 'Perry'),
('p15', 'port_10', 'Matt', 'Hunt'),
('p16', 'port_10', 'Edna', 'Brown'),
('p17', 'port_3', 'Ruby', 'Burgess'),
('p18', 'port_10', 'Esther', 'Pittman'),
('p19', 'port_17', 'Doug', 'Fowler'),
('p20', 'port_17', 'Thomas', 'Olson'),
('p21', 'plane_1', 'Mona', 'Harrison'),
('p22', 'plane_1', 'Arlene', 'Massey'),
('p23', 'plane_1', 'Judith', 'Patrick'),
('p24', 'plane_5', 'Reginald', 'Rhodes'),
('p25', 'plane_5', 'Vincent', 'Garcia'),
('p26', 'plane_5', 'Cheryl', 'Moore'),
('p27', 'plane_8', 'Michael', 'Rivera'),
('p28', 'plane_8', 'Luther', 'Matthews'),
('p29', 'plane_13', 'Moses', 'Parks'),
('p30', 'plane_13', 'Ora', 'Steele'),
('p31', 'plane_13', 'Antonio', 'Flores'),
('p32', 'plane_13', 'Glenn', 'Ross'),
('p33', 'plane_20', 'Irma', 'Thomas'),
('p34', 'plane_20', 'Ann', 'Maldonado'),
('p35', 'port_12', 'Jeffrey', 'Cruz'),
('p36', 'port_12', 'Sonya', 'Price'),
('p37', 'port_12', 'Tracy', 'Hale'),
('p38', 'port_14', 'Albert', 'Simmons'),
('p39', 'port_15', 'Karen', 'Terry'),
('p40', 'port_20', 'Glen', 'Kelley'),
('p41', 'port_3', 'Brooke', 'Little'),
('p42', 'port_4', 'Daryl', 'Nguyen'),
('p43', 'port_14', 'Judy', 'Willis'),
('p44', 'port_15', 'Marco', 'Klein'),
('p45', 'port_16', 'Angelica', 'Hampton'),
('p46', 'plane_10', 'Janice', 'White');

INSERT INTO AIRPORT VALUES 
('ATL', 'port_1', 'Atlanta Hartsfield_Jackson International', 'Atlanta', 'Georgia', 'USA'),  
('DXB', 'port_2', 'Dubai International', 'Dubai', 'Al Garhoud', 'UAE'),  
('HND', 'port_3', 'Tokyo International Haneda', 'Ota City', 'Tokyo', 'JPN'),  
('LHR', 'port_4', 'London Heathrow', 'London', 'England', 'GBR'),  
('IST', NULL, 'Istanbul International', 'Arnavutkoy', 'Istanbul', 'TUR'),  
('DFW', 'port_6', 'Dallas_Fort Worth International', 'Dallas', 'Texas', 'USA'),  
('CAN', 'port_7', 'Guangzhou International', 'Guangzhou', 'Guangdong', 'CHN'),  
('DEN', NULL, 'Denver International', 'Denver', 'Colorado', 'USA'),  
('LAX', NULL, 'Los Angeles International', 'Los Angeles', 'California', 'USA'),  
('ORD', 'port_10', 'O_Hare International', 'Chicago', 'Illinois', 'USA'),  
('AMS', 'port_11', 'Amsterdam Schipol International', 'Amsterdam', 'Haarlemmermeer', 'NLD'),  
('CDG', 'port_12', 'Paris Charles de Gaulle', 'Roissy_en_France', 'Paris', 'FRA'),  
('FRA', 'port_13', 'Frankfurt International', 'Frankfurt', 'Frankfurt_Rhine_Main', 'DEU'),  
('MAD', 'port_14', 'Madrid Adolfo Suarez_Barajas', 'Madrid', 'Barajas', 'ESP'),  
('BCN', 'port_15', 'Barcelona International', 'Barcelona', 'Catalonia', 'ESP'),  
('FCO', 'port_16', 'Rome Fiumicino', 'Fiumicino', 'Lazio', 'ITA'),  
('LGW', 'port_17', 'London Gatwick', 'London', 'England', 'GBR'),  
('MUC', 'port_18', 'Munich International', 'Munich', 'Bavaria', 'DEU'),  
('MDW', NULL, 'Chicago Midway International', 'Chicago', 'Illinois', 'USA'),  
('IAH', 'port_20', 'George Bush Intercontinental', 'Houston', 'Texas', 'USA'),  
('HOU', 'port_21', 'William P_Hobby International', 'Houston', 'Texas', 'USA'),  
('NRT', 'port_22', 'Narita International', 'Narita', 'Chiba', 'JPN'),  
('BER', 'port_23', 'Berlin Brandenburg Willy Brandt International', 'Berlin', 'Schonefeld', 'DEU'),  
('ICN', 'port_24', 'Incheon International Airport', 'Seoul', 'Jung_gu', 'KOR'),  
('PVG', 'port_25', 'Shanghai Pudong International Airport', 'Shanghai', 'Pudong', 'CHN');  

INSERT INTO LEG VALUES 
('leg_1', 'AMS', 'BER', 400),
('leg_2', 'ATL', 'AMS', 3900),
('leg_3', 'ATL', 'LHR', 3700),
('leg_4', 'ATL', 'ORD', 600),
('leg_5', 'BCN', 'CDG', 500),
('leg_6', 'BCN', 'MAD', 300),
('leg_7', 'BER', 'CAN', 4700),
('leg_8', 'BER', 'LGW', 600),
('leg_9', 'BER', 'MUC', 300),
('leg_10', 'CAN', 'HND', 1600),
('leg_11', 'CDG', 'BCN', 500),
('leg_12', 'CDG', 'FCO', 600),
('leg_13', 'CDG', 'LHR', 200),
('leg_14', 'CDG', 'MUC', 400),
('leg_15', 'DFW', 'IAH', 200),
('leg_16', 'FCO', 'MAD', 800),
('leg_17', 'FRA', 'BER', 300),
('leg_18', 'HND', 'NRT', 100),
('leg_19', 'HOU', 'DFW', 300),
('leg_20', 'IAH', 'HOU', 100),
('leg_21', 'LGW', 'BER', 600),
('leg_22', 'LHR', 'BER', 600),
('leg_23', 'LHR', 'MUC', 500),
('leg_24', 'MAD', 'BCN', 300),
('leg_25', 'MAD', 'CDG', 600),
('leg_26', 'MAD', 'FCO', 800),
('leg_27', 'MUC', 'BER', 300),
('leg_28', 'MUC', 'CDG', 400),
('leg_29', 'MUC', 'FCO', 400),
('leg_30', 'MUC', 'FRA', 200),
('leg_31', 'ORD', 'CDG', 3700),
('leg_32', 'DFW', 'ICN', 6800);

INSERT INTO AIRPLANE (tail_num, owner, supports, locID, speed, seat_cap) VALUES 
('n106js', 'Delta', 'dl_10', 'plane_1', 800, 4),  
('n110jn', 'Delta', 'un_38', 'plane_3', 800, 5),  
('n127js', 'Delta', NULL, NULL, 600, 4),  
('n330ss', 'United', NULL, NULL, 800, 4),  
('n380sd', 'United', 'ba_61', 'plane_5', 400, 5),  
('n616lt', 'British Airways', 'lf_20', 'plane_6', 600, 7),  
('n517ly', 'British Airways', 'km_16', 'plane_7', 600, 4),  
('n620la', 'Lufthansa', 'ba_51', 'plane_8', 800, 4),  
('n401fj', 'Lufthansa', NULL, NULL, 300, 4),  
('n653fk', 'Lufthansa', 'ja_35', 'plane_10', 600, 6),  
('n118fm', 'Air_France', NULL, NULL, 400, 4),  
('n815pw', 'Air_France', NULL, NULL, 400, 3),  
('n161fk', 'KLM', 'ry_34', 'plane_13', 600, 4),  
('n337as', 'KLM', NULL, NULL, 400, 5),  
('n256ap', 'KLM', NULL, NULL, 300, 4),  
('n156sq', 'Ryanair', NULL, NULL, 600, 8),  
('n451fi', 'Ryanair', NULL, NULL, 600, 5),  
('n341eb', 'Ryanair', 'aa_12', 'plane_18', 400, 4),  
('n353kz', 'Ryanair', NULL, NULL, 400, 4),  
('n305fv', 'Japan Airlines', 'dl_42', 'plane_20', 400, 6),  
('n443wu', 'Japan Airlines', NULL, NULL, 800, 4),  
('n454gq', 'China Southern Airlines', NULL, NULL, 400, 3),  
('n249yk', 'China Southern Airlines', NULL, NULL, 400, 4),  
('n180co', 'Korean Air Lines', 'ke_64', 'plane_4', 600, 5),  
('n448cs', 'American', NULL, NULL, 400, 4),  
('n225sb', 'American', NULL, NULL, 800, 8),  
('n553qn', 'American', 'lf_67', 'plane_2', 800, 5);

INSERT INTO PILOT VALUES 
('330-12-6907', 'p1', 'dl_10', 31),
('842-88-1257', 'p2', 'dl_10', 9),
('750-24-7616', 'p3', 'un_38', 11),
('776-21-8098', 'p4', 'un_38', 24),
('933-93-2165', 'p5', 'ba_61', 27),
('707-84-4555', 'p6', 'ba_61', 38),
('450-25-5617', 'p7', 'lf_20', 13),
('701-38-2179', 'p8', 'ry_34', 12),
('936-44-6941', 'p9', 'lf_20', 13),
('769-60-1266', 'p10', 'lf_20', 15),
('369-22-9505', 'p11', 'km_16', 22),
('680-92-5329', 'p12', 'ry_34', 24),
('513-40-4168', 'p13', 'km_16', 24),
('454-71-7847', 'p14', 'km_16', 13),
('153-47-8101', 'p15', 'ja_35', 30),
('598-47-5172', 'p16', 'ja_35', 28),
('865-71-6800', 'p17', 'dl_42', 36),
('250-86-2784', 'p18', 'lf_67', 23),
('386-39-7881', 'p19', NULL, 2),
('522-44-3098', 'p20', NULL, 28);

INSERT INTO PASSENGER VALUES 
('p21', 700, 771),
('p22', 200, 374),
('p23', 400, 414),
('p24', 500, 292),
('p25', 300, 390),
('p26', 600, 302),
('p27', 400, 470),
('p28', 400, 208),
('p29', 700, 292),
('p30', 500, 686),
('p31', 400, 547),
('p32', 500, 257),
('p33', 600, 564),
('p34', 200, 211),
('p35', 500, 233),
('p36', 400, 293),
('p37', 700, 552),
('p38', 700, 812),
('p39', 400, 541),
('p40', 700, 441),
('p41', 300, 875),
('p42', 500, 691),
('p43', 300, 572),
('p44', 500, 572),
('p45', 500, 663),
('p46', 5000, 690);

INSERT INTO AIRBUS (tail_num, owner, isNeoVariant) VALUES
('n106js', 'Delta', FALSE),
('n110jn', 'Delta', FALSE),
('n127js', 'Delta', TRUE),
('n330ss', 'United', FALSE),
('n380sd', 'United', FALSE),
('n616lt', 'British Airways', FALSE),
('n517ly', 'British Airways', FALSE),
('n620la', 'Lufthansa', FALSE),
('n653fk', 'Lufthansa', TRUE),
('n815pw', 'Air_France', FALSE),
('n161fk', 'KLM', FALSE),
('n337as', 'KLM', TRUE),
('n156sq', 'Ryanair', FALSE),
('n451fi', 'Ryanair', FALSE),
('n305fv', 'Japan Airlines', TRUE),
('n443wu', 'Japan Airlines', FALSE),
('n180co', 'Korean Air Lines', TRUE),
('n225sb', 'American', FALSE),
('n553qn', 'American', FALSE);

INSERT INTO BOEING VALUES
('n118fm', 'Air_France', 777, FALSE),
('n256ap', 'KLM', 737, FALSE),
('n341eb', 'Ryanair', 737, TRUE),
('n353kz', 'Ryanair', 737, TRUE),
('n249yk', 'China Southern Airlines', 787, FALSE),
('n448cs', 'American', 787, TRUE);

INSERT INTO License (taxID, license_type) VALUES
-- taxID 153-47-8101
('153-47-8101', 'airbus'),
('153-47-8101', 'boeing'),
('153-47-8101', 'general'),

-- taxID 250-86-2784
('250-86-2784', 'airbus'),

-- taxID 330-12-6907
('330-12-6907', 'airbus'),

-- taxID 369-22-9505
('369-22-9505', 'airbus'),
('369-22-9505', 'boeing'),

-- taxID 386-39-7881
('386-39-7881', 'airbus'),

-- taxID 450-25-5617
('450-25-5617', 'airbus'),

-- taxID 454-71-7847
('454-71-7847', 'airbus'),

-- taxID 513-40-4168
('513-40-4168', 'airbus'),

-- taxID 522-44-3098
('522-44-3098', 'airbus'),

-- taxID 598-47-5172
('598-47-5172', 'airbus'),

-- taxID 680-92-5329
('680-92-5329', 'boeing'),

-- taxID 701-38-2179
('701-38-2179', 'boeing'),

-- taxID 707-84-4555
('707-84-4555', 'airbus'),
('707-84-4555', 'boeing'),

-- taxID 750-24-7616
('750-24-7616', 'airbus'),

-- taxID 769-60-1266
('769-60-1266', 'airbus'),

-- taxID 776-21-8098
('776-21-8098', 'airbus'),
('776-21-8098', 'boeing'),

-- taxID 842-88-1257
('842-88-1257', 'airbus'),
('842-88-1257', 'boeing'),

-- taxID 865-71-6800
('865-71-6800', 'airbus'),
('865-71-6800', 'boeing'),

-- taxID 933-93-2165
('933-93-2165', 'airbus'),

-- taxID 936-44-6941
('936-44-6941', 'airbus'),
('936-44-6941', 'boeing'),
('936-44-6941', 'general');


INSERT INTO Vacation (location, personID, destination, sequence) VALUES
-- Data for personID p21
('AMS', 'p21', 'AMS', 0),

-- Data for personID p22
('AMS', 'p22', 'AMS', 0),

-- Data for personID p23
('BER', 'p23', 'BER', 0),

-- Data for personID p24
('MUC', 'p24', 'MUC', 0),
('CDG', 'p24', 'CDG', 1),

-- Data for personID p25
('MUC', 'p25', 'MUC', 0),

-- Data for personID p26
('MUC', 'p26', 'MUC', 0),

-- Data for personID p27
('BER', 'p27', 'BER', 0),

-- Data for personID p28
('LGW', 'p28', 'LGW', 0),

-- Data for personID p29
('FCO', 'p29', 'FCO', 0),
('LHR', 'p29', 'LHR', 1),

-- Data for personID p30
('FCO', 'p30', 'FCO', 0),
('MAD', 'p30', 'MAD', 1),

-- Data for personID p31
('FCO', 'p31', 'FCO', 0),

-- Data for personID p32
('FCO', 'p32', 'FCO', 0),

-- Data for personID p33
('CAN', 'p33', 'CAN', 0),

-- Data for personID p34
('HND', 'p34', 'HND', 0),

-- Data for personID p35
('LGW', 'p35', 'LGW', 0),

-- Data for personID p36
('FCO', 'p36', 'FCO', 0),

-- Data for personID p37
('FCO', 'p37', 'FCO', 0),
('LGW', 'p37', 'LGW', 1),
('CDG', 'p37', 'CDG', 2),

-- Data for personID p38
('MUC', 'p38', 'MUC', 0),

-- Data for personID p39
('MUC', 'p39', 'MUC', 0),

-- Data for personID p40
('HND', 'p40', 'HND', 0),

-- Data for personID p46
('LGW', 'p46', 'LGW', 0);


INSERT INTO Contains (sequence, routeID, legID) VALUES
-- americas_hub_exchange
(0, 'americas_hub_exchange', 'leg_4'),

-- americas_one
(0, 'americas_one', 'leg_2'),
(1, 'americas_one', 'leg_1'),

-- americas_three
(0, 'americas_three', 'leg_31'),
(1, 'americas_three', 'leg_14'),

-- americas_two
(0, 'americas_two', 'leg_3'),
(1, 'americas_two', 'leg_22'),

-- big_europe_loop
(0, 'big_europe_loop', 'leg_23'),
(1, 'big_europe_loop', 'leg_29'),
(2, 'big_europe_loop', 'leg_16'),
(3, 'big_europe_loop', 'leg_25'),
(4, 'big_europe_loop', 'leg_13'),

-- euro_north
(0, 'euro_north', 'leg_16'),
(1, 'euro_north', 'leg_24'),
(2, 'euro_north', 'leg_5'),
(3, 'euro_north', 'leg_14'),
(4, 'euro_north', 'leg_27'),
(5, 'euro_north', 'leg_8'),

-- euro_south
(0, 'euro_south', 'leg_21'),
(1, 'euro_south', 'leg_9'),
(2, 'euro_south', 'leg_28'),
(3, 'euro_south', 'leg_11'),
(4, 'euro_south', 'leg_6'),
(5, 'euro_south', 'leg_26'),

-- germany_local
(0, 'germany_local', 'leg_9'),
(1, 'germany_local', 'leg_30'),
(2, 'germany_local', 'leg_17'),

-- pacific_rim_tour
(0, 'pacific_rim_tour', 'leg_7'),
(1, 'pacific_rim_tour', 'leg_10'),
(2, 'pacific_rim_tour', 'leg_18'),

-- south_euro_loop
(0, 'south_euro_loop', 'leg_16'),
(1, 'south_euro_loop', 'leg_24'),
(2, 'south_euro_loop', 'leg_5'),
(3, 'south_euro_loop', 'leg_12'),

-- texas_local
(0, 'texas_local', 'leg_15'),
(1, 'texas_local', 'leg_20'),
(2, 'texas_local', 'leg_19'),

-- korea_direct
(0, 'korea_direct', 'leg_32');