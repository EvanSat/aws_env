import psycopg2
# import pandas as pd
from config import db_config as db_cfg


def sql_query(query: str):

    db_connection = psycopg2.connect(host=db_cfg.hostname,
                                     user=db_cfg.username,
                                     password=db_cfg.password,
                                     dbname=db_cfg.database,
                                     port=db_cfg.port)

    cursor = db_connection.cursor()
    cursor.execute(query)

    # shows the connection query
    print(cursor.fetchall())

    cursor.close()
    db_connection.commit()
    db_connection.close()
    
    return 0


# sql_query('SELECT * FROM quantrix_schema.tran_fact')

