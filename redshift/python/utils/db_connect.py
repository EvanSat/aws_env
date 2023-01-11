import psycopg2
import pandas as pd
from config import db_config as db_cfg
import datetime
import random


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

        if db_connection:
            cursor.close()
            db_connection.close()
    except (Exception, psycopg2.Error) as error:
        print(f'Failed to run query due to: {error}')


def generate_dummy_csv(record_count: int, file_name_output: str):
    brand_name = ['Apple', 'Samsung', 'Nokia']
    product_name = {'Apple': ['iphone11', 'iphone12', 'iphone13', 'iphoneSE', 'IpadMax', 'IpadMini', 'laptop256',
                              'Macbook512'],
                    'Samsung': ['galaxy10', 'galaxy11', 'galaxy12', 'galaxy13', 'watch320', 'watch340'],
                    'Nokia': ['Nk320', 'Nk400', 'Nk500']}
    start_date = datetime.datetime(2018, 5, 1)
    end_date = datetime.datetime(2020, 5, 1)

    def random_date(start: datetime, end: datetime):
        diff = datetime.timedelta(days=(end - start).days)
        rae = random.random() * diff
        return start + datetime.timedelta(days=rae.days)

    print(f'Generating {record_count} record(s) | id, brand, product, sales ammount, sales date')
    ran_data = []

    for i in range(0, record_count):
        id_start = f"{i+1:07}"
        brand = random.choice(brand_name)  # random brand name from the list
        product = random.choice(product_name[brand])
        sales_amnt = (random.randint(0, 9999999))/100
        sales_date = random_date(start_date, end_date)
        ran_data.append((id_start, brand, product, sales_amnt, sales_date))

    df = pd.DataFrame(ran_data, columns=['order_id', 'brand_name', 'product_name', 'sales_amount', 'sales_date'])
    df.to_csv(file_name_output, index=False)


def load_csv(file_name: str, table_name: str):
    sql_query(f'COPY {table_name} FROM {file_name} DELIMITER \',\' CSV HEADER;')


sql_query('SELECT * FROM quantrix_schema.tran_fact')

