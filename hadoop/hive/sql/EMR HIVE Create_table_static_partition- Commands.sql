--*******************************************************************************************
--USING PUTTY to execute commands--

hive

set hive.execution.engine=tez;

set hivevar:src_schema=src_customer2;
use ${hivevar:src_schema};

/*
Here we are creating hive table with static partitions.
Load date is partition col.
*/

create table if not exists customer_details_source_partitions
(
account_id varchar(50),
account_open_dt varchar(50),
account_id_type varchar(10),
acct_hldr_primary_addr_state varchar(20),
acct_hldr_primary_addr_zip_cd varchar(20),
acct_hldr_first_name varchar(20),
acct_hldr_last_name varchar(20),
dataset_date varchar(50))
partitioned by (load_date varchar(10))
row format delimited fields terminated by ','
location "s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/"
tblproperties ("skip.header.line.count"="1") ;

-- Command to describe table structure
desc formatted customer_details_source_partitions ;

-- see the partitions
show partitions customer_details_source_partitions;

-- Static Partitions to be added manually. Its alter table command. [ load_date=2022-01-02 ]

alter table customer_details_source_partitions add partition (load_date='2022-01-02');

aws s3 cp s3://quintrix-cust-data/cards_account_ingest_2022-01-02.csv s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/load_date='2022-01-02'/

select count(1),load_date from customer_details_source_partitions group by load_date ;
+-------+-------------+
|  _c0  |  load_date  |
+-------+-------------+
| 4999  | 2022-01-02  |
+-------+-------------+

-- Static Partitions to be added manually. Its alter table command. [ load_date=2022-01-03 ]
alter table customer_details_source_partitions add partition (load_date='2022-01-03');


show partitions customer_details_source_partitions;
select count(1),load_date from customer_details_source_partitions group by load_date ;
+-------+-------------+
|  _c0  |  load_date  |
+-------+-------------+
| 4999  | 2022-01-02  |
+-------+-------------+
aws s3 cp s3://quintrix-cust-data/cards_account_ingest_2022-01-03.csv s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/load_date='2022-01-03'/

select count(1),load_date from customer_details_source_partitions group by load_date ;
+-------+-------------+
|  _c0  |  load_date  |
+-------+-------------+
| 4999  | 2022-01-02  |
| 1000  | 2022-01-03  |
+-------+-------------+



--How to automate

#!/bin/bash
data_location=$(hive -e "set hive.cli.print.header=false; select get_json_object(location_info,'$.s3Location') from data_location")

#get partition name
partition=$(basename ${data_location})

#Create partition in your target table:
hive -e "ALTER TABLE TARGET_TABLE ADD IF NOT EXISTS PARTITION (datePublished='${partition}') LOCATION '${data_location}'"

ALTER TABLE mydata
ADD PARTITION (country='south-africa', date='20191024')
LOCATION 's3://mydata/south-africa/20191024/';

