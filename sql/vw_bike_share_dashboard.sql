CREATE OR ALTER VIEW vw_bike_share_dashboard AS
WITH cte AS (
    SELECT *
    FROM bike_share_yr_0
    UNION ALL
    SELECT *
    FROM bike_share_yr_1
)

SELECT 
    a.dteday,
    a.season,
    CASE 
        WHEN a.season = 1 THEN 'Winter'
        WHEN a.season = 2 THEN 'Spring'
        WHEN a.season = 3 THEN 'Summer'
        WHEN a.season = 4 THEN 'Fall'
    END AS season_name,

    a.yr,
    a.weekday,
    a.hr,
    a.rider_type,
    a.riders,

    b.price,
    b.COGS,

    -- Revenue per row
    (a.riders * b.price) AS revenue,

    -- Profit per row (per-ride COGS)
    (a.riders * (b.price - b.COGS)) AS profit,

    -- Additional dashboard-friendly fields
    (b.price - b.COGS) AS profit_per_ride,
    (a.temp * 41)      AS temp_celsius,
    (a.atemp * 50)     AS feels_like_celsius,
    (a.hum * 100)      AS humidity_pct,
    (a.windspeed * 67) AS windspeed_kph

FROM cte AS a
LEFT JOIN cost_table AS b
    ON a.yr = b.yr;
