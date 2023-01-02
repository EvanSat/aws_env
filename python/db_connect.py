import psycopg2
import pandas as pd

hostname = 'localhost'
username = 'postgres'
password = 'password'  # enter password
database = 'postgres'
port = 5432

db_connection = psycopg2.connect(host=hostname,
                                user=username,
                                password=password,
                                dbname=database,
                                port=port)

cursor = db_connection.cursor()

cursor.execute('SELECT * FROM quantrix_schema.tran_fact')
print(cursor.fetchall())
