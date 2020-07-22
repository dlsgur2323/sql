GROUPING(column) : 0, 1
0 : 컬럼이 소계 계산에 사용되지 않았다. (group by 컬럼으로 사용됨)
1 : 컬럼이 소계 계산에 사용되었다. 

job 컬럼이 소계계산으로 사용되어 null값이 나온 것인지
정말 컬럼의 값이 null인 행들이 group by 된 것인지 알려면
grouping 함수를 사용해야 정확한 값을 알 수 있다.
grouping(job) 값이 1이면 '총계', 0이면 job;

SELECT DECODE(GROUPING(job), 1, '총계',
                             0, job) job,
             deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

NVL 함수를 사용하지 않고 GROUPING 함수를 사용해야 하는 이유

SELECT job, mgr, SUM(sal)
FROM emp
GROUP BY ROLLUP(job, mgr);

실습 2 ad2
SELECT DECODE(GROUPING(job), 1, '총',
                             0, job) job,
        CASE
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '계'
            WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN '소계'
            WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 0 THEN TO_CHAR(deptno)
        END deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT DECODE(GROUPING(job), 1, '총',
                             0, job) job,
       DECODE(GROUPING(deptno) + GROUPING(job), 1, '소계',
                                                2, '계',
                                                0, TO_CHAR(deptno)) deptno,
       SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


실습 3 ad3
SELECT deptno, job, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

실습 4 AD4
SELECT dept.dname, job, SUM(sal + NVL(comm, 0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, sal DESC; 

실습 5 AD5
SELECT DECODE(GROUPING(dept.dname), 0, dept.dname,
                               1, '총합'), job, SUM(sal + NVL(comm, 0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, sal DESC; 

확장된 GROUP BY
1. ROLLUP - 컬럼 기술에 방향성이 존재
            단점 : 개발자가 필요가 없는 서브 그룹을 임의로 제거할 수 없다.
            
            
2. GROUPING SETS - 필요한 서브그룹을 임의로 지정하는 형태
    => 복수의 GROUP BY를 하나로 합쳐서 결과를 돌려주는 형태
    GROUP BY GROUPING SETS(col1, col2)
    GROUP BY col1
    UNION ALL
    GROUP BY col2
    
    GROUPING SETS의 경우 ROLLUP과는 다르게 컬럼 나열순서가 데이터 자체에 영향을 미치지 않음.
    
    복수컬럼으로 GROUP BY
    GROUP BY col1, col2
    UNION ALL
    GROUP BY col1
    ==> GROUP BY GROUPING SETS((col1,col2),col1)
    

GROUPING SETS 실습
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY GROUPING SETS(job, deptno);

위 쿼리를 UNION ALL로 풀어 쓰기

SELECT job, null deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY job

UNION ALL

SELECT null job, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY deptno;


SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY GROUPING SETS((job, deptno), mgr);


3. CUBE
    GROUP BY를 확장한 구문
    CUBE절에 나열한 모든 가능한 조합에 대해서 서브그룹을 생성
    GROUP BY CUBE(job, deptno);
    
    GROUP BY job, deptno
    GROUP BY job
    GROUP BY      deptno
    GROUP BY

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY CUBE(job, deptno);

CUBE의 경우 기술한 컬럼으로 모든 가능한 조합으로 서브그룹을 생성한다.
가능한 서브그룹은 2^기술한 컬럼개수
기술한 컬럼이 3개만 넘어도 생성되는 서브그룹의 개수가 8개가 넘기 때문에 실제 필요하지 않은
서브그룹이 포함될 가능성이 높다.
==>ROLLUP, GROUPING STES보다 활용성이 떨어진다.


중요한 내용은 아님.
GROUP BY job, ROLLUP(deptno), CUBE(mgr)
==> 내가 필요로 하는 서브그룹을 GROUPING SETS 를 통해 정의하면 간단하게 작성 가능.

GROUP BY job, ROLLUP(deptno), CUBE(mgr)
ROLLUP(deptno) : GROUP BY deptno
                 GROUP BY : ''
CUBE(mgr) : GROUP BY mrg
            GROUP BY ''

GROUP BY job, deptno, mgr
GROUP BY job, deptno
GROUP BY job, mgr
GROUP BY job


SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(job, deptno), CUBE(mgr);

1. 서브그룹을 나열하기
    GROUP BY job
    GROUP BY job deptno
    GROUP BY job deptno mgr
    GROUP BY job mgr
    
2. 엑셀에다가 1번의 서브그룹별로 생상을 칠해보자


1. emp_test 테이블을 삭제
DROP TABLE emp_test;

2. emp 테이블을 이용하여 emp_test 테이블을 생성(모든 행 모든 컬럼)
CREATE TABLE emp_test AS
SELECT *
FROM emp;

3. emp_test 테이블에 dname(varchar2(14) 컬럼을 추가
ALTER TABLE emp_test ADD(dname VARCHAR(14));

SELECT *
FROM emp_test;


UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE dept.deptno = emp_test.deptno);
WHERE 절이 존재하지 않음 ==> 모든행에 대해서 업데이트 실행


sub_a1
1. dept_test 테이블을 삭제
DROP TABLE dept_test;

2. dept테이블을 이용해서 dept_test 생성(모든행 모든컬럼)
CREATE TABLE dept_test AS
SELECT *
FROM dept;

3. dept_test 테이블에 empcnt (number) 컬럼을 추가
ALTER TABLE dept_test ADD (empcnt NUMBER);

4. subquery를 이용하여 dept_test 테이블의 empcnt 컬럼을 해당 부서원 수로 update를 실행
UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno);

SELECT *
FROM dept_test;

COMMIT;



