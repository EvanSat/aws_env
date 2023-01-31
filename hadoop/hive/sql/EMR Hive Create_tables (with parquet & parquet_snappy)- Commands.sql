--*******************************************************************************************
--USING PUTTY to execute commands--

hive

create database src_customer2
location "s3://quintrix-cust-data/data/src_customer";

set hivevar:src_schema=src_customer2;
use ${hivevar:src_schema};

create table if not exists customer_details
(
account_id varchar(50),
account_open_dt varchar(50),
account_id_type varchar(10),
acct_hldr_primary_addr_state varchar(20),
acct_hldr_primary_addr_zip_cd varchar(20),
acct_hldr_first_name varchar(20),
acct_hldr_last_name varchar(20),
dataset_date varchar(50))
row format delimited fields terminated by ','
location "s3://quintrix-cust-data/data/src_customer/customer_details/"
tblproperties ("skip.header.line.count"="1")
;

aws s3 cp s3://quintrix-cust-data/cards_account_ingest_2022-01-02.csv s3://quintrix-cust-data/data/src_customer/customer_details/

create table if not exists customer_details_parquet
(
account_id varchar(50),
account_open_dt varchar(50),
account_id_type varchar(10),
acct_hldr_primary_addr_state varchar(20),
acct_hldr_primary_addr_zip_cd varchar(20),
acct_hldr_first_name varchar(20),
acct_hldr_last_name varchar(20),
dataset_date varchar(50))
stored as parquet
location "s3://quintrix-cust-data/data/src_customer/customer_details_parquet/"
;

select * from customer_details_parquet limit 5;

create table if not exists customer_details_parquet_snappy
(
account_id varchar(50),
account_open_dt varchar(50),
account_id_type varchar(10),
acct_hldr_primary_addr_state varchar(20),
acct_hldr_primary_addr_zip_cd varchar(20),
acct_hldr_first_name varchar(20),
acct_hldr_last_name varchar(20),
dataset_date varchar(50))
stored as parquet
location "s3://quintrix-cust-data/data/src_customer/customer_details_parquet_snappy/"
TBLPROPERTIES ("parquet.compression"="SNAPPY")
;

insert into customer_details_parquet_snappy select * from customer_details_parquet;

select * from customer_details_parquet_snappy limit 5;
