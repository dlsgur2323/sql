1]
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD') AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

2]
SELECT empno, ename, job, mgr, TO_CHAR(hiredate,'YY/MM/DD') hiredate, sal, comm, deptno
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

3]
SELECT empno, ename, job, mgr, TO_CHAR(hiredate,'YY/MM/DD') hiredate, sal, comm, deptno
FROM emp
WHERE deptno NOT IN (10) AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

4]
SELECT ROWNUM, a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY empno) a;

5]
SELECT empno, ename, job, mgr, TO_CHAR(hiredate,'YY/MM/DD') hiredate, sal, comm, deptno
FROM emp
WHERE deptno IN (10, 30) AND sal > 1500
ORDER BY ename DESC;

6]
SELECT deptno, MAX(SAL) max_sal, MIN(SAL) min_sal, ROUND(AVG(SAL),2) avg_sal
FROM emp
GROUP BY deptno;

7]
SELECT empno, ename, sal, deptno, (SELECT dname FROM dept d WHERE d.deptno = e.deptno) dname
FROM emp e
WHERE sal > 2500 AND empno > 7600 AND e.deptno = (SELECT deptno FROM dept d WHERE d.dname = 'RESEARCH');

8]

SELECT empno, ename, e.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE e.deptno IN (10, 30)
ORDER BY empno;

9]
SELECT e.ename, m.ename mgr
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

10]
SELECT TO_CHAR(hiredate,'YYYYMM') HIRE_YYYYMM, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

11]
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno FROM emp WHERE ename IN ('SMITH', 'WARD'));

12]
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);

13]
INSERT INTO dept (deptno, dname, loc)
        VALUES (99, 'ddit', '대전');

14]
UPDATE dept SET dname = 'ddit_modi', loc = '대전_modi'
WHERE deptno = 99;

15]
DELETE dept
WHERE deptno = 99;

16]
CREATE TABLE emp (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7,2),
    comm NUMBER(7,2),
    deptno NUMBER(2) REFERENCES dept (deptno)
);

CREATE TABLE dept (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

17]
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno);

18]
SELECT ename, sal, deptno, TO_CHAR(hiredate,'YY/MM/DD') hiredate, RANK() OVER ( PARTITION BY deptno ORDER BY sal DESC, hiredate ) dept_sal_rank
FROM emp;

19]
SELECT empno, ename, TO_CHAR(hiredate,'YY/MM/DD') hiredate, sal, LEAD(sal) OVER (ORDER BY sal DESC, hiredate) LEAD_SAL
FROM emp;

20]
SELECT empno, ename, deptno, sal, SUM(sal) OVER (ORDER BY sal, hiredate
                                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;







