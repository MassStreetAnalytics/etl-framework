# SSIS

There is a standard template package. Use that as the starting point for any ETL that requires SSIS as lined out in the section above. Most of the standards are already built in to that package. As you continue to build out your process, keep the following in mind:

1. Attempt to reduce the number of hard coded values to zero in your package. Place any configurations in the configuration table.
2. Attempt to name variables following the example conventions in the package.
3. The package has two parameters currently for moving files. Be sure to use them and connect them to the Global environment.
4. Do not put non-trivial SQL statements in your packages. If your code is longer than three lines, turn it into a stored procedure and call that instead.
5. Script task need to be developed using C\#.

