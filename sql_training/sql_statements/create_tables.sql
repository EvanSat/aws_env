CREATE TABLE quantrix_schema.dept(
	dptno	int primary key,
	dname	varchar(14),
	loc		varchar(13)
);

CREATE TABLE quantrix_schema.emp(
  empno    int,
  ename    varchar(10),
  job      varchar(9),
  mgr      int,
  hiredate date,
  sal      decimal(7,2),
  comm     decimal(7,2),
  deptno   int
);