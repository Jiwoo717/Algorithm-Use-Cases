-- Snowflake Queries: Listed will be the questions we want to answer along with my queries.

-- We have a number of revenue sources in our db, segment our average payments by source.
    --Average Order Value by Source
    WITH DistinctOrders AS (
        SELECT DISTINCT EXTERNAL_ORDER_ID, ORDER_SOURCE, TOTALS
        FROM WISELY_WAREHOUSE.WISELY_SHARE_V2.ORDERS
        WHERE TIME_PLACED BETWEEN '2022-11-01' AND '2023-10-01'
    )

    SELECT
        ORDER_SOURCE,
        AVG(TOTALS:"total"::FLOAT) AS avg_order_value
    FROM
        DistinctOrders
    GROUP BY
        ORDER_SOURCE;
