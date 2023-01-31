Using username "hadoop".
Authenticating with public key "evans_ec2"
Last login: Tue Jan 31 06:50:03 2023 from 76-231-163-253.lightspeed.cicril.sbcgl                                                                            obal.net

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
77 package(s) needed for security, out of 112 available
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

[hadoop@ip-172-31-41-109 ~]$ hive
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/lib/hive/lib/log4j-slf4j-impl-2.10.0.jar!                                                                            /org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/share/aws/emr/emrfs/lib/slf4j-log4j12-1.7                                                                            .12.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/lib/hive/lib/log4j-slf4j-impl-2.10.0.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/share/aws/emr/emrfs/lib/slf4j-log4j12-1.7.12.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
Hive Session ID = 8c8f532c-e829-4a3f-8e4a-7595ddcdabe2

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
Hive Session ID = 27731c2a-118e-4945-b176-3ffd5cbbe6de
hive> set hivevar:src_schema=src_customer2;
hive> use ${hivevar:src_schema};
OK
Time taken: 1.239 seconds
hive> create table if not exists customer_details_source_partitions
    > (
    > account_id varchar(50),
    > account_open_dt varchar(50),
    > account_id_type varchar(10),
    > acct_hldr_primary_addr_state varchar(20),
    > acct_hldr_primary_addr_zip_cd varchar(20),
    > acct_hldr_first_name varchar(20),
    > acct_hldr_last_name varchar(20),
    > dataset_date varchar(50))
    > partitioned by (load_date varchar(10))
    > row format delimited fields terminated by ','
    > location "s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/"
    > tblproperties ("skip.header.line.count"="1") ;
OK
Time taken: 5.704 seconds
hive>
    > desc formatted customer_details_source_partitions ;
OK
# col_name              data_type               comment
account_id              varchar(50)
account_open_dt         varchar(50)
account_id_type         varchar(10)
acct_hldr_primary_addr_state    varchar(20)
acct_hldr_primary_addr_zip_cd   varchar(20)
acct_hldr_first_name    varchar(20)
acct_hldr_last_name     varchar(20)
dataset_date            varchar(50)

# Partition Information
# col_name              data_type               comment
load_date               varchar(10)

# Detailed Table Information
Database:               src_customer2
OwnerType:              USER
Owner:                  hadoop
CreateTime:             Tue Jan 31 06:52:21 UTC 2023
LastAccessTime:         UNKNOWN
Retention:              0
Location:               s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions
Table Type:             MANAGED_TABLE
Table Parameters:
        COLUMN_STATS_ACCURATE   {\"BASIC_STATS\":\"true\"}
        bucketing_version       2
        numFiles                0
        numPartitions           0
        numRows                 0
        rawDataSize             0
        skip.header.line.count  1
        totalSize               0
        transient_lastDdlTime   1675147941

# Storage Information
SerDe Library:          org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
InputFormat:            org.apache.hadoop.mapred.TextInputFormat
OutputFormat:           org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat
Compressed:             No
Num Buckets:            -1
Bucket Columns:         []
Sort Columns:           []
Storage Desc Params:
        field.delim             ,
        serialization.format    ,
Time taken: 0.85 seconds, Fetched: 45 row(s)
hive> show partitions customer_details_source_partitions;
OK
Time taken: 1.033 seconds
hive> alter table customer_details_source_partitions add partition (load_date='2022-01-02');
OK
Time taken: 0.933 seconds
hive> select count(1),load_date from customer_details_source_partitions group by load_date ;
Query ID = hadoop_20230131065443_36b895d1-731b-48bd-8ef3-8874c9d6f033
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1675147272773_0006)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 16.01 s
----------------------------------------------------------------------------------------------
OK
4999    2022-01-02
Time taken: 463.997 seconds, Fetched: 1 row(s)
hive>
    > alter table customer_details_source_partitions add partition (load_date='2022-01-03');
OK
Time taken: 0.913 seconds
hive> show partitions customer_details_source_partitions;
OK
load_date=2022-01-03
load_date=2022-01-02
Time taken: 0.845 seconds, Fetched: 2 row(s)
hive> select count(1),load_date from customer_details_source_partitions group by load_date ;
Query ID = hadoop_20230131070309_c28196e6-9440-41cb-b69b-615913b94db5
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1675147272773_0006)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 9.33 s
----------------------------------------------------------------------------------------------
OK
4999    2022-01-02
Time taken: 11.12 seconds, Fetched: 1 row(s)
hive> select count(1),load_date from customer_details_source_partitions group by load_date ;
Query ID = hadoop_20230131070407_5b9fcc31-f5da-47d8-9164-032f0d1163cc
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1675147272773_0006)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 9.81 s
----------------------------------------------------------------------------------------------
OK
4999    2022-01-02
1000    2022-01-03
Time taken: 11.616 seconds, Fetched: 2 row(s)
hive> Shutting down tez session.



__________________________________________________________________________________________________

Using username "hadoop".
Authenticating with public key "evans_ec2"
Last login: Tue Jan 31 06:51:41 2023 from 76-231-163-253.lightspeed.cicril.sbcgl                                                                  obal.net

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
77 package(s) needed for security, out of 112 available
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

[hadoop@ip-172-31-41-109 ~]$ aws s3 cp s3://quintrix-cust-data/cards_account_ingest_2022-01-02.csv s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/load_date='2022-01-02'/
copy: s3://quintrix-cust-data/cards_account_ingest_2022-01-02.csv to s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/load_date=2022-01-02/cards_account_ingest_2022-01-02.csv
[hadoop@ip-172-31-41-109 ~]$ aws s3 cp s3://quintrix-cust-data/cards_account_ingest_2022-01-03.csv s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/load_date='2022-01-03'/
copy: s3://quintrix-cust-data/cards_account_ingest_2022-01-03.csv to s3://quintrix-cust-data/data/src_customer/customer_details_source_partitions/load_date=2022-01-03/cards_account_ingest_2022-01-03.csv
[hadoop@ip-172-31-41-109 ~]$
