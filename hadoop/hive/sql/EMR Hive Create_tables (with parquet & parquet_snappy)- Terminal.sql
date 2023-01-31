TERMINAL 1 | USING PUTTY


Using username "hadoop".
Authenticating with public key "evans_ec2"
Last login: Sun Jan 29 15:46:58 2023

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
12 package(s) needed for security, out of 16 available
Run "sudo yum update" to apply all updates.

EEEEEEEEEEEEEEEEEEEE MMMMMMMM           MMMMMMMM RRRRRRRRRRRRRRR
E::::::::::::::::::E M:::::::M         M:::::::M R::::::::::::::R
EE:::::EEEEEEEEE:::E M::::::::M       M::::::::M R:::::RRRRRR:::::R
  E::::E       EEEEE M:::::::::M     M:::::::::M RR::::R      R::::R
  E::::E             M::::::M:::M   M:::M::::::M   R:::R      R::::R
  E:::::EEEEEEEEEE   M:::::M M:::M M:::M M:::::M   R:::RRRRRR:::::R
  E::::::::::::::E   M:::::M  M:::M:::M  M:::::M   R:::::::::::RR
  E:::::EEEEEEEEEE   M:::::M   M:::::M   M:::::M   R:::RRRRRR::::R
  E::::E             M:::::M    M:::M    M:::::M   R:::R      R::::R
  E::::E       EEEEE M:::::M     MMM     M:::::M   R:::R      R::::R
EE:::::EEEEEEEE::::E M:::::M             M:::::M   R:::R      R::::R
E::::::::::::::::::E M:::::M             M:::::M RR::::R      R::::R
EEEEEEEEEEEEEEEEEEEE MMMMMMM             MMMMMMM RRRRRRR      RRRRRR

[hadoop@ip-172-31-33-21 ~]$ hive

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.                                    properties Async: true
hive> show databases;
OK
default
src_customer
Time taken: 1.422 seconds, Fetched: 2 row(s)
hive> create database src_customer
    > location "s3://aws-train-nov-de-data/data/src_customer";
FAILED: Execution Error, return code 1 from org.apache.hadoop.hive.ql.exec.DDLTa                                    sk. MetaException(message:Got exception: java.io.IOException com.amazon.ws.emr.h                                    adoop.fs.shaded.com.amazonaws.services.s3.model.AmazonS3Exception: Access Denied                                     (Service: Amazon S3; Status Code: 403; Error Code: AccessDenied; Request ID: 60                                    HG7T5SY9V9HZGP; S3 Extended Request ID: yp+W+DYHqbYHTQ7qaD8W7jThmSS2HnKJ+Bl+CrdU                                    uH+/n1c1C+9QYce0JY5dqddIMcOOmqLXNuo=; Proxy: null), S3 Extended Request ID: yp+W                                    +DYHqbYHTQ7qaD8W7jThmSS2HnKJ+Bl+CrdUuH+/n1c1C+9QYce0JY5dqddIMcOOmqLXNuo=)
hive> create database src_customer2
    > location "s3://quintrix-cust-data/data/src_customer";
OK
Time taken: 1.075 seconds
hive> set hivevar:src_schema=src_customer2;
hive> use ${hivevar:src_schema};
OK
Time taken: 0.26 seconds
hive> create table if not exists customer_details
    > (
    > account_id varchar(50),
    > account_open_dt varchar(50),
    > account_id_type varchar(10),
    > acct_hldr_primary_addr_state varchar(20),
    > acct_hldr_primary_addr_zip_cd varchar(20),
    > acct_hldr_first_name varchar(20),
    > acct_hldr_last_name varchar(20),
    > dataset_date varchar(50))
    > row format delimited fields terminated by ','
    > location "s3://quintrix-cust-data/data/src_customer/customer_details/"
    > tblproperties ("skip.header.line.count"="1")
    > ;
OK
Time taken: 0.855 seconds
hive> create table if not exists customer_details_parquet
    > (
    > account_id varchar(50),
    > account_open_dt varchar(50),
    > account_id_type varchar(10),
    > acct_hldr_primary_addr_state varchar(20),
    > acct_hldr_primary_addr_zip_cd varchar(20),
    > acct_hldr_first_name varchar(20),
    > acct_hldr_last_name varchar(20),
    > dataset_date varchar(50))
    > stored as parquet
    > location "s3://quintrix-cust-data/data/src_customer/customer_details_parquet/"
    > ;
OK
Time taken: 0.512 seconds
hive> insert into customer_details_parquet select * from customer_details;
Query ID = hadoop_20230129155412_5ff2fb69-c2df-46e3-b89b-0e386f87bd06
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1675006844586_0001)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 01/01  [==========================>>] 100%  ELAPSED TIME: 16.44 s
----------------------------------------------------------------------------------------------
Loading data to table src_customer2.customer_details_parquet
OK
Time taken: 25.349 seconds
hive> select * from customer_details_parquet limit 5;
OK
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
CK152926        2022-05-22      Saving  KY      54056   xnxoyfpvkg      kxbfis  2022-01-02
PV138085        2021-01-01      Checkin IN      91230   caxwkhkvyf      quntja  2022-01-02
SV52279 2022-11-22      Private AR      34193   hqtrjodhei      tdkfqw  2022-01-02
SV134503        2021-12-21      Checkin IL      54846   yauphtilec      dzhouh  2022-01-02
CK143478        2021-04-07      Saving  KY      27365   fdruqamvmt      nmsrvd  2022-01-02
Time taken: 0.358 seconds, Fetched: 5 row(s)
hive> create table if not exists customer_details_parquet_snappy
    > (
    > account_id varchar(50),
    > account_open_dt varchar(50),
    > account_id_type varchar(10),
    > acct_hldr_primary_addr_state varchar(20),
    > acct_hldr_primary_addr_zip_cd varchar(20),
    > acct_hldr_first_name varchar(20),
    > acct_hldr_last_name varchar(20),
    > dataset_date varchar(50))
    > stored as parquet
    > location "s3://quintrix-cust-data/data/src_customer/customer_details_parquet_snappy/
    > TBLPROPERTIES ("parquet.compression"="SNAPPY")
    > ;
FAILED: ParseException line 13:16 missing EOF at 'parquet' near '"s3://quintrix-cust-data/data/src_custo            mer/customer_details_parquet_snappy/
TBLPROPERTIES ("'
hive> create table if not exists customer_details_parquet_snappy
    > (
    > account_id varchar(50),
    > account_open_dt varchar(50),
    > account_id_type varchar(10),
    > acct_hldr_primary_addr_state varchar(20),
    > acct_hldr_primary_addr_zip_cd varchar(20),
    > acct_hldr_first_name varchar(20),
    > acct_hldr_last_name varchar(20),
    > dataset_date varchar(50))
    > stored as parquet
    > location "s3://quintrix-cust-data/data/src_customer/customer_details_parquet_snappy/"
    > TBLPROPERTIES ("parquet.compression"="SNAPPY")
    > ;
OK
Time taken: 0.504 seconds
hive> insert into customer_details_parquet_snappy select * from customer_details_parquet;
Query ID = hadoop_20230129155710_3fb1dc19-7547-4a5e-8904-6ed213dffda8
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1675006844586_0001)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 01/01  [==========================>>] 100%  ELAPSED TIME: 11.90 s
----------------------------------------------------------------------------------------------
Loading data to table src_customer2.customer_details_parquet_snappy
OK
Time taken: 15.616 seconds
hive>
    > select * from customer_details_parquet_snappy limit 5;
OK
CK152926        2022-05-22      Saving  KY      54056   xnxoyfpvkg      kxbfis  2022-01-02
PV138085        2021-01-01      Checkin IN      91230   caxwkhkvyf      quntja  2022-01-02
SV52279 2022-11-22      Private AR      34193   hqtrjodhei      tdkfqw  2022-01-02
SV134503        2021-12-21      Checkin IL      54846   yauphtilec      dzhouh  2022-01-02
CK143478        2021-04-07      Saving  KY      27365   fdruqamvmt      nmsrvd  2022-01-02
Time taken: 0.342 seconds, Fetched: 5 row(s)
hive>





_______________________________________________________________________________________
TERMINAL 2 | USING PUTTY





Using username "hadoop".
Authenticating with public key "evans_ec2"
Last login: Sun Jan 29 15:51:14 2023 from 76-231-163-253.lightspeed.cicril.sbcglobal.net

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
12 package(s) needed for security, out of 16 available
Run "sudo yum update" to apply all updates.

EEEEEEEEEEEEEEEEEEEE MMMMMMMM           MMMMMMMM RRRRRRRRRRRRRRR
E::::::::::::::::::E M:::::::M         M:::::::M R::::::::::::::R
EE:::::EEEEEEEEE:::E M::::::::M       M::::::::M R:::::RRRRRR:::::R
  E::::E       EEEEE M:::::::::M     M:::::::::M RR::::R      R::::R
  E::::E             M::::::M:::M   M:::M::::::M   R:::R      R::::R
  E:::::EEEEEEEEEE   M:::::M M:::M M:::M M:::::M   R:::RRRRRR:::::R
  E::::::::::::::E   M:::::M  M:::M:::M  M:::::M   R:::::::::::RR
  E:::::EEEEEEEEEE   M:::::M   M:::::M   M:::::M   R:::RRRRRR::::R
  E::::E             M:::::M    M:::M    M:::::M   R:::R      R::::R
  E::::E       EEEEE M:::::M     MMM     M:::::M   R:::R      R::::R
EE:::::EEEEEEEE::::E M:::::M             M:::::M   R:::R      R::::R
E::::::::::::::::::E M:::::M             M:::::M RR::::R      R::::R
EEEEEEEEEEEEEEEEEEEE MMMMMMM             MMMMMMM RRRRRRR      RRRRRR

[hadoop@ip-172-31-33-21 ~]$  aws s3 cp s3://quintrix-cust-data/cards_account_ingest_2022-01-02.csv s3://quintrix-cust-data/data/src_customer/customer_details/

copy: s3://quintrix-cust-data/cards_account_ingest_2022-01-02.csv to s3://quintrix-cust-data/data/src_customer/customer_details/cards_account_ingest_2022-01-02.csv
[hadoop@ip-172-31-33-21 ~]$
[hadoop@ip-172-31-33-21 ~]$
