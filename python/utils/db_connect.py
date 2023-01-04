import psycopg2
# import pandas as pd
from config import db_config as db_cfg


def sql_query(query: str):
    try:
        db_connection = psycopg2.connect(host=db_cfg.hostname,
                                         user=db_cfg.username,
                                         password=db_cfg.password,
                                         dbname=db_cfg.database,
                                         port=db_cfg.port)

        cursor = db_connection.cursor()
        cursor.execute(query)

        # shows the connection query
        print(cursor.fetchall())
        db_connection.commit()
    except (Exception, psycopg2.Error) as error:
        print(f'Failed to run query due to: {error}')

    finally:
        if db_connection:
            cursor.close()
            db_connection.close()


# sql_query('SELECT * FROM quantrix_schema.tran_fact')

