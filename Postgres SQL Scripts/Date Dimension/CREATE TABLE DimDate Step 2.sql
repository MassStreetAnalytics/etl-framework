--Make all the adjustments
DELETE
FROM dw.dimdate 
WHERE LEFT(CAST(dateck AS VARCHAR(8)),4) = '0229'