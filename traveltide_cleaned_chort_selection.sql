-- traveltide_cleaned_cohort_selection.sql
-- This SQL query is designed to analyze user behavior and trip data from a travel booking platform
-- The query focuses on users who have had more than 7 sessions since January 5, 2023
-- Author: Dido De Boodt
-- Date: 2025-05-08


WITH filtered_users AS (
  SELECT 
    user_id,
    COUNT(*) AS session_count
  FROM sessions s
  WHERE session_start >= '2023-01-05'
  GROUP BY user_id
  HAVING COUNT(DISTINCT session_id) > 7
),

session_based AS (
  SELECT 
    s.session_id, 
    s.user_id, 
    s.trip_id, 
    s.session_start, 
    s.session_end,
    EXTRACT(EPOCH FROM s.session_end - s.session_start) AS session_duration,
    s.page_clicks, 
    s.flight_discount, 
    s.flight_discount_amount, 
  	s.hotel_discount, 
    s.hotel_discount_amount, 
    s.flight_booked, 
    s.hotel_booked, 
    CASE WHEN check_in_time IS NOT NULL THEN DATE_PART('day', check_in_time - session_start)
         WHEN departure_time IS NOT NULL THEN DATE_PART('day', departure_time - session_start)
         ELSE NULL
         END AS days_between_booking,
    s.cancellation, 
    u.birthdate, 
    u.gender, 
    u.married, 
    u.has_children, 
    u.home_country, 
    u.home_city, 
    u.home_airport, 
    u.home_airport_lat, 
    u.home_airport_lon, 
    u.sign_up_date,
  	f.origin_airport, 
    f.destination, 
    f.destination_airport, 
    f.seats, 
    f.return_flight_booked, 
    f.departure_time, 
    f.return_time, 
    f.checked_bags, 
  	f.trip_airline, 
    f.destination_airport_lat, 
    f.destination_airport_lon, 
    f.base_fare_usd, 
    h.hotel_name,
    CASE WHEN check_out_time::date - check_in_time::date <1 THEN 1
         ELSE check_out_time::date - check_in_time::date
         END AS nights, 
    CASE WHEN rooms=0 THEN 1 
         ELSE rooms 
         END AS rooms, 
    h.check_in_time, 
    h.check_out_time, 
    h.hotel_per_room_usd
  FROM sessions s
  LEFT JOIN users u ON s.user_id = u.user_id
  LEFT JOIN flights f ON s.trip_id = f.trip_id
  LEFT JOIN hotels h ON s.trip_id = h.trip_id
  JOIN filtered_users fu ON s.user_id = fu.user_id
  WHERE session_start >= '2023-01-05'
),

cancelled_trips AS (
  SELECT DISTINCT trip_id
  FROM session_based
  WHERE cancellation = TRUE
),  

not_cancelled AS (
  SELECT DISTINCT *
  FROM session_based
  WHERE trip_id IS NOT NULL 
    AND trip_id NOT IN(SELECT trip_id FROM cancelled_trips)
), 

user_based_sessions AS (
  SELECT 
    user_id,
    CASE WHEN COUNT(DISTINCT session_id) <= 2 THEN 'low engagement'
         WHEN COUNT(DISTINCT session_id) <= 10 THEN 'medium engagement'
         ELSE 'high engagement'
         END AS engagement_level,
    CASE WHEN COUNT(DISTINCT trip_id) = 0 THEN 'nothing spend'
         WHEN (SUM(hotel_per_room_usd * rooms * nights) / COUNT(DISTINCT trip_id)) < 100 THEN 'budget traveler'
         WHEN (SUM(hotel_per_room_usd * rooms * nights) / COUNT(DISTINCT trip_id)) < 300 THEN 'economy traveler'
         WHEN (SUM(hotel_per_room_usd * rooms * nights) / COUNT(DISTINCT trip_id)) < 800 THEN 'premium traveler'
         ELSE 'luxury traveler'
         END AS spending_type,
    COUNT(DISTINCT session_id) AS total_sessions,
    SUM(page_clicks) AS total_page_clicks,
    AVG(page_clicks) AS avg_clicks_per_session,
    AVG(session_duration) AS avg_session_duration,
    100.0 * SUM(CASE WHEN flight_discount_amount > 0 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) AS pct_sessions_flight_discount_used,
    100.0 * SUM(CASE WHEN hotel_discount_amount > 0 THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) AS pct_sessions_hotel_discount_used,
    100.0 * SUM(CASE WHEN flight_booked = TRUE THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) AS pct_sessions_flight_booked,
    100.0 * SUM(CASE WHEN hotel_booked = TRUE THEN 1 ELSE 0 END) / COUNT(DISTINCT session_id) AS pct_sessions_hotel_booked,
    SUM(haversine_distance(home_airport_lat, home_airport_lon, destination_airport_lat, destination_airport_lon)) AS total_distance,
    AVG(haversine_distance(home_airport_lat, home_airport_lon, destination_airport_lat, destination_airport_lon)) AS avg_distance,
    100.0 * SUM(CASE WHEN cancellation = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT trip_id), 0) AS cancel_rate
  FROM session_based s
  GROUP BY user_id
),

user_based_trips AS (
  SELECT
    user_id,
    CASE WHEN COUNT(DISTINCT trip_id) > 0 THEN 'traveler'
         ELSE 'dreamer'
         END AS dream_traveler,
    CASE WHEN COUNT(DISTINCT trip_id) = 0 THEN 'non traveler'
         WHEN COUNT(DISTINCT trip_id) = 1 THEN 'one time traveler'
         WHEN COUNT(DISTINCT trip_id) <= 3 THEN 'occasional traveler'
         WHEN COUNT(DISTINCT trip_id) <= 6 THEN 'regular traveler'
         ELSE 'frequent traveler'
         END AS travel_frequency,
    AVG(CASE WHEN check_in_time IS NOT NULL THEN DATE_PART('day', check_in_time - session_start)
         WHEN departure_time IS NOT NULL THEN DATE_PART('day', departure_time - session_start)
         ELSE NULL
         END) AS avg_days_between_booking,
    CASE WHEN COUNT(DISTINCT trip_id) = 0 THEN 'no trips'
         WHEN AVG(days_between_booking) < 7 THEN 'business trip'
         WHEN BOOL_OR(has_children) AND BOOL_OR(married) THEN 'family trip'
         WHEN BOOL_OR(has_children) THEN 'parent trip'
         WHEN BOOL_OR(married) THEN 'couple trip'
         ELSE 'solo or group trip'
         END AS trip_type,
    CASE WHEN COUNT(DISTINCT trip_id) = 0 THEN 0
         WHEN COUNT(DISTINCT trip_id) = 1 THEN 1
         WHEN COUNT(DISTINCT trip_id) <= 3 THEN 2
         WHEN COUNT(DISTINCT trip_id) <= 6 THEN 3
         WHEN COUNT(DISTINCT trip_id) <= 9 THEN 4
         ELSE 5
         END AS trip_frequency_score,
    MIN(departure_time) AS first_trip_date,
    MAX(departure_time) AS last_trip_date,
    COUNT(DISTINCT trip_id) AS total_trips,
    CASE WHEN COUNT(DISTINCT trip_id) > 1 
         THEN DATE_PART('day', MAX(departure_time) - MIN(departure_time))::float / (COUNT(DISTINCT trip_id) - 1)
         ELSE NULL
         END AS avg_days_between_trips,
    COUNT(base_fare_usd) AS departure_flights,
    SUM(CASE WHEN return_flight_booked = TRUE THEN 1 ELSE 0 END) AS return_flights,
    COUNT(base_fare_usd) + (SUM(CASE WHEN flight_booked = TRUE THEN 1 ELSE 0 END)) AS total_flights,
    100.0 * SUM(CASE WHEN return_flight_booked = TRUE THEN 1 ELSE 0 END) / COUNT(DISTINCT trip_id) AS pct_return_flights_booked,
    AVG(checked_bags) AS avg_checked_bags_per_trip,
    COALESCE(SUM(base_fare_usd), 0) AS total_flight_cost,
    AVG(CASE WHEN flight_booked = True THEN base_fare_usd
             ELSE 0 END) AS avg_flight_cost,
    AVG(CASE WHEN flight_booked = True AND flight_discount = True THEN base_fare_usd - flight_discount_amount 
             ELSE 0 END) AS avg_flight_cost_before_discount,
    AVG(CASE WHEN flight_booked = True AND flight_discount = True THEN flight_discount_amount
             ELSE 0 END) AS avg_flight_discount,
    COUNT(DISTINCT destination) AS unique_cities_visited,
    COALESCE(SUM((hotel_per_room_usd * nights * rooms) * (1 - COALESCE(hotel_discount_amount, 0))), 0) AS total_hotel_cost,
    AVG(CASE WHEN hotel_booked = True THEN (hotel_per_room_usd * nights * rooms)
             ELSE 0 END) AS avg_hotel_cost,
    AVG(CASE WHEN hotel_booked = True AND hotel_discount = True THEN hotel_per_room_usd - hotel_discount_amount
             ELSE 0 END) AS avg_hotel_cost_before_discount,
    AVG(CASE WHEN hotel_booked = True AND hotel_discount = True THEN hotel_discount_amount
             ELSE 0 END) AS avg_hotel_discount,
    AVG(nights) AS avg_nights_per_stay,
    AVG(rooms) AS avg_rooms_per_booking,
    COALESCE(SUM((hotel_per_room_usd * nights * rooms) * (1 - COALESCE(hotel_discount_amount, 0))), 0) / NULLIF(SUM(nights * rooms), 0) AS avg_hotel_spend_per_night,
    COALESCE(SUM(base_fare_usd), 0) + COALESCE(SUM((hotel_per_room_usd * nights * rooms) * (1 - COALESCE(hotel_discount_amount, 0))), 0) AS total_price_paid,
    COALESCE(AVG(COALESCE(base_fare_usd, 0) + COALESCE(hotel_per_room_usd * nights * rooms) * (1 - COALESCE(hotel_discount_amount, 0))), 0) AS avg_price_paid
  FROM not_cancelled
  GROUP BY user_id
)

SELECT 
  us.user_id,
  EXTRACT(YEAR FROM AGE(u.birthdate)) AS age,
  CASE 
    WHEN EXTRACT(YEAR FROM AGE(u.birthdate)) < 18 THEN '<18'  
    WHEN EXTRACT(YEAR FROM AGE(u.birthdate)) BETWEEN 18 AND 29 THEN '18-29'
    WHEN EXTRACT(YEAR FROM AGE(u.birthdate)) BETWEEN 30 AND 44 THEN '30-44'
    WHEN EXTRACT(YEAR FROM AGE(u.birthdate)) BETWEEN 45 AND 59 THEN '45-59'
    ELSE '60+' END AS age_group,
  us.engagement_level,
  us.spending_type,
  ut.dream_traveler,
  ut.travel_frequency,
  ut.avg_days_between_booking,
  ut.trip_type,
  ut.trip_frequency_score,
  (DATE '2023-01-05' - u.sign_up_date) AS days_since_signup,
  u.gender,
  u.married,
  u.has_children,
  u.home_country,
  u.home_city,
  u.home_airport,
  u.home_airport_lat,
  u.home_airport_lon,
  COALESCE(us.total_sessions, 0) AS total_sessions,
  ROUND(COALESCE(us.total_sessions, 0) / NULLIF((DATE '2023-01-05' - u.sign_up_date) / 7.0, 0), 2) AS sessions_per_week,
  COALESCE(us.total_page_clicks, 0) AS total_page_clicks,
  COALESCE(us.avg_session_duration, 0) AS avg_session_duration,
  COALESCE(us.avg_clicks_per_session, 0) AS avg_clicks_per_session,
  COALESCE(us.pct_sessions_flight_discount_used, 0) AS pct_sessions_flight_discount_used,
  COALESCE(us.pct_sessions_hotel_discount_used, 0) AS pct_sessions_hotel_discount_used,
  COALESCE(us.pct_sessions_flight_booked, 0) AS pct_sessions_flight_booked,
  COALESCE(us.pct_sessions_hotel_booked, 0) AS pct_sessions_hotel_booked,
  COALESCE(us.cancel_rate, 0) AS cancel_rate,
  ut.first_trip_date, 
  ut.last_trip_date,
  COALESCE(ut.total_trips, 0) AS total_trips,
  COALESCE(ut.avg_days_between_trips, 0) AS avg_days_between_trips,
  COALESCE(us.total_distance, 0) AS total_distance,
  COALESCE(us.avg_distance, 0) AS avg_distance,
  COALESCE(ut.total_price_paid, 0) AS total_price_paid,
  COALESCE(ut.avg_price_paid, 0) AS avg_price_paid,
  COALESCE(ut.departure_flights, 0) AS departure_flights,
  COALESCE(ut.return_flights, 0) AS return_flights,
  COALESCE(ut.total_flights, 0) AS total_flights,
  COALESCE(ut.pct_return_flights_booked, 0) AS pct_return_flights_booked,
  COALESCE(ut.total_flight_cost, 0) AS total_flight_cost,
  COALESCE(ut.avg_flight_cost, 0) AS avg_flight_costs,
  COALESCE(ut.avg_flight_cost_before_discount, 0) AS avg_fligth_cost_before_discount,
  COALESCE(ut.avg_flight_discount, 0) AS avg_flight_discount,
  COALESCE(ut.unique_cities_visited, 0) AS unique_cities_visited,
  COALESCE(ut.total_hotel_cost, 0) AS total_hotel_cost,
  COALESCE(ut.avg_hotel_cost, 0) AS avg_hotel_cost,
  COALESCE(ut.avg_hotel_cost_before_discount, 0) AS avg_hotel_cost_before_discount,
  COALESCE(ut.avg_hotel_discount, 0) AS avg_hotel_disocunt,
  COALESCE(ut.avg_checked_bags_per_trip, 0) AS avg_checked_bags_per_trip,
  COALESCE(ut.avg_nights_per_stay, 0) AS avg_nights_per_stay,
  COALESCE(ut.avg_rooms_per_booking, 0) AS avg_rooms_per_booking,
  COALESCE(ut.avg_hotel_spend_per_night, 0) AS avg_hotel_spend_per_night
FROM users u
JOIN user_based_sessions us ON u.user_id = us.user_id
JOIN user_based_trips ut ON u.user_id = ut.user_id
;













