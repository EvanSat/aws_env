import psycopg2     # Database connection
# import pandas as pd
# import numpy
from config import db_config as db_cfg


# Redshift Connection
def rs_connect():
    return psycopg2.connect(host=db_cfg.redshift_hostname,
                            user=db_cfg.redshift_username,
                            password=db_cfg.redshift_password,
                            database=db_cfg.redshift_database,
                            port=db_cfg.redshift_port)


# Local Connection for Postgres
def pg_connect():
    return psycopg2.connect(host=db_cfg.postgres_hostname,
                            user=db_cfg.postgres_username,
                            password=db_cfg.postgres_password,
                            database=db_cfg.postgres_database,
                            port=db_cfg.postgres_port)


def print_functions():
    print('Redshift Commands: \n'
          '\tredshift_query(query: string) | returns query results \n'
          '\tload_csv(file_path: string, schema.table: string) | loads given csv into target table')

    return 0


def redshift_query(query: str):
    try:
        db_connection = rs_connect()

        cur = db_connection.cursor()
        cur.execute(query)
        # result = cur.fetchall()
        db_connection.commit()

        if db_connection:
            print(f'Following query executed, closing connection | {query}')
            cur.close()
            db_connection.close()
        return 1

    except (Exception, psycopg2.Error) as error:
        print(f'Failed to run query due to: {error}')
        return -1


def load_csv(file_path: str, table_target: str):
    try:
        db_connection = rs_connect()
        cur = db_connection.cursor()

        # open the csv file using python standard file I/O
        f = open(file_path, 'r')
        cur.copy_from(f, table_target, sep=',')

        print(f'{file_path} data has been loaded onto {table_target}')
        f.close()
        cur.close()
        db_connection.close()

    except (Exception, psycopg2.Error) as error:
        print(f'Failed to run query due to1: {error}')
        return -1

    return 1

