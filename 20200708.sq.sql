1. GROUP BY : 여러개의 행을 하나의 행으로 묶는 행위
2. JOIN
3. SUBQUERY

sub2 : 사원들의 급여평균보다 높은 급여를 받는 직원
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원정보 조회

SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = e.deptno)
ORDER BY deptno;

sub3
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                        
                        
pairwise, non-pairwise
한 행의 컬럼값을 하나씩 비교하는 것 : non-pairwise
한 행의 복수 컬럼을 비교하는 것 : pairwise
SELECT *
FROM emp
WHERE job IN('MANAGER', 'CLERK');

SELECT *
FROM emp
WHERE (mgr, deptno) IN ( SELECT mgr, deptno
                         FROM emp
                         WHERE empno IN (7499, 7782) );

pairwise
7698 30
7839 10

non-pairwise
7698 30
7839 10
7698 10
7839 30

sub4
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
SELECT *
FROM dept;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);


sub5
cid = 1 인 고객이 애음하지 않는 제품 조회
SELECT *
FROM product
WHERE pid NOT IN ( SELECT pid
               FROM cycle
               WHERE cid = 1);


sub6
SELECT *
FROM cycle 
WHERE cid = 1 AND
      pid IN (SELECT pid FROM cycle WHERE cid = 2);







                        
                        
                        
                        