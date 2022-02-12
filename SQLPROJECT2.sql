/*question 1 
List all the people in the passenger table, including their name, itinerary number, fare, and confirmation number. Order by
name and fare. */

SELECT PAS_NAME, PAS_ITINERARY_NO, PAS_FARE, PAS_CONFIRM_NO
FROM PASSENGER 
ORDER BY PAS_NAME, PAS_FARE;

/*question 2
Using an “OR” operator, list pilot name, state, zip code, and flight pay for pilots who make more than $2,500 per flight and
live in either Houston or Phoenix. */

SELECT pil_pilotname, pil_state, pil_city,  pil_zip, pil_flight_pay
FROM Pilots 
WHERE pil_flight_pay > 2500 AND (pil_city = 'HOUSTON' OR pil_city = 'PHOENIX');

/* question 3
Using an “IN”, list pilot names, zip and flight pay for pilots who make more than $2,500 per flight and live in either Houston
or Phoenix.
*/
SELECT pil_pilotname, pil_city, pil_state, pil_zip, pil_flight_pay
FROM Pilots 
WHERE pil_flight_pay > 2500 AND pil_city IN ('HOUSTON','PHOENIX');

/*question 4 
Using an “AND” and an “OR”, list all information (Equipment Number, Equipment Type, Seat Capacity, Fuel Capacity, and
Miles per Gallon) on aircraft that have a seat capacity less than 280, or aircraft that have a miles per gallon greater than 4.0
miles per gallon and fuel capacity less than 2000.*/

SELECT * FROM Equip_type 
WHERE EQ_SEAT_CAPACITY < 280 OR (EQ_miles_per_gal > 4.0 AND EQ_FUEL_CAPACITY < 2000);

/*question 5
Using PATTERN MATCHING (the LIKE operation), select all information for airports in Los Angeles. */

SELECT * FROM Airport
WHERE air_location LIKE 'Los%';

/*question 6
Using a HAVING statement, produce a unique list of pilot Id's of pilots who piloted more than 20 departures. Order by pilot
id ascending.*/

SELECT DISTINCT DEP_pilot_id 
FROM DEPARTURES
GROUP BY DEP_pilot_id
HAVING COUNT(DEP_pilot_id) > 20
ORDER BY DEP_pilot_id;

/* question 7
List all flights showing flight number, flight fare, flight distance, and the miles flown per dollar (distance/fare) as “Miles Flown
Per Dollar” that have miles per dollar greater than $5.50, and sort by miles flown per dollar descending. Make sure to name
the attributes as shown in the example output
*/

SELECT fl_flight_no as “Flight number" , fl_fare as "Fare" , 
fl_distance as "Distance" , ROUND(fl_distance / fl_fare, 2) AS "Miles Flown Per Dollar" 
FROM Flight 
WHERE ROUND(fl_distance / fl_fare, 2) > 5.50
ORDER BY ROUND(fl_distance / fl_fare, 2) DESC;

/*question 8 
Display airport location and number of departing flights as "Number of departing Flights".
*/

SELECT air_location, COUNT(fl_flight_no) as "Number of departing Flights"
FROM Airport
JOIN Flight
ON air_code = fl_orig
GROUP BY air_location;

/* question 9
List the maximum pay, minimum pay and average flight pay by state for pilots. Make sure to name the attributes as shown in
the example output. */
SELECT pil_state as "State", MAX(pil_flight_pay) as "Max Pay", MIN(pil_flight_pay)as "Min Pay", AVG(pil_flight_pay) as "Avg Pay" 
FROM Pilots
GROUP BY pil_state;

/*question 10 
Display pilot name and departure date of his first flight. Order by pilot name. Hint: you will need pilots and departures tables */
SELECT DISTINCT pil_pilotname, MIN(DEP_DEP_DATE) as "First Departure"
FROM Pilots
JOIN Departures 
ON pil_pilot_id = DEP_PILOT_ID
GROUP BY pil_pilotname
ORDER BY pil_pilotname;

/* question 11
For each unique equipment type, List the equipment types and maximum miles that can be flown as "Maximum Distance
Flown". Order by maximum distance descending. */

SELECT DISTINCT EQ_EQUIP_TYPE, (EQ_miles_per_gal * EQ_FUEL_CAPACITY) AS "Maximum Distance Flown"
FROM Equip_type 
ORDER BY (EQ_miles_per_gal * EQ_FUEL_CAPACITY) DESC;

/* question 12 
List the number of flights originating from each airport as NUMBER_OF_FLIGHTS. Hint: you will need to use count function. */

SELECT fl_orig, COUNT(fl_flight_no) as "NUMBER_OF_FLIGHTS"
FROM Flight
GROUP BY fl_orig;

/* question 13
Using an “OR” statement and a “WHERE” join, display flight number, origination and departure for flights that originate from
an airport that does not have a hub airline or flights that originate from an airport that is a hub for American Airlines.  */

SELECT fl_flight_no, fl_orig, fl_dest, air_code, air_hub_airline 
FROM Flight
JOIN Airport 
ON fl_orig = air_code 
WHERE air_hub_airline is NULL OR air_hub_airline = 'American';

/*question 14 
Display the flight number, departure date and equipment type for all equipment that is manufactured by Concorde. Order by
departure date and flight number. Need to use “like” keyword in your query. */

SELECT DEP_FLIGHT_NO, DEP_DEP_DATE, EQ_EQUIP_TYPE 
FROM Departures 
JOIN Equip_type 
ON EQ_EQUIP_NO = DEP_EQUIP_NO
WHERE EQ_EQUIP_TYPE LIKE 'CON%'
ORDER BY DEP_DEP_DATE, DEP_FLIGHT_NO ;

/* question 15 
Using a SUB QUERY, display the IDs and names of pilots who are not currently scheduled for a departure. Hint: you will use
“not in” keyword. */

SELECT pil_pilot_id, pil_pilotname
FROM Pilots 
WHERE pil_pilot_id 
NOT IN (SELECT DEP_PILOT_ID 
        FROM DEPARTURES);

/* question 16
Using “IS NULL” and an OUTER JOIN, display the IDs and names of pilots who are not currently scheduled for a departure. */

SELECT pil_pilot_id, pil_pilotname
FROM Pilots 
LEFT JOIN DEPARTURES 
ON DEP_PILOT_ID = pil_pilot_id 
WHERE DEP_DEP_DATE IS NULL;

/* question 17 
Display passenger name and seat number, as "Seat Number", for flight 101, departing on July 15, 2017 order by “Seat
Number” */

SELECT PAS_NAME, TIC_SEAT AS "Seat Number"
FROM PASSENGER 
JOIN Ticket 
ON PAS_ITINERARY_NO = TIC_ITINERARY_NO 
WHERE TIC_FLIGHT_NO = 101 AND TIC_FLIGHT_DATE = '15-JUL-17'
ORDER BY TIC_SEAT;

/*QUESTION 18 
List flight number, departure date and number of passengers as "Number of Passengers" for departures that have more than
5 passengers. */

SELECT DEP_DEP_DATE, DEP_FLIGHT_NO, COUNT(PAS_ITINERARY_NO) as "Number of Passengers"
FROM DEPARTURES 
JOIN TICKET
ON DEP_FLIGHT_NO = TIC_FLIGHT_NO 
JOIN PASSENGER 
ON TIC_ITINERARY_NO = PAS_ITINERARY_NO
GROUP BY DEP_DEP_DATE, DEP_FLIGHT_NO
HAVING COUNT(PAS_ITINERARY_NO) > 5;

/* question 19
Select flight number, origination and destination for all reservations booked by Andy Anderson, Order results by flight
number.*/
SELECT FL_FLIGHT_NO, FL_ORIG, FL_DEST
FROM FLIGHT
WHERE FL_FLIGHT_NO 
IN (SELECT DEP_FLIGHT_NO
    FROM DEPARTURES
    WHERE DEP_FLIGHT_NO
    IN (SELECT RES_FLIGHT_NO 
        FROM RESERVATION
        WHERE RES_NAME = 'Andy Anderson'))
ORDER BY FL_FLIGHT_NO;

/* question 20
Display departing airport code as "Departs From", arriving airport code as "Arrives at", and minimum fair as "Minimum Fair",
for flights that have minimum fare for flights between these two airports. */

SELECT FL_ORIG AS "Departs from", FL_DEST as "Arrives at", MIN(FL_FARE) as "Minimum Fair"
FROM FLIGHT
GROUP BY FL_ORIG, FL_DEST;





