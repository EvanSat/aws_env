--Questions:

--Part 1
-- 1. show me all the tran_date,tran_ammt and total tansaction ammount per tran_date

	SELECT t1.tran_date, t1.tran_ammt, t2.total_tran_ammt FROM quantrix_schema.tran_fact t1
	CROSS JOIN (
		SELECT SUM(tran_ammt) as total_tran_ammt FROM quantrix_schema.tran_fact
	) t2
	ORDER BY tran_date ASC
	
-- 2. show me all the tran_date,tran_ammt and total tansaction ammount per tran_date and rank of the transaction ammount desc within per tran_date
-- Ouput:
-- 2022-01-01,7145.00,19543.00,1
-- 2022-01-01,6125.00,19543.00,2

	SELECT t1.tran_date, t1.tran_ammt, t2.total_tran_ammt, DENSE_RANK() OVER (PARTITION BY t1.tran_date ORDER BY t1.tran_ammt DESC) 
	FROM quantrix_schema.tran_fact t1
	CROSS JOIN (
		SELECT SUM(tran_ammt) as total_tran_ammt FROM quantrix_schema.tran_fact
	) t2
	ORDER BY tran_date ASC

-- 3. show me all the fields and total tansaction ammount per tran_date and only 2nd rank of the transaction ammount desc within per tran_date
-- (Here you are using he question2 but filtering only for rank 2)

	SELECT t1.tran_date, t1.tran_ammt, t2.total_tran_ammt, t1.tran_ranks FROM (
		SELECT tran_date, tran_ammt, DENSE_RANK() OVER (PARTITION BY tran_date ORDER BY tran_ammt DESC) as tran_ranks
		FROM quantrix_schema.tran_fact
	) t1
	CROSS JOIN (
		SELECT SUM(tran_ammt) as total_tran_ammt FROM quantrix_schema.tran_fact
	) t2
	WHERE t1.tran_ranks = 2

--Part 2

-- 1. Join tran_fact and cust_dim_details on cust_id and tran_dt between start_date and end_date

	SELECT t.*, c.* FROM quantrix_schema.tran_fact t
	JOIN quantrix_schema.cust_dim_details c ON t.cust_id = c.cust_id
	AND t.tran_date BETWEEN c.start_date AND c.end_date


-- 2. show me all the fields and total tansaction ammount per tran_date and only 2nd rank of the transaction
--    ammount desc within per tran_date(Here you are using he question2 but filtering only for rank 2) and join
--    cust_dim_details on cust_id and tran_dt between start_date and end_date
	
	SELECT * FROM (
		SELECT t.*, c.*, DENSE_RANK() OVER (PARTITION BY t.tran_date ORDER BY t.tran_ammt DESC) as trans_rank 
		FROM quantrix_schema.tran_fact t
		JOIN quantrix_schema.cust_dim_details c ON t.cust_id = c.cust_id
		AND t.tran_date BETWEEN c.start_date AND c.end_date
	) ct
	WHERE trans_rank = 2
	
-- 3. From question 2 : when stat_cd is not euqal to state_cd then data issues else good data as stae_cd_status
--    [Note NUll from left side is not equal NUll from other side  >> means lets sayd NULL value from fact table if compared
--    to NULL Value to right table then it should be data issues]

	SELECT *, CASE 
			WHEN ct.stat_cd is NULL THEN 'data issues'
			WHEN ct.stat_cd != ct.state_cd THEN 'data issues'
			ELSE 'good data' END as stae_cd_status
	FROM (
		SELECT t.*, c.*, RANK() OVER (PARTITION BY t.tran_date ORDER BY t.tran_ammt DESC) as trans_rank 
		FROM quantrix_schema.tran_fact t
		JOIN quantrix_schema.cust_dim_details c ON t.cust_id = c.cust_id
		AND t.tran_date BETWEEN c.start_date AND c.end_date
	) ct
	WHERE trans_rank = 2
