import pandas as pd
import random
import datetime


product_name = {'Apple': ['iphone11', 'iphone12', 'iphone13', 'iphoneSE', 'IpadMax', 'IpadMini', 'laptop256',
                          'Macbook512'],
                'Samsung': ['galaxy10', 'galaxy11', 'galaxy12', 'galaxy13', 'watch320', 'watch340'],
                'Nokia': ['Nk320', 'Nk400', 'Nk500']}

# Easiest to hard code for training purposes
product_costs = {'iphone11': 800, 'iphone12': 900, 'iphone13': 950, 'iphoneSE': 700, 'IpadMax': 500, 'IpadMini': 400,
                 'laptop256': 1400, 'Macbook512': 1600, 'galaxy10': 800, 'galaxy11': 850, 'galaxy12': 875,
                 'galaxy13': 900, 'watch320': 249, 'watch340': 300, 'Nk320': 600, 'Nk400': 700, 'Nk500': 750}

start_date = datetime.datetime(2020, 1, 1)
end_date = datetime.datetime(2022, 12, 31)


def random_date(start: datetime, end: datetime):
    diff = datetime.timedelta(days=(end - start).days)
    rae = random.random() * diff
    return start + datetime.timedelta(days=rae.days)


def generate_dummy_info(record_count: int):
    print(f'Generating {record_count} records')
    ran_data = []

    for i in range(1, record_count+1):
        order_id = f'{i:07}'
        brand = random.choice(list(product_name.keys()))
        product = random.choice(product_name[brand])
        sales_amt = round(product_costs[product] * (random.randint(80, 120)/100), 2)
        sales_date = random_date(start_date, end_date)
        ran_data.append((order_id, brand, product, sales_amt, sales_date))
    print(ran_data)

    return ran_data


if __name__ == '__main__':
    # record_num_request = 50000
    record_num_request = int(input('Enter number of records to request: '))
    df = pd.DataFrame(generate_dummy_info(record_num_request), columns=['order_id', 'brand_name', 'product_name',
                                                                        'sales_amount', 'sales_date'])
    df.to_csv('order_data_20230113.csv', index=False)
