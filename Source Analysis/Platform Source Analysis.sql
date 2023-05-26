-- Snowflake Queries: Listed will be the questions we want to answer along with my queries.

-- We have a number of revenue sources in our db, segment our average payments by source.
    --Average Order Value by Source
    WITH DistinctOrders AS (
        SELECT DISTINCT EXTERNAL_ORDER_ID, ORDER_SOURCE, TOTALS
        FROM WAREHOUSE.ORDERS
        WHERE TIME_PLACED BETWEEN '2022-11-01' AND '2023-10-01'
    )

    SELECT
        ORDER_SOURCE,
        AVG(TOTALS:"total"::FLOAT) AS avg_order_value
    FROM
        DistinctOrders
    GROUP BY
        ORDER_SOURCE;


-- Get the Total Payments by Month using the same segmentation (Source)
    -- Total Payments Monthly by Source
    WITH DistinctOrders AS (
    SELECT DISTINCT EXTERNAL_ORDER_ID, ORDER_SOURCE, PAYMENTS, TIME_PLACED
    FROM WAREHOUSE.ORDERS
    WHERE TIME_PLACED BETWEEN '2023-1-01' AND '2023-05-01'
)

, PaymentsFlattened AS (
    SELECT
        ORDER_SOURCE,
        EXTRACT(MONTH FROM TIME_PLACED) AS month,
        EXTRACT(YEAR FROM TIME_PLACED) AS year,
        PAYMENT.value:"amount"::FLOAT AS payment_amount
    FROM
        DistinctOrders,
        LATERAL FLATTEN(input => DistinctOrders.PAYMENTS) AS PAYMENT
)

SELECT
    ORDER_SOURCE,
    month,
    year,
    TO_VARCHAR(month, '00') || '-' || TO_VARCHAR(year) AS business_date,
    SUM(payment_amount) AS total_payments
FROM
    PaymentsFlattened
GROUP BY
    ORDER_SOURCE, month, year
ORDER BY
    ORDER_SOURCE, year, month;
