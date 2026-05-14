-- CS4400: Introduction to Database Systems: Monday, March 3, 2025
-- Simple Airline Management System Course Project Mechanics [TEMPLATE] (v0)
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'flight_tracking';
use flight_tracking;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [_] supporting functions, views and stored procedures
-- -----------------------------------------------------------------------------
/* Helpful library capabilities to simplify the implementation of the required
views and procedures. */
-- -----------------------------------------------------------------------------
drop function if exists leg_time;
delimiter //
create function leg_time (ip_distance integer, ip_speed integer)
    returns time reads sql data
begin
    declare total_time decimal(10,2);
    declare hours, minutes integer default 0;
    set total_time = ip_distance / ip_speed;
    set hours = truncate(total_time, 0);
    set minutes = truncate((total_time - hours) * 60, 0);
    return maketime(hours, minutes, 0);
end //
delimiter ;

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like the model and the engine.  
Finally, an airplane must have a new and database-wide unique location
since it will be used to carry passengers. 

• The new airplane must be sponsored by an existing airline                 ✅
• The new airplane must have a unique tail number for that airline          ✅
• It must have a non-zero seat capacity and speed                           ✅
*/
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
    in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_maintenanced boolean, in ip_model varchar(50),
    in ip_neo boolean)
sp_main: begin
    # Checking data nullity
    IF ip_airlineID IS NULL
        OR ip_tail_num IS NULL
        OR ip_seat_capacity IS NULL
        OR ip_speed IS NULL
        OR ip_locationID IS NULL THEN

--      SELECT 'NULL data prohibited for airlineID, tail_num, seat_capacity, speed, and locationID';
        LEAVE sp_main;
    END IF;
    
    # Checking data valadity
    IF ip_airlineID = ''
        OR ip_tail_num = ''
        OR ip_locationID = '' THEN

--      SELECT 'empty data prohibited for airlineID, tail_num, and locationID';
        LEAVE sp_main;
    END IF;        
    
    # Checks whether the airplane type is valid.
    IF (ip_plane_type <> 'Boeing') AND (ip_plane_type <> 'Airbus') AND (ip_plane_type IS NOT NULL) THEN
--      SELECT 'plane type must be Boeing, Airbus, or NULL.';
        LEAVE sp_main;
    END IF;
    
    # Checks whether the passed in Airline is in the DB.
    IF ip_airlineID NOT IN (SELECT airlineID FROM airline) THEN
--      SELECT 'airline passed in not in the database.';
        LEAVE sp_main;
    END IF;
    
    # Checks that the airplane is unique
    IF ip_tail_num IN (SELECT tail_num FROM airplane WHERE airlineID = ip_airlineID) THEN
--      SELECT 'duplicate airplanes prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Check that the location is unique
    IF ip_locationID IN (SELECT locationID FROM location) THEN
--      SELECT 'duplicate location_ids prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Check for positive seat capacity and speed
    IF ip_speed <= 0 OR ip_seat_capacity <= 0 THEN
--      SELECT 'non-positve airplane speeds and capacities are prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Checks Boeing attributes
    IF ip_plane_type = 'Boeing' AND 
        (ip_maintenanced IS NULL OR ip_model IS NULL OR ip_model = '') THEN
        
--      SELECT 'Boeing attributes NULL or empty.';
        LEAVE sp_main;
    END IF;
    
    # Checks Airbus attributes
    IF ip_plane_type = 'Airbus' AND ip_neo IS NULL THEN
        
--      SELECT 'Airbus neo-flag NULL.';
        LEAVE sp_main;
    END IF;
    
    # !!!!!!!!!!!!!!!! Check Boeing/Airbus extra attributes !!!!!!!!!!!!!!!!!!!!!!
    
    ################################### ADDING AIRPLANE ###################################
    
    # Validating key constraint fk3: locationID
    INSERT INTO location VALUES(ip_locationID);
    
    INSERT INTO airplane VALUES(
        ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, ip_locationID,
        ip_plane_type, ip_maintenanced, ip_model, ip_neo
    );
--     SELECT 'airplane added!';
    #######################################################################################

    
    -- Ensure that the plane type is valid: Boeing, Airbus, or neither      ✅
    -- Ensure that the type-specific attributes are accurate for the type   ✅
    -- Ensure that the airplane and location values are new and unique      ✅
    -- Add airplane and location into respective tables                     ✅

end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a new and database-wide unique location if it will be used
to support airplane takeoffs and landings.  An airport may have a longer, more
descriptive name.  An airport must also have a city, state, and country designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state varchar(100), in ip_country char(3), in ip_locationID varchar(50))
sp_main: begin

    -- Ensure that the airport and location values are new and unique
    -- Add airport and location into respective tables
    
    IF ip_airportID IS NULL OR ip_airport_name IS NULL OR ip_city IS NULL 
    OR ip_state IS NULL OR ip_country IS NULL THEN
		LEAVE sp_main;
	END IF;
    
    IF ip_airportID = '' OR ip_airport_name = '' OR ip_city = '' 
    OR ip_state = '' OR ip_country = '' OR ip_locationID = '' THEN
		LEAVE sp_main;
	END IF;
    
    IF ip_airportID IN (SELECT airportID FROM airport) OR
       ip_locationID IN (SELECT locationID FROM location) OR
       ip_city IS NULL OR ip_state IS NULL OR ip_country IS NULL 
       OR ip_airportID = '' OR ip_airport_name = '' OR ip_city = ''
       OR ip_state = '' OR ip_country = '' OR ip_locationID = '' THEN
    LEAVE sp_main;
    END IF;

    INSERT INTO location VALUES(ip_locationID);
    INSERT INTO airport (airportID, airport_name, city, state, country, locationID) VALUES
                        (ip_airportID, ip_airport_name, ip_city, ip_state, ip_country, ip_locationID);
end //
delimiter ;


-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person must have a first name, and might also have a last name.

A person can hold a pilot role or a passenger role (exclusively).  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  As a
passenger, a person will have some amount of frequent flyer miles, along with a
certain amount of funds needed to purchase tickets for flights. 

• The new person has a unique identifier                                    ✅
• They are located in an existent location within the system                ✅   
• They have a first name                                                    ✅
*/
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_miles integer, in ip_funds integer)
sp_main: begin

    # Checks for nullity
    IF ip_personID IS NULL OR ip_locationID IS NULL THEN
--      SELECT 'NULL personID and locationID prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Checks for empty data
    IF ip_personID = '' OR ip_locationID = '' OR ip_last_name = '' OR ip_taxID = '' THEN
--      SELECT 'empty personID, locationID, last name, and taxID prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Checks for data that cannot be negative
    IF ip_experience < 0 OR ip_miles < 0 OR ip_funds < 0 THEN
--      SELECT 'negative exp., miles, and funds are prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Checks whether personID is unique
    IF ip_personID IN (SELECT personID FROM person) THEN
--      SELECT 'personID must be unique.';
        LEAVE sp_main;
    END IF;
    
    # Checks for first name
    IF ip_first_name IS NULL OR ip_first_name = '' THEN
--      SELECT 'NULL or empty first name prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Checks location validity
    IF ip_locationID NOT IN (SELECT locationID FROM location) THEN
--      SELECT 'locationID not in the DB.';
        LEAVE sp_main;
    END IF;
    
    # Checks the person is either a pilot or passenger
    IF (ip_taxID IS NULL OR ip_experience IS NULL) AND (ip_miles IS NULL OR ip_funds IS NULL) THEN
--      SELECT 'every person must be either a passenger or a pilot';
        LEAVE sp_main;
    END IF;

    # Checks for a person having all attributes
    IF ip_taxID IS NOT NULL AND ip_experience IS NOT NULL AND ip_miles IS NOT NULL AND ip_funds IS NOT NULL THEN
--      SELECT 'person with all attributes prohibited';
        LEAVE sp_main;
    END IF;
    
    # Checks that a passenger has no pilot attributes
    IF (ip_miles IS NOT NULL AND ip_funds IS NOT NULL) AND (ip_taxID IS NOT NULL OR ip_experience IS NOT NULL) THEN
--      SELECT 'passengers cannot have pilot attributes';
        LEAVE sp_main;
    END IF;
        
    # Checks that a pilot has no passenger attributes
    IF (ip_taxID IS NOT NULL AND ip_experience IS NOT NULL) AND (ip_miles IS NOT NULL OR ip_funds IS NOT NULL) THEN
--      SELECT 'passengers cannot have pilot attributes';
        LEAVE sp_main;
    END IF;
    
    #################################### ADDING PERSON ####################################

    # Must create person before creating person's type
    INSERT INTO person VALUES (
        ip_personID, ip_first_name, ip_last_name, ip_locationID
    );
    
    # Filling the person's type table
    IF ip_taxID IS NOT NULL AND ip_experience IS NOT NULL THEN      # if (pilot)
        INSERT INTO pilot VALUES (
            ip_personID, ip_taxID, ip_experience, NULL
        );
--         SELECT 'pilot added!';
    ELSEIF ip_miles IS NOT NULL AND ip_funds IS NOT NULL THEN       # else if (passenger)
        INSERT INTO passenger VALUES (
            ip_personID, ip_miles, ip_funds
        );
--         SELECT 'passenger added!';
    END IF;
    
    #######################################################################################
    
    -- Ensure that the location is valid                                            ✅
    -- Ensure that the persion ID is unique                                         ✅
    -- Ensure that the person is a pilot or passenger                               ✅
    -- Add them to the person table as well as the table of their respective role

end //
delimiter ;

-- [4] grant_or_revoke_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure inverts the status of a pilot license.  If the license
doesn't exist, it must be created; and, if it already exists, then it must be removed. */
-- -----------------------------------------------------------------------------
drop procedure if exists grant_or_revoke_pilot_license;
delimiter //
create procedure grant_or_revoke_pilot_license (in ip_personID varchar(50), in ip_license varchar(100))
sp_main: begin

    -- Ensure that the person is a valid pilot
    -- If license exists, delete it, otherwise add the license
    
    # if person is a valid pilot
    IF ip_personID NOT IN (SELECT personID FROM pilot) THEN 
        LEAVE sp_main;
    END IF; 
        
    # if the license exists, delete it 
    IF ip_license IN (SELECT license FROM pilot_licenses) THEN
        DELETE FROM pilot_licenses WHERE personID = ip_personID and license = ip_license;
       LEAVE sp_main;
    END IF;
    
    # insert new pilot license
    INSERT INTO pilot_licenses (personID, license) VALUES
        (ip_personID, ip_license);

end //
delimiter ;


-- [5] offer_flight()
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (
    in ip_flightID varchar(50),
    in ip_routeID varchar(50),
    in ip_support_airline varchar(50),
    in ip_support_tail varchar(50),
    in ip_progress integer,
    in ip_next_time time,
    in ip_cost integer
)
sp_main: begin

	IF ip_flightID IS NULL OR ip_routeID IS NULL OR ip_support_airline IS NULL
		OR ip_support_airline IS NULL OR ip_support_tail IS NULL OR ip_progress IS NULL
        OR ip_next_time IS NULL OR ip_cost IS NULL THEN
        
        LEAVE sp_main;
	END IF;
    
-- 	IF ip_flightID = '' OR ip_routeID = '' OR ip_support_airline = ''
-- 		OR ip_support_airline = '' OR ip_support_tail = '' OR ip_progress = ''
--         OR ip_next_time = '' OR ip_cost = '' THEN
--         
--         LEAVE sp_main;
-- 	END IF;
    
    -- Check that route exists
    IF ip_routeID NOT IN (SELECT routeID FROM route) THEN
        LEAVE sp_main;
    END IF;

    -- Check if airplane is specified (i.e., both airline and tail provided)
    IF ip_support_airline IS NOT NULL AND ip_support_tail IS NOT NULL THEN

        -- Airplane must exist
        IF NOT EXISTS (
            SELECT * FROM airplane
            WHERE airlineID = ip_support_airline AND tail_num = ip_support_tail
        ) THEN
            LEAVE sp_main;
        END IF;

        -- Airplane must not already be assigned to a flight
        IF EXISTS (
            SELECT * FROM flight
            WHERE support_airline = ip_support_airline AND support_tail = ip_support_tail
        ) THEN
            LEAVE sp_main;
        END IF;

    END IF;

    -- Check that ip_progress is NOT at the final leg of the route
    IF ip_progress >= (
        SELECT MAX(sequence) FROM route_path WHERE routeID = ip_routeID
    ) THEN
        LEAVE sp_main;
    END IF;

    -- All checks passed, insert new flight
    INSERT INTO flight (
        flightID, routeID, support_airline, support_tail,
        progress, next_time, cost, airplane_status
    )
    VALUES (
        ip_flightID, ip_routeID, ip_support_airline, ip_support_tail,
        ip_progress, ip_next_time, ip_cost, 'on_ground'
    );

end //
delimiter ;


-- [6] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. 

• The airplane assigned to the flight is in the air     ✅
• The flight exists                                     ✅
*/
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin

    DECLARE plane_status VARCHAR(100) DEFAULT '';
    DECLARE rtID VARCHAR(50) DEFAULT '';
    DECLARE sqn INT DEFAULT -1;
    DECLARE lgID VARCHAR(50) DEFAULT '';
    DECLARE leg_len INT DEFAULT -1;
    DECLARE airline VARCHAR(50) DEFAULT '';
    DECLARE tail_num VARCHAR(50) DEFAULT '';
    DECLARE plane_locID VARCHAR(50) DEFAULT '';
    
    # Checks data validity
    IF ip_flightID IS NULL OR ip_flightID = '' THEN
--      SELECT 'NULL or empty flightID prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Checks for flightID's existence
    IF ip_flightID NOT IN (SELECT flightID FROM flight) THEN
--      SELECT 'flightID not in DB.';
        LEAVE sp_main;
    END IF;
    
    # Sets plane_status variable equal to the flight's current status
    SELECT
        f.airplane_status
    INTO 
        plane_status
    FROM
        flight AS f
    WHERE
        f.flightID = ip_flightID;

    # Checks if variable setting malfunctioned
    IF plane_status = '' OR plane_status IS NULL THEN
--      SELECT 'plane_status assignment failed.';
        LEAVE sp_main;
    END IF;
    
    # Checks if flight is in the air
    IF plane_status <> 'in_flight' THEN
--      SELECT 'plane status must be \'in_flight\'';
        LEAVE sp_main;
    END IF;
    
    # Retrieves the routeID, sequence, airline, and tail_num for the given flight
    SELECT 
        f.routeID, f.progress, f.support_airline, f.support_tail
    INTO 
        rtID , sqn , airline , tail_num 
    FROM
        flight AS f
    WHERE
        f.flightID = ip_flightID;
    
    # Checks whether the previous retrieval was succesful
    IF rtID = '' OR sqn = -1 OR airline = '' OR tail_num = '' THEN
--      SELECT 'rtID, sqn, airline, or tail_num retrieval failed.';
        LEAVE sp_main;
    END IF;
    
    # Retrieves the legID from route_path
    SELECT rp.legID INTO lgID FROM route_path AS rp WHERE rtID = rp.routeID AND sqn = rp.sequence;
    
    # Checks whether the previous retrieval was succesful
    IF lgID = '' THEN
--      SELECT 'lgID retrieval failed.';
        LEAVE sp_main;
    END IF;
    
    # Retrieves the leg length from leg
    SELECT lg.distance INTO leg_len FROM leg AS lg WHERE lgID = lg.legID;    

    # Checks whether the previous retrieval was succesful
    IF leg_len = -1 THEN
--      SELECT 'leg_len retrieval failed.';
        LEAVE sp_main;
    END IF;
    
    # Retrieves locationID from supporting airplane
    SELECT ap.locationID INTO plane_locID FROM airplane as ap WHERE airline = ap.airlineID AND tail_num = ap.tail_num;
    
    # Checks whether the previous retrieval was succesful
    IF plane_locID = '' THEN
--      SELECT 'plane_locID retrieval failed.';
        LEAVE sp_main;
    END IF;
    
    #################################### FLIGHT LANDING ####################################
    
    # Updating flight's internal clock and status
    UPDATE flight AS f
    SET f.next_time = ADDTIME(f.next_time, '01:00:00'), f.airplane_status = 'on_ground'
    WHERE f.flightID = ip_flightID;
    
    # Increase passenger's miles
    UPDATE passenger AS pg
    SET pg.miles = pg.miles + leg_len
    WHERE pg.personID IN (
        SELECT
            prsn.personID
        FROM
            person AS prsn
        WHERE
            prsn.locationID = plane_locID
    );
    
    # Increment pilot's experience
    UPDATE pilot AS plt
    SET plt.experience = plt.experience + 1
    WHERE plt.commanding_flight = ip_flightID;
    ########################################################################################

    -- Increment the pilot's experience by 1                                        ✅   
    -- Increment the frequent flyer miles of all passengers on the plane            ✅
    -- Update the status of the flight and increment the next time to 1 hour later  ✅   
        -- Hint: use addtime()

end //
delimiter ;

-- [7] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along it's route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that Airbus and general planes have at least one pilot
assigned, while Boeing must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. 

• Boeing planes must have at least two pilots assigned                                          ✅
• All other planes must have at least one pilot assigned                                        ✅
• The flight must be delayed for 30 minutes if it cannot take off because of a pilot shortage   ✅
*/
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin

    DECLARE plane_status VARCHAR(100) DEFAULT '';
    DECLARE rtID VARCHAR(50) DEFAULT '';
    DECLARE sqn INT DEFAULT -1;
    DECLARE lgID VARCHAR(50) DEFAULT '';
    DECLARE leg_len INT DEFAULT -1;
    DECLARE airline VARCHAR(50) DEFAULT '';
    DECLARE tail_num VARCHAR(50) DEFAULT '';
    DECLARE plane_locID VARCHAR(50) DEFAULT '';
    
    DECLARE plt_count INT DEFAULT -1;
    DECLARE plane_type VARCHAR(100) DEFAULT '';
    DECLARE plane_speed INT DEFAULT -1;
    DECLARE flight_time FLOAT DEFAULT -1.0;
    
    # Checks data validity
    IF ip_flightID IS NULL OR ip_flightID = '' THEN
--      SELECT 'NULL or empty flightID prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Checks for flightID's existence
    IF ip_flightID NOT IN (SELECT flightID FROM flight) THEN
--      SELECT 'flightID not in DB.';
        LEAVE sp_main;
    END IF;

    # Retrieves the status, routeID, sequence, airline, and tail_num for the given flight
    SELECT 
        f.airplane_status, f.routeID, f.progress, f.support_airline, f.support_tail
    INTO 
        plane_status, rtID , sqn , airline , tail_num 
    FROM
        flight AS f
    WHERE
        f.flightID = ip_flightID;
    
    # Checks whether the previous retrieval was succesful
    IF rtID = '' OR sqn = -1 OR airline = '' OR tail_num = '' OR plane_status = '' OR plane_status IS NULL THEN
--      SELECT 'rtID, sqn, airline, or tail_num retrieval failed.';
        LEAVE sp_main;
    END IF;
    
    SET sqn = sqn + 1;
    
    # Checks if flight is in the air
    IF plane_status <> 'on_ground' THEN
--      SELECT 'plane status must be \'on_ground\'';
        LEAVE sp_main;
    END IF;
    
    # Checks whether there is another leg to fly
    IF sqn = (SELECT MAX(rp.sequence) FROM route_path AS rp WHERE rp.routeID = rtID) THEN
--      SELECT 'no more legs to fly to';
        LEAVE sp_main;
    END IF;

    # Retrieve pilot's assigned to this flight
    SELECT COUNT(*) INTO plt_count FROM pilot AS plt WHERE plt.commanding_flight = ip_flightID;
    
    # Checks whether the previous retrieval was succesful
    IF plt_count = -1 THEN
--      SELECT 'plt_count failed';
        LEAVE sp_main;
    END IF;
    
    # Retrieves locationID from supporting airplane
    SELECT ap.plane_type, ap.speed INTO plane_type, plane_speed FROM airplane as ap WHERE airline = ap.airlineID AND tail_num = ap.tail_num;
    
    # Checks whether the previous retrieval was succesful
    IF plane_type = '' OR plane_speed = -1 THEN
--      SELECT 'plane_type or plane_speed failed';
        LEAVE sp_main;
    END IF;
    
    # Delay plane if there is not enough pilots currently assigned
    IF (plane_type = 'Airbus' AND plt_count < 1) OR (plane_type = 'Boeing' AND plt_count < 2) THEN
        UPDATE flight AS f
        SET f.next_time = ADDTIME(f.next_time, '00:30:00')
        WHERE f.flightID = ip_flightID;
        
--         SELECT 'pilot shortage, delayed for 30-min.';
        LEAVE sp_main;
    END IF;
    
    # Retrieves the legID from route_path
    SELECT rp.legID INTO lgID FROM route_path AS rp WHERE rtID = rp.routeID AND sqn = rp.sequence;
    
    # Checks whether the previous retrieval was succesful
    IF lgID = '' THEN
--      SELECT 'lgID retrieval failed.';
        LEAVE sp_main;
    END IF;
    
    # Retrieves the leg length from leg
    SELECT lg.distance INTO leg_len FROM leg AS lg WHERE lgID = lg.legID;    

    # Checks whether the previous retrieval was succesful
    IF leg_len = -1 THEN
--      SELECT 'leg_len retrieval failed.';
        LEAVE sp_main;
    END IF;
    

    #################################### FLIGHT TAKING OFF ####################################
    # Sets flight time 
    SET flight_time = leg_len / plane_speed;

    # Increment flight progress
    UPDATE flight AS f  
    SET    f.progress = f.progress + 1,    
           f.airplane_status = 'in_flight',    
           f.next_time = ADDTIME(f.next_time , SEC_TO_TIME(flight_time * 3600))  
    WHERE f.flightID = ip_flightID;
    ###########################################################################################

    
    -- Ensure that the flight exists                                                    ✅
    -- Ensure that the flight is on the ground                                          ✅
    -- Ensure that the flight has another leg to fly                                    ✅
    -- Ensure that there are enough pilots (1 for Airbus and general, 2 for Boeing)     ✅
        -- If there are not enough, move next time to 30 minutes later                  ✅
        
    -- Increment the progress and set the status to in flight                           ✅
    -- Calculate the flight time using the speed of airplane and distance of leg        ✅
    -- Update the next time using the flight time                                       ✅
    
end //
delimiter ;


-- [8] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the same airport as the flight,
and the flight must be heading towards that passenger's desired destination.
Also, each passenger must have enough funds to cover the flight.  Finally, there
must be enough seats to accommodate all boarding passengers. 

• The passengers must be at the same airport as the flight, and the flight must be heading towards
that passenger's desired destination.                                                                   ✅
• Each passenger must have enough funds to cover the flight.                                            ✅
• There must be enough seats to accommodate all boarding passengers
*/
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin
    # Flight information variables
    DECLARE flight_cost INT;
    DECLARE flight_airlineID VARCHAR(50);
    DECLARE plane_locationID VARCHAR(50);
    DECLARE plane_seat_capacity INT;
    DECLARE flight_status VARCHAR(100);
    DECLARE flight_progress INT;
    DECLARE flight_routeID VARCHAR(50);
    DECLARE flight_tail_num VARCHAR(50);
    
    # Airport and route variables
    DECLARE current_airport_locationID VARCHAR(50);
    DECLARE next_arrival_airportID CHAR(3);
    DECLARE current_airportID CHAR(3);
    DECLARE max_sequence INT;
    
    # Passenger capacity variables
    DECLARE current_occupancy INT;
    DECLARE boarding_passenger_count INT;
    
    IF ip_flightID IS NULL OR ip_flightID = '' THEN
		LEAVE sp_main;
	END IF;
    
    # Ensure the flight exists and get flight details
    SELECT 
        f.cost, f.support_airline, ap.locationID, ap.seat_capacity, 
        f.airplane_status, f.progress, f.routeID, f.support_tail
    INTO 
        flight_cost, flight_airlineID, plane_locationID, plane_seat_capacity,
        flight_status, flight_progress, flight_routeID, flight_tail_num
    FROM flight f
    JOIN airplane ap ON f.support_airline = ap.airlineID AND f.support_tail = ap.tail_num
    WHERE f.flightID = ip_flightID;
    
    # Checks for NULL or negative flight cost
    IF flight_cost IS NULL OR flight_cost < 0 THEN
--      SELECT 'NULL or negative cost prohibited.';
        LEAVE sp_main;
    END IF;
    
    # Ensure that the flight is on the ground
    IF flight_status <> 'on_ground' THEN
--      SELECT 'plane status must be \'on_ground\'';
        LEAVE sp_main;
    END IF;
    
    # Ensure that the flight has further legs to be flown
    SELECT MAX(sequence) INTO max_sequence 
    FROM route_path 
    WHERE route_path.routeID = flight_routeID;
    
    IF flight_progress >= max_sequence THEN
--      SELECT 'no more legs.';
        LEAVE sp_main;
    END IF;
    
    # Get current and next airport information
    IF flight_progress = 0 THEN
        SELECT 
            l.departure, port.locationID, l.arrival
        INTO 
            current_airportID, current_airport_locationID, next_arrival_airportID
        FROM route_path rp
        JOIN leg l ON rp.legID = l.legID
        JOIN airport port ON l.departure = port.airportID
        WHERE rp.routeID = flight_routeID AND rp.sequence = 1;
    ELSE
        SELECT 
            l_curr.arrival, port_curr.locationID, l_next.arrival
        INTO 
            current_airportID, current_airport_locationID, next_arrival_airportID
        FROM route_path rp_curr
        JOIN leg l_curr ON rp_curr.legID = l_curr.legID
        JOIN airport port_curr ON l_curr.arrival = port_curr.airportID
        JOIN route_path rp_next ON rp_curr.routeID = rp_next.routeID AND rp_next.sequence = rp_curr.sequence + 1
        JOIN leg l_next ON rp_next.legID = l_next.legID
        WHERE rp_curr.routeID = flight_routeID AND rp_curr.sequence = flight_progress;
    END IF; 

    IF current_airport_locationID IS NULL OR next_arrival_airportID IS NULL 
        OR current_airport_locationID = '' OR next_arrival_airportID = '' THEN
--         SELECT 'NULL or empty locIDs not allowed';
        LEAVE sp_main;
    END IF;
    
    # Create temporary table for eligible passengers
    DROP TEMPORARY TABLE IF EXISTS temp_boarding_passengers;
    CREATE TEMPORARY TABLE temp_boarding_passengers (
        personID VARCHAR(50) PRIMARY KEY
    );

    # Update the temporary tables
    INSERT INTO temp_boarding_passengers (personID)
    SELECT prsn.personID
    FROM person prsn
    JOIN passenger ps ON prsn.personID = ps.personID
    JOIN (
        SELECT 
            pv.personID, pv.airportID,
            ROW_NUMBER() OVER (PARTITION BY pv.personID ORDER BY pv.sequence) AS rn
        FROM passenger_vacations pv
    ) AS next_dest ON prsn.personID = next_dest.personID AND next_dest.rn = 1
    WHERE
        prsn.locationID = current_airport_locationID    
        AND next_dest.airportID = next_arrival_airportID 
        AND ps.funds >= flight_cost;                  

    # Get count of eligible passengers
    SELECT COUNT(*) INTO boarding_passenger_count FROM temp_boarding_passengers;
    
    # Check current plane occupancy
    SELECT COUNT(*) INTO current_occupancy 
    FROM person 
    WHERE locationID = plane_locationID;
    
    # Verify capacity for boarding
    IF (current_occupancy + boarding_passenger_count) > plane_seat_capacity THEN
        DROP TEMPORARY TABLE IF EXISTS temp_boarding_passengers;
--         SELECT 'not enough room!';
        LEAVE sp_main;
    END IF;
    
    #################################### BOARDING PASSENGERS ####################################
    IF boarding_passenger_count > 0 THEN
        # Update passenger locations to be on the plane
        UPDATE person p
        JOIN temp_boarding_passengers tbp ON p.personID = tbp.personID
        SET p.locationID = plane_locationID;

        # Deduct flight cost from passengers' funds
        UPDATE passenger ps
        JOIN temp_boarding_passengers tbp ON ps.personID = tbp.personID
        SET ps.funds = ps.funds - flight_cost;

        # Update airline revenue
        UPDATE airline
        SET revenue = revenue + (flight_cost * boarding_passenger_count)
        WHERE airlineID = flight_airlineID;
    END IF;

    # Clean up temporary table
    DROP TEMPORARY TABLE IF EXISTS temp_boarding_passengers;
    #################################### BOARDING PASSENGERS ####################################

END //
delimiter ;

-- call passengers_board('dl_42');

-- [9] passengers_disembark()
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin
    DECLARE v_airport_code CHAR(3);
    DECLARE v_airport_locationID VARCHAR(50);
    DECLARE v_plane_locationID VARCHAR(50);
    
    IF ip_flightID IS NULL OR ip_flightID = '' THEN
		LEAVE sp_main;
	END IF;
    
    -- Validate flight and get current airport in one query
    SELECT 
        CASE 
            WHEN f.progress = 0 THEN l.departure 
            ELSE l.arrival 
        END,
        a.locationID,
        ap.locationID
    INTO 
        v_airport_code,
        v_airport_locationID,
        v_plane_locationID
    FROM flight f
    JOIN airplane ap ON f.support_airline = ap.airlineID AND f.support_tail = ap.tail_num
    JOIN route_path rp ON f.routeID = rp.routeID 
        AND rp.sequence = CASE WHEN f.progress = 0 THEN 1 ELSE f.progress END
    JOIN leg l ON rp.legID = l.legID
    JOIN airport a ON a.airportID = CASE 
            WHEN f.progress = 0 THEN l.departure 
            ELSE l.arrival 
        END
    WHERE f.flightID = ip_flightID
      AND f.airplane_status = 'on_ground';
    
    -- Check validation conditions
    IF v_airport_locationID IS NULL OR v_plane_locationID IS NULL THEN
        LEAVE sp_main;
    END IF;
    
    -- Process disembarking passengers in a single transaction
    START TRANSACTION;
    
    -- Update passenger locations and remove completed vacation segments
    UPDATE person p
    JOIN passenger ps ON p.personID = ps.personID
    JOIN (
        SELECT pv.personID, MIN(pv.sequence) AS first_sequence
        FROM passenger_vacations pv
        WHERE pv.airportID = v_airport_code
        GROUP BY pv.personID
    ) AS first_stop ON p.personID = first_stop.personID
    SET p.locationID = v_airport_locationID
    WHERE p.locationID = v_plane_locationID;
    
    DELETE pv FROM passenger_vacations pv
    JOIN (
        SELECT personID, MIN(sequence) AS min_sequence
        FROM passenger_vacations
        WHERE airportID = v_airport_code
        GROUP BY personID
    ) AS to_delete ON pv.personID = to_delete.personID AND pv.sequence = to_delete.min_sequence;
    
    COMMIT;
end //
delimiter ;



-- [10] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
flight.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. 

• The pilot being assigned must have a license for that type of airplane and must be at the same
location as the flight.
• A pilot can only support one flight (i.e. one airplane) at a time.
• The pilot must be assigned to the flight and have their location updated for the appropriate
airplane.
*/
-- -----------------------------------------------------------------------------
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (IN ip_flightID varchar(50), IN ip_personID varchar(50))
main_sp: begin
    DECLARE v_flight_exists INT DEFAULT 0;
    DECLARE v_pilot_exists INT DEFAULT 0;
    DECLARE v_airplane_exists INT DEFAULT 0;
    DECLARE v_license_valid INT DEFAULT 0;
    
    IF ip_flightID IS NULL OR ip_personID IS NULL THEN
		LEAVE main_sp;
	END IF;
    
    IF ip_flightID = '' OR ip_personID = '' THEN
		LEAVE main_sp;
	END IF;
    
    # Check basic existence first
    SELECT COUNT(*) INTO v_flight_exists FROM flight WHERE flightID = ip_flightID;
    SELECT COUNT(*) INTO v_pilot_exists FROM person WHERE personID = ip_personID;
    
    IF v_flight_exists = 0 OR v_pilot_exists = 0 THEN
-- 		SELECT 'pilot assignment failed!';
        LEAVE main_sp;
    END IF;
    
    -- Validate all conditions in a single nested IF structure
    IF (SELECT airplane_status FROM flight WHERE flightID = ip_flightID) = 'on_ground' THEN
        IF (SELECT commanding_flight FROM pilot WHERE personID = ip_personID) IS NULL THEN
            IF (SELECT progress FROM flight WHERE flightID = ip_flightID) < 
               (SELECT COUNT(*) FROM route_path WHERE routeID = (SELECT routeID FROM flight WHERE flightID = ip_flightID)) THEN
                IF (SELECT locationID FROM person WHERE personID = ip_personID) = 
                   (SELECT locationID FROM airport WHERE airportID = 
                    (SELECT departure FROM leg WHERE legID = 
                     (SELECT legID FROM route_path WHERE routeID = 
                      (SELECT routeID FROM flight WHERE flightID = ip_flightID) 
                      AND sequence = (SELECT progress FROM flight WHERE flightID = ip_flightID) + 1))) THEN
                    SELECT COUNT(*) INTO v_airplane_exists 
                    FROM airplane 
                    WHERE airlineID = (SELECT support_airline FROM flight WHERE flightID = ip_flightID)
                    AND tail_num = (SELECT support_tail FROM flight WHERE flightID = ip_flightID);
                    
                    IF v_airplane_exists > 0 THEN
                        SELECT COUNT(*) INTO v_license_valid 
                        FROM pilot_licenses 
                        WHERE personID = ip_personID 
                        AND license = (SELECT plane_type FROM airplane 
                                      WHERE airlineID = (SELECT support_airline FROM flight WHERE flightID = ip_flightID)
                                      AND tail_num = (SELECT support_tail FROM flight WHERE flightID = ip_flightID));
                        
                        IF v_license_valid > 0 THEN
                            # All checks passed - assign pilot
                            UPDATE pilot SET commanding_flight = ip_flightID WHERE personID = ip_personID;
                            UPDATE person SET locationID = 
                                (SELECT locationID FROM airplane 
                                 WHERE airlineID = (SELECT support_airline FROM flight WHERE flightID = ip_flightID)
                                 AND tail_num = (SELECT support_tail FROM flight WHERE flightID = ip_flightID))
                            WHERE personID = ip_personID;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;
end //
delimiter ;

-- [11] recycle_crew()
-- -----------------------------------------------------------------------------
drop procedure if exists recycle_crew;
DELIMITER //
create procedure recycle_crew (
    in ip_flightID varchar(50)
)
sp_main: begin
    DECLARE v_valid_flight BOOLEAN DEFAULT FALSE;
    DECLARE v_arrival_locationID VARCHAR(50);
    
    IF ip_flightID IS NULL OR ip_flightID = '' THEN
		LEAVE sp_main;
	END IF;
    
    -- Validate all conditions in a single query
    SELECT a.locationID INTO v_arrival_locationID
    FROM flight f
    JOIN route_path rp ON f.routeID = rp.routeID
    JOIN leg l ON rp.legID = l.legID
    JOIN airport a ON l.arrival = a.airportID
    WHERE f.flightID = ip_flightID
      AND f.airplane_status = 'on_ground'
      AND f.routeID IS NOT NULL
      AND f.routeID != ''
      AND f.progress = (
          SELECT MAX(sequence) 
          FROM route_path 
          WHERE routeID = f.routeID
      )
      AND NOT EXISTS (
          SELECT 1 
          FROM person p
          JOIN passenger pa ON p.personID = pa.personID
          JOIN airplane ap ON p.locationID = ap.locationID
          WHERE ap.airlineID = f.support_airline
            AND ap.tail_num = f.support_tail
      )
      AND EXISTS (
          SELECT 1 
          FROM airplane
          WHERE airlineID = f.support_airline
            AND tail_num = f.support_tail
      );
    
    -- If all conditions met, perform updates
    IF v_arrival_locationID IS NOT NULL THEN
        -- Move pilots to arrival airport
        UPDATE person p
        JOIN pilot pi ON p.personID = pi.personID
        JOIN flight f ON pi.commanding_flight = f.flightID
        SET p.locationID = v_arrival_locationID
        WHERE f.flightID = ip_flightID;
        
        -- Clear flight assignments
        UPDATE pilot
        JOIN flight f ON pilot.commanding_flight = f.flightID
        SET pilot.commanding_flight = NULL
        WHERE f.flightID = ip_flightID;
    END IF;
END //
DELIMITER ;


-- [12] retire_flight()
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin

    -- Ensure that the flight is on the ground
    -- Ensure that the flight does not have any more legs
    -- Ensure that there are no more people on the plane supporting the flight
    -- Remove the flight from the system

    DECLARE flight_progress INT;
    DECLARE flight_status VARCHAR(100);
    DECLARE flight_routeID VARCHAR(50);
    DECLARE flight_max_sequence INT;
    DECLARE passenger_count INT;
    DECLARE pilot_count INT;

	IF ip_flightID IS NULL OR ip_flightID = '' THEN
		LEAVE sp_main;
	END IF;

    # progress and status of flight
    SELECT progress, airplane_status, routeID INTO flight_progress, flight_status, flight_routeID 
    FROM flight WHERE flightID = ip_flightID;

    # check if airplane is on the ground
    IF flight_status <> 'on_ground' THEN
--      SELECT 'airplane must be in the air';
        LEAVE sp_main;
    END IF;

   # flight is at start or end of route
    SELECT MAX(sequence) INTO flight_max_sequence
    FROM route_path WHERE routeID = flight_routeID;

    # checks if there is no more legs to fo
    IF NOT (flight_progress = 0 OR flight_progress = flight_max_sequence) THEN
--      SELECT 'no more legs to go';
        LEAVE sp_main;
    END IF;

    # if there are passengers on plane
    SELECT COUNT(*) INTO passenger_count FROM passenger p
    JOIN person pe ON p.personID = pe.personID
    JOIN flight f ON f.flightID = ip_flightID
    JOIN airplane a ON f.support_airline = a.airlineID AND f.support_tail = a.tail_num
    WHERE pe.locationID = a.locationID;

    # Checks id there are any passengers on plane
    IF passenger_count > 0 THEN
--      SELECT 'no people should be on plane';
        LEAVE sp_main;
    END IF;

    # if there are pilots on plane
    SELECT COUNT(*) INTO pilot_count FROM pilot
    WHERE commanding_flight = ip_flightID;

    # verifying pilot count
    IF pilot_count > 0 THEN
--      SELECT 'pilot count must be 0';
        LEAVE sp_main;
    END IF;
    #################################### DELETING FLIGHT ####################################

    # delete once all conditions are fulfilled 
    DELETE FROM flight WHERE flightID = ip_flightID;
    #################################### DELETING FLIGHT ####################################


end //
delimiter ;
-- call retire_flight('ke_88');


-- [13] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle.  The flight
with the smallest next time in chronological order must be identified and selected.
If multiple flights have the same time, then flights that are landing should be
preferred over flights that are taking off.  Similarly, flights with the lowest
identifier in alphabetical order should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed
to land, passengers allowed to disembark, and the time advanced by one hour until
the next takeoff to allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should
be allowed to board, and the time should be advanced to represent when the airplane
will land at its next location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the
flight crew should be recycled to allow rest, and the flight itself should be
retired from the system. 

• The flight with the smallest next time in chronological order must be identified and selected.
• If multiple flights have the same time:
o Flights that are landing should be preferred over flights that are taking off.
o Flights with the lowest identifier in alphabetical order should also be preferred.
• If an airplane is in flight and waiting to land, the flight should be allowed to land, passengers should
be allowed to disembark, and the time should be advanced by one hour until the next takeoff to
allow for preparations.
• If an airplane is on the ground and waiting to take off, passengers should be allowed to board, and
the time should be advanced to represent when the airplane will land at its next location based on
leg distance and airplane speed.
• If an airplane is on the ground and has reached the end of its route, the flight crew should be
recycled to allow rest, and the flight should be retired from the system.
*/
-- -----------------------------------------------------------------------------
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle()
sp_main: begin
  DECLARE v_flight_found BOOLEAN DEFAULT FALSE;
  DECLARE v_current_flightID VARCHAR(50);
  DECLARE v_current_routeID VARCHAR(50);
  DECLARE v_current_progress INT;
  DECLARE v_flight_status VARCHAR(100);
  DECLARE v_next_event_time TIME;
  DECLARE v_is_last_leg BOOLEAN DEFAULT FALSE;
  
  -- Step 1: Select next flight to process using a cursor for better reliability
  SELECT 
    f.flightID, f.routeID, f.progress, f.airplane_status, f.next_time
  INTO 
    v_current_flightID, v_current_routeID, v_current_progress, v_flight_status, v_next_event_time
  FROM flight f
  WHERE f.next_time = (
    SELECT MIN(next_time) FROM flight
  )
  ORDER BY 
    CASE WHEN f.airplane_status = 'in_flight' THEN 0 ELSE 1 END,
    f.flightID
  LIMIT 1;
  
  -- Only proceed if we found a flight to process
  IF v_current_flightID IS NOT NULL THEN
    -- Step 2: Determine if this is the last leg for on-ground flights
    IF v_flight_status = 'on_ground' THEN
      SET v_is_last_leg = NOT EXISTS (
        SELECT 1 FROM route_path 
        WHERE routeID = v_current_routeID AND sequence > v_current_progress
      );
    END IF;
    
    -- Process based on flight status
    CASE v_flight_status
      WHEN 'in_flight' THEN
        -- Handle landing sequence
        CALL flight_landing(v_current_flightID);
        CALL passengers_disembark(v_current_flightID);
        
      WHEN 'on_ground' THEN
        IF v_is_last_leg THEN
          -- Handle flight retirement
          CALL recycle_crew(v_current_flightID);
          CALL retire_flight(v_current_flightID);
        ELSE
          -- Handle takeoff sequence
          CALL passengers_board(v_current_flightID);
          CALL flight_takeoff(v_current_flightID);
        END IF;
    END CASE;
  END IF;
end //
delimiter ;

-- [14] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. 
We need to display what airports these flights are departing from, what airports 
they are arriving at, the number of flights that are flying between the 
departure and arrival airport, the list of those flights (ordered by their 
flight IDs), the earliest and latest arrival times for the destinations and the 
list of planes (by their respective flight IDs) flying these flights. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air (departing_from, arriving_at, num_flights,
    flight_list, earliest_arrival, latest_arrival, airplane_list) as
SELECT  
    lg.departure AS departing_from,
    lg.arrival AS arriving_at,
    COUNT(f.flightID) AS num_flights,
    GROUP_CONCAT(f.flightID SEPARATOR ',') AS flight_list,
    MIN(f.next_time) AS earliest_arrival,
    MAX(f.next_time) AS latest_arrival,
    GROUP_CONCAT(a.locationID SEPARATOR ',') AS airplane_list
FROM flight AS f
JOIN route_path AS rp 
    ON f.routeID = rp.routeID 
    AND f.progress = rp.sequence
JOIN leg AS lg 
    ON rp.legID = lg.legID
JOIN airplane AS a 
    ON f.support_airline = a.airlineID 
    AND f.support_tail = a.tail_num
WHERE f.airplane_status = 'in_flight'
GROUP BY lg.departure, lg.arrival;

-- [15] flights_on_the_ground()
-- ------------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are 
located. We need to display what airports these flights are departing from, how 
many flights are departing from each airport, the list of flights departing from 
each airport (ordered by their flight IDs), the earliest and latest arrival time 
amongst all of these flights at each airport, and the list of planes (by their 
respective flight IDs) that are departing from each airport.*/
-- ------------------------------------------------------------------------------
create or replace view flights_on_the_ground (departing_from, num_flights,
    flight_list, earliest_arrival, latest_arrival, airplane_list) as 
SELECT
    CASE
        WHEN f.progress <> 0 THEN lg.arrival
        ELSE lg.departure
    END AS departing_from,
    COUNT(*) AS num_flights,
    GROUP_CONCAT(f.flightID SEPARATOR ',') AS flight_list,
    MIN(next_time) AS earliest_arrival,
    MAX(next_time) AS latest_arrival,
    GROUP_CONCAT(ap.locationID SEPARATOR ',') AS plane_list
FROM flight AS f
LEFT JOIN route_path AS rp ON ((f.routeID = rp.routeID) AND (f.progress = rp.sequence))
    OR ((f.progress = 0) AND (f.routeID = rp.routeID) AND (f.progress + 1 = rp.sequence))
JOIN airplane AS ap ON (ap.airlineID = f.support_airline) AND (ap.tail_num = f.support_tail)
NATURAL JOIN leg AS lg
WHERE f.airplane_status = 'on_ground'
GROUP BY departing_from;

-- [16] people_in_the_air()
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (
    departing_from, arriving_at, num_airplanes, airplane_list, flight_list,
    earliest_arrival, latest_arrival, num_pilots, num_passengers,
    joint_pilots_passengers, person_list
) AS
SELECT
    leg.departure AS departing_from,
    leg.arrival AS arriving_at,
    COUNT(DISTINCT a.locationID) AS num_airplanes,
    GROUP_CONCAT(DISTINCT a.locationID ORDER BY a.locationID) AS airplane_list,
    GROUP_CONCAT(DISTINCT f.flightID ORDER BY f.flightID) AS flight_list,
    MIN(f.next_time) AS earliest_arrival,
    MAX(f.next_time) AS latest_arrival,
    SUM(CASE WHEN pi.personID IS NOT NULL THEN 1 ELSE 0 END) AS num_pilots,
    SUM(CASE WHEN ps.personID IS NOT NULL THEN 1 ELSE 0 END) AS num_passengers,
    COUNT(p.personID) AS joint_pilots_passengers,
    GROUP_CONCAT(DISTINCT p.personID ORDER BY p.personID) AS person_list
FROM
    person p
JOIN airplane a ON p.locationID = a.locationID
JOIN flight f ON f.support_airline = a.airlineID AND f.support_tail = a.tail_num
JOIN route_path rp ON f.routeID = rp.routeID AND f.progress = rp.sequence
JOIN leg ON rp.legID = leg.legID
LEFT JOIN pilot pi ON p.personID = pi.personID
LEFT JOIN passenger ps ON p.personID = ps.personID
WHERE
    f.airplane_status = 'in_flight'
GROUP BY
    leg.departure, leg.arrival;


-- [17] people_on_the_ground()
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (
    departing_from, airport, airport_name,
    city, state, country, num_pilots, num_passengers, joint_pilots_passengers, person_list
) AS
SELECT
    a.airportID AS departing_from,
    a.locationID AS airport,
    a.airport_name,
    a.city,
    a.state,
    a.country,
    SUM(CASE WHEN pi.personID IS NOT NULL THEN 1 ELSE 0 END) AS num_pilots,
    SUM(CASE WHEN ps.personID IS NOT NULL THEN 1 ELSE 0 END) AS num_passengers,
    COUNT(p.personID) AS joint_pilots_passengers,
    GROUP_CONCAT(DISTINCT p.personID ORDER BY p.personID) AS person_list
FROM
    person p
JOIN airport a ON p.locationID = a.locationID
LEFT JOIN pilot pi ON p.personID = pi.personID
LEFT JOIN passenger ps ON p.personID = ps.personID
GROUP BY
    a.airportID, a.locationID, a.airport_name, a.city, a.state, a.country;

-- [18] route_summary()
-- -----------------------------------------------------------------------------
create or replace view route_summary (
    route, 
    num_legs, 
    leg_sequence, 
    route_length,
    num_flights, 
    flight_list, 
    airport_sequence
) AS
WITH route_legs_info AS (
    SELECT
        rp.routeID,
        COUNT(DISTINCT rp.legID) AS num_legs,
        GROUP_CONCAT(rp.legID ORDER BY rp.sequence SEPARATOR ',') AS leg_sequence,
        SUM(l.distance) AS route_length,
        GROUP_CONCAT(
            CONCAT(l.departure, '->', l.arrival) 
            ORDER BY rp.sequence 
            SEPARATOR ','
        ) AS airport_sequence
    FROM route_path rp
    JOIN leg l ON rp.legID = l.legID
    GROUP BY rp.routeID 
),
route_flights_info AS (
    SELECT
        f.routeID,
        COUNT(DISTINCT f.flightID) AS num_flights,
        GROUP_CONCAT(DISTINCT f.flightID ORDER BY f.flightID SEPARATOR ',') AS flight_list
    FROM flight f
    GROUP BY f.routeID 
)
SELECT
    r.routeID AS route,
    COALESCE(rli.num_legs, 0) AS num_legs,
    rli.leg_sequence,
    COALESCE(rli.route_length, 0) AS route_length,
    COALESCE(rfi.num_flights, 0) AS num_flights,
    rfi.flight_list,
    rli.airport_sequence
FROM route r
LEFT JOIN route_legs_info rli ON r.routeID = rli.routeID
LEFT JOIN route_flights_info rfi ON r.routeID = rfi.routeID
ORDER BY r.routeID;


-- [19] alternative_airports()
-- -----------------------------------------------------------------------------
create or replace view alternative_airports as
SELECT DISTINCT
    a.city,
    a.state,
    a.country,
    (SELECT COUNT(*) FROM airport a2 
     WHERE a2.city = a.city AND a2.state = a.state AND a2.country = a.country) AS num_airports,
    (SELECT GROUP_CONCAT(a3.airportID ORDER BY a3.airportID SEPARATOR ',')
     FROM airport a3
     WHERE a3.city = a.city AND a3.state = a.state AND a3.country = a.country) AS airport_code_list,
    (SELECT GROUP_CONCAT(a4.airport_name ORDER BY a4.airportID SEPARATOR ',')
     FROM airport a4
     WHERE a4.city = a.city AND a4.state = a.state AND a4.country = a.country) AS airport_name_list
FROM 
    airport a
WHERE 
    (SELECT COUNT(*) FROM airport a5 
     WHERE a5.city = a.city AND a5.state = a.state AND a5.country = a.country) > 1
ORDER BY
    a.country,
    a.state,
    a.city;