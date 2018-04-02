import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv('ZACKS-MT.csv')
engine = create_engine('mssql+pyodbc://Test')

with engine.connect() as conn, conn.begin():
    df.to_sql(name='test', con=engine, if_exists='replace', index=False)
    df2 = pd.read_sql_query('SELECT * FROM Test', conn)
    print(df.equals(df2))




