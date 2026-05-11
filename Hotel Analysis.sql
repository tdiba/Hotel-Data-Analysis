
-- 1. Create a clean analysis view with corrected data types

CREATE VIEW hotel_bookings_analysis_clean AS
SELECT
    TRY_CAST(is_canceled AS INT) AS is_canceled,
    TRY_CAST(lead_time AS INT) AS lead_time,
    TRY_CAST(arrival_date_week_number AS INT) AS arrival_date_week_number,
    TRY_CAST(arrival_date_day_of_month AS INT) AS arrival_date_day_of_month,
    TRY_CAST(arrival_date_month AS INT) AS arrival_date_month,
    TRY_CAST(stays_in_weekend_nights AS INT) AS stays_in_weekend_nights,
    TRY_CAST(stays_in_week_nights AS INT) AS stays_in_week_nights,
    TRY_CAST(adults AS INT) AS adults,
    TRY_CAST(children AS FLOAT) AS children,
    TRY_CAST(babies AS INT) AS babies,
    TRY_CAST(is_repeated_guest AS INT) AS is_repeated_guest,
    TRY_CAST(previous_cancellations AS INT) AS previous_cancellations,
    TRY_CAST(previous_bookings_not_canceled AS INT) AS previous_bookings_not_canceled,
    TRY_CAST(required_car_parking_spaces AS INT) AS required_car_parking_spaces,
    TRY_CAST(total_of_special_requests AS INT) AS total_of_special_requests,
    TRY_CAST(avg_daily_rate AS FLOAT) AS avg_daily_rate,
    TRY_CAST(booked_by_company AS INT) AS booked_by_company,
    TRY_CAST(booked_by_agent AS INT) AS booked_by_agent,
    TRY_CAST(hotel_City AS INT) AS hotel_City,
    TRY_CAST(hotel_Resort AS INT) AS hotel_Resort,
    TRY_CAST(meal_BB AS INT) AS meal_BB,
    TRY_CAST(meal_FB AS INT) AS meal_FB,
    TRY_CAST(meal_HB AS INT) AS meal_HB,
    TRY_CAST(meal_No_meal AS INT) AS meal_No_meal,
    TRY_CAST(market_segment_Aviation AS INT) AS market_segment_Aviation,
    TRY_CAST(market_segment_Complementary AS INT) AS market_segment_Complementary,
    TRY_CAST(market_segment_Corporate AS INT) AS market_segment_Corporate,
    TRY_CAST(market_segment_Direct AS INT) AS market_segment_Direct,
    TRY_CAST(market_segment_Groups AS INT) AS market_segment_Groups,
    TRY_CAST(market_segment_Offline_TA_TO AS INT) AS market_segment_Offline_TA_TO,
    TRY_CAST(market_segment_Online_TA AS INT) AS market_segment_Online_TA,
    TRY_CAST(market_segment_Undefined AS INT) AS market_segment_Undefined,
    TRY_CAST(distribution_channel_Corporate AS INT) AS distribution_channel_Corporate,
    TRY_CAST(distribution_channel_Direct AS INT) AS distribution_channel_Direct,
    TRY_CAST(distribution_channel_GDS AS INT) AS distribution_channel_GDS,
    TRY_CAST(distribution_channel_TA_TO AS INT) AS distribution_channel_TA_TO,
    TRY_CAST(distribution_channel_Undefined AS INT) AS distribution_channel_Undefined,
    TRY_CAST(reserved_room_type_A AS INT) AS reserved_room_type_A,
    TRY_CAST(reserved_room_type_B AS INT) AS reserved_room_type_B,
    TRY_CAST(reserved_room_type_C AS INT) AS reserved_room_type_C,
    TRY_CAST(reserved_room_type_D AS INT) AS reserved_room_type_D,
    TRY_CAST(reserved_room_type_E AS INT) AS reserved_room_type_E,
    TRY_CAST(reserved_room_type_F AS INT) AS reserved_room_type_F,
    TRY_CAST(reserved_room_type_G AS INT) AS reserved_room_type_G,
    TRY_CAST(reserved_room_type_H AS INT) AS reserved_room_type_H,
    TRY_CAST(reserved_room_type_L AS INT) AS reserved_room_type_L,
    TRY_CAST(deposit_type_No_Deposit AS INT) AS deposit_type_No_Deposit,
    TRY_CAST(deposit_type_Non_Refund AS INT) AS deposit_type_Non_Refund,
    TRY_CAST(deposit_type_Refundable AS INT) AS deposit_type_Refundable,
    TRY_CAST(customer_type_Contract AS INT) AS customer_type_Contract,
    TRY_CAST(customer_type_Group AS INT) AS customer_type_Group,
    TRY_CAST(customer_type_Transient AS INT) AS customer_type_Transient,
    TRY_CAST([customer_type_Transient-Party] AS INT) AS [customer_type_Transient-Party]
FROM hotel_bookings_clean
GO
-----------------------------------------------------------------------------------------------------------------------------------------

-- 2. DATA EXPLORATION
-- 2.1. Total Records

SELECT COUNT(*) AS total_records
FROM hotel_bookings_analysis_clean

-- Shows the total number of bookings in the dataset


-- 2.2. Cancellation Counts
-- 0 = Not canceled
-- 1 = Canceled

SELECT 
    is_canceled,
    COUNT(*) AS total_bookings
FROM hotel_bookings_analysis_clean
GROUP BY is_canceled


-- 2.3. Cancellation Rate
-- Calculates the percentage of bookings that were canceled

SELECT 
    ROUND(
        SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100,
        2
    ) AS cancellation_rate_percentage
FROM hotel_bookings_analysis_clean

------------------------------------------------------------------------------------------------------------------------------------------
-- 3. HOTEL PERFORMANCE ANALYSIS

-- 3.1 City Hotel vs Resort Hotel Bookings
-- Compares booking volume between city and resort hotels

SELECT 
    SUM(hotel_City) AS city_hotel_bookings,
    SUM(hotel_Resort) AS resort_hotel_bookings
FROM hotel_bookings_analysis_clean


-- 3.2. Cancellation Rate by Hotel Type
-- Shows which hotel type has the higher cancellation rate

SELECT 
    CASE
        WHEN hotel_City = 1 THEN 'City Hotel'
        WHEN hotel_Resort = 1 THEN 'Resort Hotel'
        ELSE 'Unknown'
    END AS hotel_type,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2) AS cancellation_rate_percentage
FROM hotel_bookings_analysis_clean
GROUP BY 
    CASE
        WHEN hotel_City = 1 THEN 'City Hotel'
        WHEN hotel_Resort = 1 THEN 'Resort Hotel'
        ELSE 'Unknown'
    END

-----------------------------------------------------------------------------------------------------------------------------------------

-- 4. REVENUE ANALYSIS
-- 4.1. Estimated Revenue from Completed Bookings
-- Estimated revenue = average daily rate * total nights stayed
-- Only non-canceled bookings are included

SELECT 
    ROUND(
        SUM(avg_daily_rate * (stays_in_week_nights + stays_in_weekend_nights)),
        2
    ) AS estimated_revenue
FROM hotel_bookings_analysis_clean
WHERE is_canceled = 0


-- 4.2. Average Daily Rate by Hotel Type
-- Compares average daily room price by hotel type

SELECT 
    CASE
        WHEN hotel_City = 1 THEN 'City Hotel'
        WHEN hotel_Resort = 1 THEN 'Resort Hotel'
        ELSE 'Unknown'
    END AS hotel_type,
    ROUND(AVG(avg_daily_rate), 2) AS average_daily_rate
FROM hotel_bookings_analysis_clean
GROUP BY 
    CASE
        WHEN hotel_City = 1 THEN 'City Hotel'
        WHEN hotel_Resort = 1 THEN 'Resort Hotel'
        ELSE 'Unknown'
    END


-- 4.3. Revenue by Hotel Type
-- Shows estimated revenue by hotel type

SELECT 
    CASE
        WHEN hotel_City = 1 THEN 'City Hotel'
        WHEN hotel_Resort = 1 THEN 'Resort Hotel'
        ELSE 'Unknown'
    END AS hotel_type,
    ROUND(
        SUM(avg_daily_rate * (stays_in_week_nights + stays_in_weekend_nights)),
        2
    ) AS estimated_revenue
FROM hotel_bookings_analysis_clean
WHERE is_canceled = 0
GROUP BY 
    CASE
        WHEN hotel_City = 1 THEN 'City Hotel'
        WHEN hotel_Resort = 1 THEN 'Resort Hotel'
        ELSE 'Unknown'
    END

------------------------------------------------------------------------------------------------------------------------------------------

-- 5. CUSTOMER ANALYSIS

-- 5.1. New Guests vs Repeated Guests
-- 0 = New guest
-- 1 = Repeated guest

SELECT 
    is_repeated_guest,
    COUNT(*) AS total_bookings
FROM hotel_bookings_analysis_clean
GROUP BY is_repeated_guest


-- 5.2. Cancellation Rate by Guest Type
-- Compares cancellation behavior between new and repeated guests

SELECT 
    CASE
        WHEN is_repeated_guest = 1 THEN 'Repeated Guest'
        ELSE 'New Guest'
    END AS guest_type,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2) AS cancellation_rate_percentage
FROM hotel_bookings_analysis_clean
GROUP BY 
    CASE
        WHEN is_repeated_guest = 1 THEN 'Repeated Guest'
        ELSE 'New Guest'
    END

-----------------------------------------------------------------------------------------------------------------------------------------

-- 6. LEAD TIME ANALYSIS:

-- 6.1. Average Lead Time
-- Shows how many days in advance customers booked on average

SELECT 
    ROUND(AVG(CAST(lead_time AS FLOAT)), 2) AS average_lead_time
FROM hotel_bookings_analysis_clean


-- 6.2. Lead Time by Cancellation Status
-- Checks whether canceled bookings had longer lead times

SELECT 
    CASE
        WHEN is_canceled = 1 THEN 'Canceled'
        ELSE 'Not Canceled'
    END AS booking_status,
    ROUND(AVG(CAST(lead_time AS FLOAT)), 2) AS average_lead_time
FROM hotel_bookings_analysis_clean
GROUP BY 
    CASE
        WHEN is_canceled = 1 THEN 'Canceled'
        ELSE 'Not Canceled'
    END

------------------------------------------------------------------------------------------------------------------------------------------

-- 7. GUEST COMPOSITION ANALYSIS:

-- 7.1. -- Shows the total number of adults, children, and babies in the bookings

SELECT 
    SUM(adults) AS total_adults,
    SUM(children) AS total_children,
    SUM(babies) AS total_babies
FROM hotel_bookings_analysis_clean


-- 7.2. Average Group Size
-- Calculates the average number of guests per booking

SELECT 
    ROUND(AVG(CAST(adults + children + babies AS FLOAT)), 2) AS average_group_size
FROM hotel_bookings_analysis_clean

-----------------------------------------------------------------------------------------------------------------------------------------

-- 8. MARKET SEGMENT ANALYSIS:

-- 8.1. Market Segment Distribution
-- Shows where bookings came from

SELECT 
    SUM(market_segment_Online_TA) AS online_travel_agents,
    SUM(market_segment_Offline_TA_TO) AS offline_travel_agents,
    SUM(market_segment_Direct) AS direct_bookings,
    SUM(market_segment_Corporate) AS corporate_bookings,
    SUM(market_segment_Groups) AS group_bookings,
    SUM(market_segment_Aviation) AS aviation_bookings,
    SUM(market_segment_Complementary) AS complementary_bookings,
    SUM(market_segment_Undefined) AS undefined_bookings
FROM hotel_bookings_analysis_clean


-- 8.2. Cancellation Rate by Market Segment

-- Compares cancellation rates across major market segments

SELECT 'Online TA' AS market_segment,
       COUNT(*) AS total_bookings,
       SUM(is_canceled) AS canceled_bookings,
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2) AS cancellation_rate_percentage
FROM hotel_bookings_analysis_clean
WHERE market_segment_Online_TA = 1

UNION ALL

SELECT 'Offline TA/TO', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE market_segment_Offline_TA_TO = 1

UNION ALL

SELECT 'Direct', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE market_segment_Direct = 1

UNION ALL

SELECT 'Corporate', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE market_segment_Corporate = 1

UNION ALL

SELECT 'Groups', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE market_segment_Groups = 1

----------------------------------------------------------------------------------------------------------------------------------------

-- 9. ROOM TYPE ANALYSIS:

-- 9.1. Most Popular Reserved Room Type
-- Shows which room type was reserved most often

SELECT 'Room A' AS room_type, SUM(reserved_room_type_A) AS total_bookings FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room B', SUM(reserved_room_type_B) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room C', SUM(reserved_room_type_C) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room D', SUM(reserved_room_type_D) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room E', SUM(reserved_room_type_E) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room F', SUM(reserved_room_type_F) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room G', SUM(reserved_room_type_G) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room H', SUM(reserved_room_type_H) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Room L', SUM(reserved_room_type_L) FROM hotel_bookings_analysis_clean
ORDER BY total_bookings DESC

-----------------------------------------------------------------------------------------------------------------------------------------

-- 10. BOOKING BEHAVIOUR ANALYSIS:

-- 10.1. Average Special Requests
-- Shows the average number of special requests per booking

SELECT 
    ROUND(AVG(CAST(total_of_special_requests AS FLOAT)), 2) AS average_special_requests
FROM hotel_bookings_analysis_clean


-- 10.2. Parking Demand
-- Shows total parking spaces requested

SELECT 
    SUM(required_car_parking_spaces) AS total_parking_requests
FROM hotel_bookings_analysis_clean


-- 10.3. Special Requests vs Cancellation Rate
-- Tests whether guests with special requests cancel less often

SELECT 
    CASE
        WHEN total_of_special_requests = 0 THEN 'No Special Requests'
        ELSE 'Has Special Requests'
    END AS request_category,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS canceled_bookings,
    ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2) AS cancellation_rate_percentage
FROM hotel_bookings_analysis_clean
GROUP BY 
    CASE
        WHEN total_of_special_requests = 0 THEN 'No Special Requests'
        ELSE 'Has Special Requests'
    END

-----------------------------------------------------------------------------------------------------------------------------------------

-- 11. SEASONAL ANALYSIS:

-- 11.1. Monthly Booking Trends
-- Shows booking volume by month

SELECT 
    arrival_date_month,
    COUNT(*) AS total_bookings
FROM hotel_bookings_analysis_clean
GROUP BY arrival_date_month
ORDER BY arrival_date_month


-- 11.2. Monthly Revenue Trends
-- Shows estimated monthly revenue from completed bookings

SELECT 
    arrival_date_month,
    ROUND(
        SUM(avg_daily_rate * (stays_in_week_nights + stays_in_weekend_nights)),
        2
    ) AS estimated_monthly_revenue
FROM hotel_bookings_analysis_clean
WHERE is_canceled = 0
GROUP BY arrival_date_month
ORDER BY arrival_date_month

----------------------------------------------------------------------------------------------------------------------------------------

-- 12. DEPOSIT TYPE ANALYSIS:

-- 12.1. Deposit Type Distribution
-- Shows how many bookings used each deposit type

SELECT 'No Deposit' AS deposit_type, SUM(deposit_type_No_Deposit) AS total_bookings FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Non Refund', SUM(deposit_type_Non_Refund) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Refundable', SUM(deposit_type_Refundable) FROM hotel_bookings_analysis_clean
ORDER BY total_bookings DESC


-- 12.2. Cancellation Rate by Deposit Type
-- Shows how deposit type relates to cancellations

SELECT 'No Deposit' AS deposit_type,
       COUNT(*) AS total_bookings,
       SUM(is_canceled) AS canceled_bookings,
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2) AS cancellation_rate_percentage
FROM hotel_bookings_analysis_clean
WHERE deposit_type_No_Deposit = 1

UNION ALL

SELECT 'Non Refund', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE deposit_type_Non_Refund = 1

UNION ALL

SELECT 'Refundable', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE deposit_type_Refundable = 1

-------------------------------------------------------------------------------------------------------------------------------------------

-- 13. CUSTOMER TYPE ANALYSIS:

-- 13.1. Customer Type Distribution
-- Shows the main customer types

SELECT 'Contract' AS customer_type, SUM(customer_type_Contract) AS total_bookings FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Group', SUM(customer_type_Group) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Transient', SUM(customer_type_Transient) FROM hotel_bookings_analysis_clean
UNION ALL
SELECT 'Transient-Party', SUM([customer_type_Transient-Party]) FROM hotel_bookings_analysis_clean
ORDER BY total_bookings DESC


-- 13.2. Cancellation Rate by Customer Type
-- Compares cancellation rates by customer type

SELECT 'Contract' AS customer_type,
       COUNT(*) AS total_bookings,
       SUM(is_canceled) AS canceled_bookings,
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2) AS cancellation_rate_percentage
FROM hotel_bookings_analysis_clean
WHERE customer_type_Contract = 1

UNION ALL

SELECT 'Group', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE customer_type_Group = 1

UNION ALL

SELECT 'Transient', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE customer_type_Transient = 1

UNION ALL

SELECT 'Transient-Party', COUNT(*), SUM(is_canceled),
       ROUND(SUM(CAST(is_canceled AS FLOAT)) / COUNT(*) * 100, 2)
FROM hotel_bookings_analysis_clean
WHERE [customer_type_Transient-Party] = 1