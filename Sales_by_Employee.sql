SELECT
    L.EncryptedName AS [Site],
    S.NewLocationId AS [Site ID],
    A.TransactionDate AS [Business Date],
    E.NewEmployeeId AS [Emp ID],
    CONCAT(E.FirstName, ' ', E.LastName) AS [Emp Full Name],
    A.ProductCode AS [Product Code],
    P.NewProductName AS [Product Name],
    SUM(A.QuantitySold) AS [Total Quantity Sold],
    SUM(A.Revenue) AS [Total Revenue]
FROM
    MyDatabase.dbo.SalesTransactions A
    LEFT JOIN MyDatabase.dbo.Employees E
        ON A.EmployeeID = E.EmployeeID
        AND A.LocationID = E.LocationID
    LEFT JOIN MyDatabase.dbo.Locations L
        ON A.LocationID = L.LocationID
    LEFT JOIN MyDatabase.dbo.Products P
        ON A.ProductCode = P.ProductCode
        AND A.LocationID = P.LocationID
WHERE
    (A.ProductCode = 'X123' OR A.ProductCode = 'Y456')
    AND A.TransactionDate BETWEEN '2023-06-01' AND '2023-06-07'
    AND A.LocationID IN (100, 200, 300)
GROUP BY
    L.EncryptedName,
    S.NewLocationId,
    A.TransactionDate,
    E.NewEmployeeId,
    CONCAT(E.FirstName, ' ', E.LastName),
    A.ProductCode,
    P.NewProductName
ORDER BY
    S.NewLocationId,
    CONCAT(E.FirstName, ' ', E.LastName);
