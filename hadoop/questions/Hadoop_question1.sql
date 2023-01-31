-- 1.Create table :tran_fact
-- tran_id int, cust_id varchar(20),tran_date date,tran_ammount decimal(10,2), tran_type varchar(1)

-- 102020,CA1001,2022-02-01,1200,C
-- 102021,CA1002,2022-02-01,700,C
-- 102022,CA1003,2022-02-01,500,C
-- 102023,CA1004,2022-02-02,900,C
-- 102020,CA1001,2022-02-02,200,D
-- 102029,CA1001,2022-02-02,700,C
-- 102024,CA1005,2022-02-03,12200,C
-- 102025,CA1003,2022-02-03,200,D
-- 102026,CA1004,2022-02-04,12200,C
-- 102027,CA1007,2022-02-04,9200,C
-- 102028,CA1007,2022-02-04,3200,D

-- 1. Total unique customer per day.
-- 2. Total number of unique customer till date
-- 3. Total transaction amount per customer per day ( if its C then add if D then subtract )
-- 4. Find out duplicate transaction in total.
-- 5. show the transaction which has debit but never credit before.


Create table hadoop_schema.tran_fact(
	tran_id int, 
	cust_id varchar(20),
	tran_date date,
	tran_ammount decimal(10,2), 
	tran_type varchar(1)
)

Insert into hadoop_schema.tran_fact(
	tran_id,
	cust_id,
	tran_date,
	tran_ammount,
	tran_type
)
Values (
	(102020,'CA1001','2022-02-01',1200,'C'),
	(102021,'CA1002','2022-02-01',700,'C'),
	(102022,'CA1003','2022-02-01',500,'C'),
	(102023,'CA1004','2022-02-02',900,'C'),
	(102020,'CA1001','2022-02-02',200,'D'),
	(102029,'CA1001','2022-02-02',700,'C'),
	(102024,'CA1005','2022-02-03',12200,'C'),
	(102025,'CA1003','2022-02-03',200,'D'),
	(102026,'CA1004','2022-02-04',12200,'C'),
	(102027,'CA1007','2022-02-04',9200,'C'),
	(102028,'CA1007','2022-02-04',3200,'D')
-- );


-- SELECT * FROM hadoop_schema.tran_fact

-- 1. Total unique customer per day.
SELECT tran_date, COUNT(Distinct cust_id) as number_of_customers
FROM hadoop_schema.tran_fact
GROUP BY tran_date

-- 2. Total number of unique customer till date
WITH unique_cust_table AS (
    SELECT tran_date, COUNT(DISTINCT cust_id) as unique_cust_count
    FROM hadoop_schema.tran_fact
    GROUP BY tran_date
)
SELECT tran_date, unique_cust_count, SUM(unique_cust_count) OVER (ORDER BY tran_date) as running_total
FROM unique_cust_table
ORDER BY tran_date;


-- First SUM calculates the new customers per day, Second SUM provides a running total till date
WITH unique_cust_table as (
	SELECT tran_date, cust_id, RANK() OVER(PARTITION BY cust_id ORDER BY tran_date) as rank_cust_per_day
	FROM hadoop_schema.tran_fact
	GROUP BY tran_date, cust_id
	ORDER BY tran_date
)
SELECT tran_date, SUM(SUM(CASE WHEN rank_cust_per_day = 1 THEN 1 ELSE 0 END)) OVER (ORDER BY tran_date) unique_cust_till_date
FROM unique_cust_table
GROUP BY tran_date


SELECT tran_date, cust_id, RANK() OVER(PARTITION BY cust_id ORDER BY tran_date) as rank_cust_per_day
FROM hadoop_schema.tran_fact

With unique_cust_table AS(
	SELECT tran_date, cust_id, RANK() OVER(PARTITION BY cust_id ORDER BY tran_date) as rank_cust_per_day
	FROM hadoop_schema.tran_fact
)
SELECT tran_date, SUM(rank_cust_per_day)
FROM unique_cust_table
GROUP BY tran_date
ORDER BY tran_date

-- 3. Total transaction amount per customer per day ( if its C then add if D then subtract )
SELECT tran_date, cust_id, SUM(CASE WHEN tran_type = 'C' THEN tran_ammount 
							   ELSE -tran_ammount END) as net_transaction_amount
FROM hadoop_schema.tran_fact
GROUP BY tran_date, cust_id
ORDER BY tran_date, cust_id

-- 4. Find out duplicate transaction in total.
SELECT tran_id, COUNT(tran_id) as tran_id_occurances
FROM hadoop_schema.tran_fact
GROUP BY tran_id
HAVING  COUNT (tran_id) > 1

SELECT tf1.* FROM hadoop_schema.tran_fact tf1 JOIN (
	SELECT tran_id, COUNT(tran_id) as tran_id_occurances
	FROM hadoop_schema.tran_fact
	GROUP BY tran_id
	HAVING  COUNT (tran_id) > 1) as tf2 ON tf1.tran_id = tf2.tran_id

SELECT tf1.cust_id, SUM(CASE WHEN tran_type = 'C' THEN tran_ammount 
						ELSE -tran_ammount END) as net_transaction_amount
FROM hadoop_schema.tran_fact tf1 JOIN (
	SELECT tran_id, COUNT(tran_id) as tran_id_occurances
	FROM hadoop_schema.tran_fact
	GROUP BY tran_id
	HAVING  COUNT (tran_id) > 1) as tf2 ON tf1.tran_id = tf2.tran_id
GROUP BY tf1.cust_id
ORDER BY tf1.cust_id

-- 5. show the transaction which has debit but never credit before.
WITH tf2 AS (
	SELECT * FROM hadoop_schema.tran_fact
	WHERE tran_type = 'D'
)
SELECT tf1.* FROM hadoop_schema.tran_fact tf1
JOIN tf2 ON tf1.cust_id = tf2.cust_id
WHERE tf1.tran_type = 'D' and tf2.cust_id IS NULL