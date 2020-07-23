확장된 GROUP BY
==> 서브그룹을 자동으로 생성
    만약 이런 구문이 없다면 개발자가 직접 SELECT 쿼리를 여러개 작성해서
    UNION ALL 을 시행 ==> 동일한 테이블을 여러번 조회 ==> 성능 저하

1. ROLLUP
    1-1. ROLLUP 절에 기술한 컬럼을 오른쪽에서 부터 지워나가며 서브그룹을 생성
    1-2. 생성되는 서브그룹 :ROLLUP 절에 기술한 컬럼 개수 +1
    1-3. ROLLUP절에 기술한 컬럼의 순서가 결과에 영향을 미친다.

2. GROUPING SETS
    2-1. 사용자가 원하는 서브그룹을 직접 지정하는 형태
    2-2. 컬럼 기술의 순서는 결과 집합에 영향을 미치지 않음(집합)

3. CUBE
    3-1. CUBE절에 기술한 컬럼의 가능한 모든 조합으로 서브그룹을 생성
    3-2. 잘 안쓴다
        2^CUBE절에 기술한 컬럼개수

실습 sub a2
SELECT *
FROM dept_test;

1. dept_test테이블의 empcnt 컬럼 삭제
ALTER TABLE dept_test DROP COLUMN empcnt;


2. 2개의 신규 데이터 입력
INSERT INTO dept_test VALUES (99, 'ddit1', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit2', 'daejeon');

3. 부서(dept_test)중에 직원이 속하지 않은 부서를 삭제
    1. 비상호 연관
        DELETE dept_test
        WHERE deptno NOT IN (SELECT deptno FROM emp);
    2. 상호연관
        DELETE dept_test
        WHERE NOT EXISTS (SELECT 'X'
                        FROM emp
                        WHERE dept_test.deptno = emp.deptno);

       2-2. 상호연관 not in으로 풀어보기
        DELETE dept_test
        WHERE deptno NOT IN (SELECT deptno
                             FROM emp
                             WHERE dept_test.deptno = emp.deptno);

SELECT *
FROM dept_test;

실습3 SUB A3
DROP TABLE emp_test;
1. EMP테이블을 이용하여 EMP_TEST 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;
2. 서브쿼리를 이용하여 EMP_TEST에 본인이 속한 부서의 평균급여보다 급여가 작은 직원의 급여를 현 급여에서 200을 추가해서 업데이트 하는 쿼리 작성

UPDATE emp_test e SET sal = sal + 200
WHERE sal <= (SELECT AVG(sal)
              FROM emp_test s
              WHERE e.deptno = s.deptno);

중복제거
10,20,30
DELETE dept_test
        WHERE deptno NOT IN (SELECT deptno
                             FROM emp
                             WHERE dept_test.deptno = emp.deptno);
SELECT DISTINCT deptno
FROM emp;

WITH : 쿼리 블럭을 생성하고
같이 실행되는 SQL에서 해당 쿼리 블럭을 반복적으로 사용할 때 성능 향상 효과를 기대할 수 있다.
WITH절에 기술된 쿼리블럭은 메모리에 한번만 올리기 때문에 
쿼리에서 반복적으로 사용하더라도 실제 데이터를 가져오는 작업은 한번만 발생

하지만 하나의 쿼리에서 동일한 서브쿼리가 반복적으로 사용된다는 것은 쿼리를 잘못 작성할 가능성이 높다는 뜻이므로,
WITH절로 해결하기 보다는 쿼리를 다른 방식으로 작성할 수 없는지 먼저 고려해 볼 것을 추천

회사의 DB같은 경우 외부인에게 오픈할 수 없기 때문에, 외부인에게 도움을 구하고자 할 때 테이블을 대신할 목적으로 사용할 수 있음

사용방법 : 쿼리 블럭은 콤마를 통해 여러개를 동시에 선언하는 것도 가능

WITH 쿼리블럭이름 AS (
        SELECT 쿼리
        )
SELECT *
FROM 쿼리블록 이름;

'202007'
1. 2020년 7월의 일수 구하기
SELECT DECODE(d, 1, iw+1, iw),
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM    (SELECT (TO_DATE(:month, 'YYYYMM') + level -1) dt,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'D') d,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'IW') iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

SELECT (TO_DATE(:month, 'YYYYMM') + level -1) dt,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'D') d,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'IW') iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'DD');

----------------------------------------------------------------------------------------

달력만들기 수정1
SELECT  
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM    (SELECT (TO_DATE(:month, 'YYYYMM') + level -1) dt,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'D') d,
                DECODE(TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'D'), 1, TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level,'IW'), TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'IW')) iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY sat;

-----------------------------------------------------------------------------------------

create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;


SELECT *
FROM sales;

SELECT   NVL(SUM(DECODE(TO_CHAR(dt, 'MM'), 01, sales)), 0) jan,
         NVL(SUM(DECODE(TO_CHAR(dt, 'MM'), 02, sales)), 0) feb,
         NVL(SUM(DECODE(TO_CHAR(dt, 'MM'), 03, sales)), 0) mar,
         NVL(SUM(DECODE(TO_CHAR(dt, 'MM'), 04, sales)), 0) apr,
         NVL(SUM(DECODE(TO_CHAR(dt, 'MM'), 05, sales)), 0) may,
         NVL(SUM(DECODE(TO_CHAR(dt, 'MM'), 06, sales)), 0) jun
FROM sales;


달력만들기 수정2
SELECT 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM    
        (SELECT (TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D') + level) dt,
                TO_CHAR((TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D') + level),'D') d,
                DECODE(TO_CHAR((TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D') + level),'D'), 1,
                        TO_CHAR(TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D')+ level+1,'IW'),
                         TO_CHAR(TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D')+ level,'IW')) iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'DD')+ TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D')-1 +
                                    (7-TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'D')))
GROUP BY iw
ORDER BY sun;

