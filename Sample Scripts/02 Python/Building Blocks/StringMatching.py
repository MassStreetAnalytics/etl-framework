from fuzzywuzzy import fuzz
from fuzzywuzzy import process
import sys
import pandas as pd
import pyodbc as db

try:
    print("Connecting to SQL Server database")
    connection_string = 'DSN=ETL;'
    conn = db.connect(connection_string)
    csr = conn.cursor()
    sql = "SELECT TOP 100 CONCAT([FirstName], '|', [MiddleName], '|', [LastName]) AS String FROM DimCustomer"
    sql2 = "SELECT TOP 100 CONCAT([FirstName], '|', [MiddleName], '|', [LastName]) AS String FROM DimCustomer ORDER BY NEWID()"
    df1 = pd.read_sql(sql,conn)
    df2 = pd.read_sql(sql2,conn)
    conn.commit()
    csr.close()
    conn.close()
except:
    sys.exit("ERROR: Unable to query table or write file")

#print(df1['String'])

def fuzzywuzzy_match(x, choices, scorer, cutoff):
    return process.extractOne(x, choices=choices, scorer=scorer, score_cutoff=cutoff)

FuzzyWuzzyResults = df1['String'].apply(fuzzywuzzy_match, args=(df2['String'], fuzz.token_set_ratio, 90))

print(FuzzyWuzzyResults)