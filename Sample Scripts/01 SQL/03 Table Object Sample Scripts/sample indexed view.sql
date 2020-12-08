USE EDW


GO

CREATE VIEW DimDeclarantISO
 
WITH SCHEMABINDING  
AS  
SELECT
[PartnerCK] AS DeclarantISOCK,
[CountryName]
FROM [dw].[DimPartner]
GO  
--Create an index on the view.  
CREATE UNIQUE CLUSTERED INDEX CIDX_DimDeclarantISO_PartnerCK ON DimDeclarantISO(DeclarantISOCK);  
GO  
