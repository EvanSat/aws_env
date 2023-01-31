insert into quantrix_schema.dept (dptno, dname, loc)
values
(10, 'ACCOUNTING', 'NEW YORK'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'OPERATIONS', 'BOSTON');


insert into quantrix_schema.emp
values
( 7839, 'KING', 'PRESIDENT', null, to_date('17-11-1981','dd-mm-yyyy'),5000, null, 10 ),
( 7698, 'BLAKE', 'MANAGER', 7839,  to_date('1-5-1981','dd-mm-yyyy'),  2850, null, 30 ),
( 7782, 'CLARK', 'MANAGER', 7839,  to_date('9-6-1981','dd-mm-yyyy'),  2450, null, 10 ),
( 7566, 'JONES', 'MANAGER', 7839,  to_date('2-4-1981','dd-mm-yyyy'),  2975, null, 20 ),
(7788, 'SCOTT', 'ANALYST', 7566,  to_date('13-7-1987','dd-mm-yyyy') ,  3000, null, 20),
(7902, 'FORD', 'ANALYST', 7566,to_date('3-12-1981','dd-mm-yyyy'),3000, null, 20),
( 7369, 'SMITH', 'CLERK', 7902,  to_date('17-12-1980','dd-mm-yyyy'),  800, null, 20  ),
( 7934, 'MILLER', 'CLERK', 7782,  to_date('23-1-1982','dd-mm-yyyy'),   1300, null, 10 ),
( 7900, 'JAMES', 'CLERK', 7698,  to_date('3-12-1981','dd-mm-yyyy'),  950, null, 30 ),
( 7876, 'ADAMS', 'CLERK', 7788,  to_date('13-7-87', 'dd-mm-yyyy') ,   1100, null, 20 ),
(  7844, 'TURNER', 'SALESMAN', 7698,  to_date('8-9-1981','dd-mm-yyyy'),  1500, 0, 30  );