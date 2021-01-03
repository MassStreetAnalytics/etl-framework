# Customize Deployment Scripts

Deploying the framework is as simple as running F5 on a bunch of scripts. However, you'll need to customize some scripts so they will work with your specific system.

The scripts can be found in etl-framework\Framework Deployment Scripts organized by function and named in order of their execution.

## 01 Create Initial Databases

<table>
  <thead>
    <tr>
      <th style="text-align:left">Script Name</th>
      <th style="text-align:left">Customization Instructions</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">01 CREATE DATABASE EDW</td>
      <td style="text-align:left">
        <p>Replace: [Your Data Warehouse Database Name]</p>
        <p>With: The name of your EDW.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">02 CREATE DATABASE ODS</td>
      <td style="text-align:left">None.</td>
    </tr>
    <tr>
      <td style="text-align:left">03 CREATE DATABASE Reporting</td>
      <td style="text-align:left">None.</td>
    </tr>
    <tr>
      <td style="text-align:left">04 CREATE DATABASE SSISManagement</td>
      <td style="text-align:left">None.</td>
    </tr>
    <tr>
      <td style="text-align:left">05 CREATE INITIAL SCHEMAS</td>
      <td style="text-align:left">
        <p>Replace: [Your Data Warehouse Database Name]</p>
        <p>With: The name of your EDW.</p>
      </td>
    </tr>
  </tbody>
</table>

## 02 Date Dimension

| Script Name | Customization Instructions |
| :--- | :--- |
| 01 CREATE AND POPULATE DimMonth AND DimDate | Detailed instructions in script. |
| 02 add empty and error rows | Replace \[YourDatabaseName\] with the specific name of your EDW and run.03 ALTER TABLE DimDate ADD FiscalColumns |
| Detailed instructions in script. | Detailed instructions in script. |

## 03 Framework Objects

| Script Name | Customization Instructions |
| :--- | :--- |
| 01 Create ETL Framework Tables | None. |
| 02 CREATE TABLE TableLoadReport | None. |
| 03 Create ETL Framework Stored Procs | None. |
| 04 CREATE PROC usp\_ErrorLogByPackage | None. |
| 05 CREATE PROC usp\_BatchRunTime | None. |
| 06 CREATE PROC usp\_ErrorLogByBatch | None. |
| 07 CREATE PROC usp\_GetVariableValues | None. |
| 08 CREATE PROC PackageRunTime | None. |
| 09 CREATE TABLE SSISConfigurations | None. |
| 10 CREATE VIEW RowCountLog | None. |
| 11 CREATE VIEW ShowAdverseTableLoads | None. |
| 12 CREATE VIEW SSISErrorLogByPackage | None. |
| 13 CREATE VIEW SSISPackageBatchRunTime | None. |
| 14 CREATE VIEW SSISPackageRunTime | None. |
| 15 CREATE FUNCTION udf\_CleanDate | None. |
| 16 CREATE TABLE LoadObservations | None. |
| 17 CREATE TABLE Tables | None. |

## 04 Python Package Installation

| Script Name | Customization Instructions |
| :--- | :--- |
| InstallFrameworkPackages | None |

