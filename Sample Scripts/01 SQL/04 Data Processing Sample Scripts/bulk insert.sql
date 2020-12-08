--Insert into the view
BULK INSERT FlightsStaging
FROM 'E:\flights.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a',
FIRSTROW = 2
);