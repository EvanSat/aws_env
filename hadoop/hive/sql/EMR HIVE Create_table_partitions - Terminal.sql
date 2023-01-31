Using username "hadoop".
Authenticating with public key "evans_ec2"
Last login: Tue Jan 31 07:01:39 2023

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
SLF4J: Found binding in [jar:file:/usr/lib/hive/lib/log4j-slf4j-impl-2.10.0.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/share/aws/emr/emrfs/lib/slf4j-log4j12-1.7.12.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/lib/hive/lib/log4j-slf4j-impl-2.10.0.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/share/aws/emr/emrfs/lib/slf4j-log4j12-1.7.12.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
Hive Session ID = 7406939a-f165-428a-bc2c-fc51c4b9b314

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
Hive Session ID = 8d25cabe-4e07-4f15-83d5-273eae6ebc76
hive> set hive.execution.engine=tez;
hive> set hivevar:src_schema=src_customer2;
hive> use ${hivevar:src_schema};
OK
Time taken: 1.353 seconds
hive> create table if not exists customer_details_partition_dynamic
    > (
    > account_id varchar(50),
    > account_open_dt varchar(50),
    > account_id_type varchar(10),
    > acct_hldr_primary_addr_zip_cd varchar(20),
    > acct_hldr_first_name varchar(20),
    > acct_hldr_last_name varchar(20))
    > PARTITIONED BY (dataset_date varchar(20),acct_hldr_primary_addr_state varchar(50))
    > stored as parquet
    > TBLPROPERTIES ("parquet.compression"="SNAPPY");
OK
Time taken: 0.576 seconds
hive> ;set hive.exec.dynamic.partition=true;
hive> set hive.exec.dynamic.partition.mode=nonstrict;
hive>
    >
    > set hive.exec.dynamic.partition=true;
hive> set hive.exec.dynamic.partition.mode=nonstrict;
hive> insert overwrite table customer_details_partition_dynamic partition(dataset_date,acct_hldr_primary_addr_state)
    > select
    > account_id,
    > account_open_dt,
    > account_id_type,
    > acct_hldr_primary_addr_zip_cd,
    > acct_hldr_first_name,
    > acct_hldr_last_name,
    > dataset_date,
    > acct_hldr_primary_addr_state from customer_details_source_partitions ;
Query ID = hadoop_20230131070852_f5ffa42e-8526-4683-9651-f175b2a1beec
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1675147272773_0013)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 47.32 s
----------------------------------------------------------------------------------------------
Loading data to table src_customer2.customer_details_partition_dynamic partition (dataset_date=null, acct_hldr_primary_addr_state=null)

Loaded : 44/44 partitions.
         Time taken to load dynamic partitions: 12.511 seconds
         Time taken for adding to write entity : 0.01 seconds
OK
Time taken: 631.372 seconds
hive> show partitions customer_details_partition_dynamic;
OK
dataset_date=2022-01-03/acct_hldr_primary_addr_state=IL
dataset_date=2022-01-03/acct_hldr_primary_addr_state=ME
dataset_date=2022-01-02/acct_hldr_primary_addr_state=IN
dataset_date=2022-01-02/acct_hldr_primary_addr_state=CO
dataset_date=2022-01-02/acct_hldr_primary_addr_state=AK
dataset_date=2022-01-02/acct_hldr_primary_addr_state=AR
dataset_date=2022-01-02/acct_hldr_primary_addr_state=AZ
dataset_date=2022-01-02/acct_hldr_primary_addr_state=KY
dataset_date=2022-01-02/acct_hldr_primary_addr_state=MD
dataset_date=2022-01-03/acct_hldr_primary_addr_state=CO
dataset_date=2022-01-02/acct_hldr_primary_addr_state=LA
dataset_date=2022-01-03/acct_hldr_primary_addr_state=DE
dataset_date=2022-01-02/acct_hldr_primary_addr_state=IA
dataset_date=2022-01-03/acct_hldr_primary_addr_state=KS
dataset_date=2022-01-03/acct_hldr_primary_addr_state=AL
dataset_date=2022-01-03/acct_hldr_primary_addr_state=IA
dataset_date=2022-01-02/acct_hldr_primary_addr_state=ME
dataset_date=2022-01-03/acct_hldr_primary_addr_state=IN
dataset_date=2022-01-02/acct_hldr_primary_addr_state=DC
dataset_date=2022-01-02/acct_hldr_primary_addr_state=ID
dataset_date=2022-01-03/acct_hldr_primary_addr_state=CT
dataset_date=2022-01-03/acct_hldr_primary_addr_state=AK
dataset_date=2022-01-03/acct_hldr_primary_addr_state=MA
dataset_date=2022-01-03/acct_hldr_primary_addr_state=GA
dataset_date=2022-01-03/acct_hldr_primary_addr_state=LA
dataset_date=2022-01-03/acct_hldr_primary_addr_state=MD
dataset_date=2022-01-03/acct_hldr_primary_addr_state=KY
dataset_date=2022-01-02/acct_hldr_primary_addr_state=CA
dataset_date=2022-01-02/acct_hldr_primary_addr_state=CT
dataset_date=2022-01-03/acct_hldr_primary_addr_state=HI
dataset_date=2022-01-02/acct_hldr_primary_addr_state=MA
dataset_date=2022-01-03/acct_hldr_primary_addr_state=CA
dataset_date=2022-01-03/acct_hldr_primary_addr_state=ID
dataset_date=2022-01-03/acct_hldr_primary_addr_state=DC
dataset_date=2022-01-02/acct_hldr_primary_addr_state=AL
dataset_date=2022-01-02/acct_hldr_primary_addr_state=DE
dataset_date=2022-01-02/acct_hldr_primary_addr_state=IL
dataset_date=2022-01-02/acct_hldr_primary_addr_state=HI
dataset_date=2022-01-02/acct_hldr_primary_addr_state=GA
dataset_date=2022-01-02/acct_hldr_primary_addr_state=KS
dataset_date=2022-01-03/acct_hldr_primary_addr_state=AZ
dataset_date=2022-01-03/acct_hldr_primary_addr_state=FL
dataset_date=2022-01-02/acct_hldr_primary_addr_state=FL
dataset_date=2022-01-03/acct_hldr_primary_addr_state=AR
Time taken: 0.72 seconds, Fetched: 44 row(s)
hive> select count(1),dataset_date,acct_hldr_primary_addr_state from customer_details_partition_dynamic group by dataset_date,acct_hldr_primary_addr_state
    > order by 1 desc ;
Query ID = hadoop_20230131071955_c54ac41f-0a89-42cd-ae08-c209803b2498
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1675147272773_0013)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0
Reducer 2 ...... container     SUCCEEDED      2          2        0        0       0       0
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0
----------------------------------------------------------------------------------------------
VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 16.93 s
----------------------------------------------------------------------------------------------
OK
262     2022-01-02      KY
257     2022-01-02      DC
238     2022-01-02      FL
236     2022-01-02      ME
235     2022-01-02      CA
233     2022-01-02      IA
233     2022-01-02      ID
233     2022-01-02      AR
232     2022-01-02      DE
231     2022-01-02      MD
226     2022-01-02      HI
225     2022-01-02      AL
222     2022-01-02      CT
221     2022-01-02      IN
220     2022-01-02      CO
220     2022-01-02      GA
218     2022-01-02      AZ
217     2022-01-02      AK
215     2022-01-02      KS
213     2022-01-02      LA
206     2022-01-02      MA
206     2022-01-02      IL
58      2022-01-03      MA
55      2022-01-03      HI
52      2022-01-03      AK
52      2022-01-03      IN
50      2022-01-03      AR
50      2022-01-03      FL
49      2022-01-03      ID
48      2022-01-03      DC
48      2022-01-03      IA
46      2022-01-03      MD
46      2022-01-03      CO
46      2022-01-03      AL
46      2022-01-03      ME
44      2022-01-03      KS
43      2022-01-03      CT
42      2022-01-03      AZ
42      2022-01-03      LA
39      2022-01-03      KY
38      2022-01-03      IL
37      2022-01-03      CA
35      2022-01-03      DE
34      2022-01-03      GA
Time taken: 19.439 seconds, Fetched: 44 row(s)
hive> Shutting down tez session.
