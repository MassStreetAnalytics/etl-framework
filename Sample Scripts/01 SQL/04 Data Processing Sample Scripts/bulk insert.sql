--Insert into the view
BULK INSERT YourSchema.YourTable
FROM 'E:\YourFileName.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a',
FIRSTROW = 2
);