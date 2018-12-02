/*
Create an insert statement for every variable that you create as a configuration value.
The PackageName is the name of the package MINUS the package extension.
PackageName functions as a filter that you select your variables on.
*/

USE SSISManagement

--Substitute the name of your package.

DELETE FROM SSISConfigurations
WHERE PackageName = 'Package'

INSERT INTO SSISConfigurations(PackageName, VariableName, VariableValue)
SELECT 'Package', 'strVariable1', 'NewValue'
UNION ALL
SELECT 'Package', 'intVariable2', '1000'