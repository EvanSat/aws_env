create table quantrix_schema.tran_fact(
    tran_id int,
    cust_id varchar(10),
    stat_cd varchar(2),
    tran_ammt decimal(10,2),
    tran_date date
)

INSERT INTO cards_ingest.tran_fact
	(tran_id, cust_id, stat_cd, tran_ammt, tran_date) VALUES
	(102020, 'cust_101', 'NY', 125,to_date('2022-01-01','yyyy-mm-dd')),
	(102021, 'cust_101', 'NY', 5125,to_date('2022-01-01','yyyy-mm-dd')),
    (102022, 'cust_102', 'CA', 6125,to_date('2022-01-01','yyyy-mm-dd')),
    (102023, 'cust_103', 'CA', 7145,to_date('2022-01-01','yyyy-mm-dd')),
    (102024, 'cust_104', 'TX', 1023,to_date('2022-01-01','yyyy-mm-dd')),
    (102025, 'cust_101', 'NY', 670,to_date('2022-01-03','yyyy-mm-dd')),
	(102026, 'cust_101', 'NY', 5235,to_date('2022-01-03','yyyy-mm-dd')),
    (102027, 'cust_102', 'CA', 61255,to_date('2022-01-04','yyyy-mm-dd')),
    (102028, 'cust_103', 'CA', 7345,to_date('2022-01-04','yyyy-mm-dd')),
    (102029, 'cust_104', 'TX', 1023,to_date('2022-01-05','yyyy-mm-dd')),
    (102030, 'cust_109', NULL, 1023,to_date('2022-01-05','yyyy-mm-dd')),
    (102031, 'cust_104',Null, 1023,to_date('2022-01-05','yyyy-mm-dd')),
    (102031, 'cust_107','TX', 4000,to_date('2022-01-05','yyyy-mm-dd')),
    (102031, 'cust_107','CA', 7000,to_date('2022-02-05','yyyy-mm-dd'));


create table quantrix_schema.cust_dim_details (
    cust_id varchar(10),
    state_cd varchar(2),
    zip_cd varchar(5),
    cust_first_name  varchar(20),
    cust_last_name  varchar(20),
    start_date date,
    end_date date,
    active_flag varchar(1)
);

insert into quantrix_schema.cust_dim_details
(cust_id,state_cd,zip_cd , cust_first_name, cust_last_name, start_date,end_date,active_flag)
VALUES
('cust_101','NY','08922', 'Mike', 'doge',to_date('2022-01-01','yyyy-mm-dd'),to_date('2029-01-01','yyyy-mm-dd'),'Y'),
('cust_102','CA','04922', 'sean', 'lan',to_date('2022-01-01','yyyy-mm-dd'),to_date('2029-01-01','yyyy-mm-dd'),'Y'),
('cust_103','CA','05922', 'sachin', 'ram',to_date('2022-01-01','yyyy-mm-dd'),to_date('2029-01-01','yyyy-mm-dd'),'Y'),
('cust_104','TX','08942', 'bill', 'kja',to_date('2022-01-01','yyyy-mm-dd'),to_date('2029-01-01','yyyy-mm-dd'),'Y'),
('cust_105','CA','08122', 'Douge', 'lilly',to_date('2022-01-01','yyyy-mm-dd'),to_date('2029-01-01','yyyy-mm-dd'),'Y'),
('cust_106','CA','08322', 'hence', 'crow',to_date('2022-01-01','yyyy-mm-dd'),to_date('2029-01-01','yyyy-mm-dd'),'Y'),
('cust_107','TX','08722', 'Mike', 'doge',to_date('2022-01-01','yyyy-mm-dd'),to_date('2029-02-01','yyyy-mm-dd'),'Y'),
('cust_107','NY','02122', 'Mike', 'doge',to_date('2022-02-03','yyyy-mm-dd'),to_date('2022-01-01','yyyy-mm-dd'),'N');


-- 1.Calculate total tran_ammt (sum) for each state

	SELECT stat_cd, SUM(tran_ammt) FROM quantrix_schema.tran_fact
	GROUP BY stat_cd
	
-- 2. Calculate maximum and minimum tran_ammt on each state and tran_date

	SELECT stat_cd, MAX(tran_ammt), MIN(tran_ammt) FROM quantrix_schema.tran_fact
	GROUP BY stat_cd
	
-- 3. Calculate total transactions which have tran_ammt more than 10000

	SELECT COUNT (tran_ammt) FROM quantrix_schema.tran_fact
	WHERE tran_ammt > 10000

-- 4. Show the state which have total (sum) tran_ammt more than 10000

	SELECT stat_cd, SUM(tran_ammt) as total_trans_ammt FROM quantrix_schema.tran_fact
	GROUP BY stat_cd
	HAVING SUM(tran_ammt) > 10000

-- 5. show me the states where total ammt is more than 10000

	SELECT stat_cd, tran_ammt FROM quantrix_schema.tran_fact
	WHERE tran_ammt > 10000

-- 6. show me the states where cust_id ='cust_104' and  total ammt is more than 10000

	SELECT stat_cd, tran_ammt FROM quantrix_schema.tran_fact
	WHERE cust_id = 'cust_104' AND tran_ammt > 10000

-- 7. Calculate total transaction by state [ if state if NULL make it TX] where total transaction is more than 10000

	SELECT COALESCE(stat_cd, 'TX'), SUM(tran_ammt) as total_trans FROM quantrix_schema.tran_fact
	GROUP BY stat_cd
	HAVING SUM(tran_ammt) > 10000

-- 8. Show me a message col if state is null then "missing data" else "good data"

	SELECT COALESCE(stat_cd, CASE
				WHEN stat_cd IS NULL THEN 'missing data'
				ELSE 'good data' END
	)
	FROM quantrix_schema.tran_fact
	
-- 9. Show me sum of tran_ammt by state [ if state is null and cust_id='cust_104' then 'TX' else 'CA']
	
	SELECT COALESCE(stat_cd, CASE WHEN (stat_cd IS NULL AND cust_ID = 'cust_104') THEN 'TX' ELSE 'CA' END) as stat_code, SUM(tran_ammt)
	FROM quantrix_schema.tran_fact
	GROUP BY stat_code

-- JOIN QUESTIONS:
-- 1. Give me all details from transaction tale and zip_cd from dimension table.

	SELECT t.*, d.zip_cd FROM quantrix_schema.tran_fact t 
	LEFT JOIN quantrix_schema.cust_dim_details d ON t.cust_id = d.cust_id
	
-- 2. Sum of tran_ammt by zip_cd

	SELECT d.zip_cd, SUM(t.tran_ammt) FROM quantrix_schema.tran_fact t
	LEFT JOIN quantrix_schema.cust_dim_details d ON t.cust_id = d.cust_id
	GROUP BY d.zip_cd

-- 3. Give me top 5 customer [ (first name+ last name) is customer] by tran_ammt [highest is first] join on cust_id

	SELECT CONCAT(d.cust_first_name, ' ', d.cust_last_name) as cust_full_name, SUM(t.tran_ammt) FROM quantrix_schema.tran_fact t
	JOIN quantrix_schema.cust_dim_details d ON t.cust_id = d.cust_id
	WHERE d.active_flag = 'Y'
	GROUP BY cust_full_name
	ORDER BY SUM(t.tran_ammt) DESC
	LIMIT 5

-- 4. Give me the all cols from tran_fact [ I don't need state_cd is null] first five records [ lower to highest]

	SELECT *, DENSE_RANK() OVER (ORDER BY tran_ammt) as tran_rank
	FROM quantrix_schema.tran_fact
	WHERE (stat_cd IS NOT NULL)
	LIMIT 5






