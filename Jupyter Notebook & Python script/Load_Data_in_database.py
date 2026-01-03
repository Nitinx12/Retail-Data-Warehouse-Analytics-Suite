import pandas as pd
from sqlalchemy import create_engine
import os


conn_string = 'postgresql://postgres:admin@localhost/Datawarehouseanalytics'
db = create_engine(conn_string)
conn = db.connect()


files = ['customers', 'products', 'sales']
base_path = r"C:\Users\91852\Downloads\Datawarehouse"

for file in files:
    file_path = os.path.join(base_path, f"{file}.csv")
    df = pd.read_csv(file_path)   
    print(type(df))  
    df.to_sql(file, con=conn, if_exists='replace', index=False)
    print(f" Loaded {file}")
