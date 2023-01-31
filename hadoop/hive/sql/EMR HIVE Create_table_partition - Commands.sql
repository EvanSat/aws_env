--*******************************************************************************************
--USING PUTTY to execute commands--

hive

set hive.execution.engine=tez;
set hivevar:src_schema=src_customer2;
use ${hivevar:src_schema};

create table if not exists customer_details_partition_dynamic
(
account_id varchar(50),
account_open_dt varchar(50),
account_id_type varchar(10),
acct_hldr_primary_addr_zip_cd varchar(20),
acct_hldr_first_name varchar(20),
acct_hldr_last_name varchar(20))
PARTITIONED BY (dataset_date varchar(20),acct_hldr_primary_addr_state varchar(50))
stored as parquet
TBLPROPERTIES ("parquet.compression"="SNAPPY");
;


-- Required parameter for dynamic partitions
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

--- make sure keep the partition col at last in select statement

insert overwrite table customer_details_partition_dynamic partition(dataset_date,acct_hldr_primary_addr_state)
select
account_id,
account_open_dt,
account_id_type,
acct_hldr_primary_addr_zip_cd,
acct_hldr_first_name,
acct_hldr_last_name,
dataset_date,
acct_hldr_primary_addr_state from customer_details_source_partitions ;

-- Lets see the partitions

show partitions customer_details_partition_dynamic;

+----------------------------------------------------+
|                     partition                      |
+----------------------------------------------------+
| dataset_date=2022-01-02/acct_hldr_primary_addr_state=KS |
| dataset_date=2022-01-02/acct_hldr_primary_addr_state=AZ |
| dataset_date=2022-01-03/acct_hldr_primary_addr_state=AZ |
| dataset_date=2022-01-02/acct_hldr_primary_addr_state=KY |
| dataset_date=2022-01-03/acct_hldr_primary_addr_state=ME |


select count(1),dataset_date,acct_hldr_primary_addr_state from customer_details_partition_dynamic group by dataset_date,acct_hldr_primary_addr_state
order by 1 desc ;

+------+---------------+-------------------------------+
| _c0  | dataset_date  | acct_hldr_primary_addr_state  |
+------+---------------+-------------------------------+
| 262  | 2022-01-02    | KY                            |
| 257  | 2022-01-02    | DC                            |
| 238  | 2022-01-02    | FL                            |
| 236  | 2022-01-02    | ME                            |
| 235  | 2022-01-02    | CA                            |