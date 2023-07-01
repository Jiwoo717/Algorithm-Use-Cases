-- Query aims to breakdown the Sales by the Employee ID, additionally by Location of Store.


SELECT
    -- Location information
    L.EncryptedName AS [Site],
    S.NewLocationId AS [Site ID],
    A.TransactionDate AS [Business Date],

    -- Employee information
    E.NewEmployeeId AS [Emp ID],
    CONCAT(E.FirstName, ' ', E.LastName) AS [Emp Full Name],

    -- Product information
    A.ProductCode AS [Product Code],
    P.NewProductName AS [Product Name],

    -- Aggregating sales data
    SUM(A.QuantitySold) AS [Total Quantity Sold],
    SUM(A.Revenue) AS [Total Revenue]
FROM
    MyDatabase.SalesTransactions A
    LEFT JOIN MyDatabase.Employees E
        ON A.EmployeeID = E.EmployeeID
        AND A.LocationID = E.LocationID
    LEFT JOIN MyDatabase.dbo.Locations L
        ON A.LocationID = L.LocationID
    LEFT JOIN MyDatabase.Products P
        ON A.ProductCode = P.ProductCode
        AND A.LocationID = P.LocationID
WHERE
    (A.ProductCode = 'X123' OR A.ProductCode = 'Y456')
    AND A.TransactionDate BETWEEN '2023-06-01' AND '2023-06-07'
    AND A.LocationID IN (100, 200, 300)
GROUP BY
    -- Grouping by relevant fields
    L.EncryptedName,
    S.NewLocationId,
    A.TransactionDate,
    E.NewEmployeeId,
    CONCAT(E.FirstName, ' ', E.LastName),
    A.ProductCode,
    P.NewProductName
ORDER BY
    -- Sorting by location and employee name
    S.NewLocationId,
    CONCAT(E.FirstName, ' ', E.LastName);
