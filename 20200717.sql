SQL-응용 : DML (SELECT, UPDATE, INSERT, MERGE)

1.  Multiple Insert ==> 많이 사용하는 편은 아님
한번의 INSERT 구문을 통해 여러 테이블에 데이터를 입력
RDBMS : 데이터의 중복을 최소화
실 사용예 : 1. 실제 사용할 테이블과 별개로 보조 테이블에도 동일한 데이터 쌓기 데이터 백업용
           2. 데이터의 수평분할(*)
           주문 테이블
           2020년 데이터 ==> TB_ORDER_2020
           2021년 데이터 ==> TB_ORDER_2021
           ==> 오라클 PARTITION을 통해 더 효과적으로 관리 가능 (정식버전)
           하나의 테이블 안에 데이터 값에 따라서 저장하는 물리공간이 나뉘어져 있음
           : 개발자 입장에서는 데이터를 입력하면
           데이터 값에 따라 물리적인 공간을 오라클이 알아서 나눠서 저장
           
MULTIPLE INSERT 종류
1. unconditional insert : 조건과 관계없이 하나의 데이터를 여러 테이블에 입력
2. conditional all insert : 조건을 만족하는 모든 테이블에 입력
3. conditional first insert : 조건을 만족하는 첫번째 테이블에 입력;

실습
1. emp_test, emp_test2 drop
2. emp 테이블의 empno컬럼이랑 ename 컬럼만 갖고 emp_test, emp_test2를 생성
   단, 데이터를 복사하지 않음.
   
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1 != 1;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1 != 1;

unconditional insert
아래 두개의 행을 emp_test, emp_test2에 동시 입력,
하나의 insert구문 사용
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;

INSERT ALL 
    INTO emp_test VALUES(empno, ename)
    INTO emp_test2 (empno) VALUES (empno)
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test2;

ROLLBACK;

2.conditional insert
조건 분기 문법 : CASE WHEN THEN END
조건 분기 함수 : DECOD

INSERT ALL 
    WHEN empno >= 9999 THEN
        INTO emp_test VALUES(empno, ename)
    WHEN empno >= 9998 THEN
        INTO emp_test2 VALUES(empno, ename)
    ELSE
        INTO emp_test2 (empno) VALUES (empno)
    
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test2;

ROLLBACK;
3.conditional first insert
ALL => 3, FIRST => ?

INSERT FIRST 
    WHEN empno >= 9999 THEN
        INTO emp_test VALUES(empno, ename)
    WHEN empno >= 9998 THEN
        INTO emp_test2 VALUES(empno, ename)
    ELSE
        INTO emp_test2 (empno) VALUES (empno)
    
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;


MERGE
1. 사용자로부터 받은 값을 갖고 테이블에 저장 OR 수정
    입력받은 값이 테이블에 존재하면 수정하고 싶고
    입력받은 값이 테이블에 존재하지 않으면 신규 입력 하고 싶을 때

2. 테이블의 데이터를 이용하여 다른 테이블의 데이터를 업데이트 OR INSERT 하고 싶을 때
   
   일반 UPDATE 구문에서는 비효율이 존재
    ALLEN의 JOB과 DEPTNO를 SMITH사원과 동일한 업데이트 하시오
    UPDATE emp SET job = (SELECT job FROM emp WHERE ename = 'SMITH'),
                   deptno = (SELECT deptno FORM emp WHERE ename = 'SMITH')
    WHEREN ename = 'ALLEN'
    
ex : empno 9999, ename 'brown'
emp 테이블에 동일한 empno가 있으면 ename을 업데이트
emp 테이블에 동일한 empno가 없으면 신규입력

머지구문을 사용하지 않는다면
1. 해당 데이터가 존재하지는 확인하는 select 구문을 실행
2. 1번 쿼리의 조회 결과가 있으면
    2.1 UPDATE
3. 1번 쿼리의 조회 결과가 없으면
    3.1 INSERT
    
1.
SELECT *
FROM emp
WHERE empno = 9999

2. UPDATE emp SET ename = 'brown'
    WHERE empno = 9999;

3. INSERT INTO emp (empno, ename) VALUES ('brown', 9999);

문법
MERGE INTO 테이블명(덮어 쓸 테이블) alias 
USING ( 테이블명 | VIEW | inline-view ) alias
   ON ( 두 테이블간의 데이터 존재여부를 확인할 조건)
WHEN MATCHED THEN
    UPDATE SET 컬럼1 = 값1,
               컬럼1 = 값1,
WHEN NOT MATCHED THEN
    INSERT (컬럼1, 컬럼2 ,...) VALUES (값1, 값2,...)
 ;   
ROLLBACK;

1. 7369사원의 데이터를 EMP_TEST로 복사 (empno, ename)

SELECT *
FROM emp_test;

INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;

SELECT *
FROM emp;

DELETE emp
WHERE empno >= 9990;

emp : 14, emp_test: 1(7369-emp 테이블에도 존재)
emp테이블을 이용하여 emp_test에
emp 테이블을 이용하여 emp_test에 동일한 empno값이 있으면 emp_test.ename 업데이트
동일한 empno 값이 없으면 emp테이블의 데이터를 신규 입력

MERGE INTO emp_test t
USING emp e
   ON (e.empno = t.empno)
WHEN MATCHED THEN
    UPDATE SET t.ename = e.ename || '_m'
WHEN NOT MATCHED THEN
    INSERT (empno, ename) VALUES (e.empno, e.ename);

emp_test테이블에는
7369사원의 이름이 smith_m으로 업데이트
7369를 제외한 13명의 사원이 insert


merge에서 많이 사용하는 형태
사용자로부터 받은 데이터를 emp_test 테이블에 동일한 데이터 존재 유무에 따른merge
시나리오 : 사용자 입력 empno=9999, ename = brown

MERGE INTO emp_test
USING dual
   ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename
WHEN NOT MATCHED THEN
    INSERT VALUES(:empno, :ename);

SELECT *
FROM emp_test;

SELECT *
FROM dept_test2;

실습 : dept_test3 테이블을 dept 테이블과 동일하게 생성
        단 10, 20번 부서 데이터만 복제
        
        dept 테이블을 이용하여 dept_test3 테이블에 데이터를 merge
        머지조건 : 부서번호가 같은 데이터
            동일한 부서가 있을 때 : 기존 loc컬럼의 값 + _m로 업데이트
            동일한 부서가 없을 때 : 신규

CREATE TABLE dept_test3 AS
SELECT *
FROM dept
WHERE deptno IN (10, 20);

SELECT *
FROM dept_test3;

MERGE INTO dept_test3 a
USING dept b
   ON (a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET a.loc = b.loc || '_m'
WHEN NOT MATCHED THEN
    INSERT VALUES (b.deptno, b.dname, b.loc);

실습2 ] 사용자 입력받은 값을 이용한 merge
    사용자 입력 : deptno : 99, dname : 'ddit', loc : 'daejeon'
    dept_test3 테이블에 사용자가 입력한 deptno값과 동일한 데이터가
    있을 경우 : 사용자가 입력한 dname, loc 값으로 두개 컬럼 업데이트
    없을 경우 : 사용자가 입력한 deptno, dname, loc 값으로 인서트
    
MERGE INTO dept_test3 d
USING dual
   ON (d.deptno = :deptno)
WHEN MATCHED THEN
    UPDATE SET d.dname = :dname, d.loc = :loc
WHEN NOT MATCHED THEN
    INSERT VALUES (:deptno, :dname, :loc);

SELECT *
FROM dept_test3;


GROUP FUNCTION 응용, 확장

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT NULL, SUM(sal)
FROM emp
ORDER BY deptno;

emp 테이블을 한번만 읽고서 처리하기
단, emp 테이블을 14건의 데이터를 다 읽지 않는 다면 2번 사용 가능

SELECT deptno, SUM(sal)
FROM emp e, (SELECT SUM(sal)
            FROM emp) s
GROUP BY deptno;

SELECT deptno, SUM(sal)
FROM emp;
GROUP BY deptno;


SELECT deptno, SUM(sal)
FROM emp e(+), (SELECT null, SUM(sal)
             FROM emp)
GROUP BY deptno;


SELECT null deptno, SUM(sal)
FROM emp;

SELECT deptno2, SUM(sum_sal)
FROM   (SELECT deptno, DECODE(rn, 1, deptno, 2, null) deptno2, sum_sal, rn
       FROM (SELECT deptno, SUM(sal) sum_sal
               FROM emp    
             GROUP BY deptno) a,
              (SELECT ROWNUM rn --< dept 테이블을 안읽나?
               FROM dept
             WHERE ROWNUM <=2) b)
GROUP BY deptno2
ORDER BY deptno2;


SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP(deptno);


ROLLUP : 1. GROUP BY의 확장구문
         2. 정해진 규칙으로 서브 그룹을 생성하고 생성된 서브 그룹을 하나의 집합으로 반환
         3. GROUP BY ROLLUP(col1, col2 ...)
         4. ROLLUP 절에 기술된 컬럼을 오른쪽에서 부터 하나씩 제거해 가며 서브 그룹을 생성
            GROUP BY ROLLUP (job, deptno)
            GROUP BY ROLLUP (deptno, job)
            ROLLUP의 경우 방향성이 있기 때문에 컬럼 기술순서가 다르면 다른 결과가 나온다
            
예시 : GROUP BY ROLLUP (deptno)
1. GROUP BY deptno ==> 부서번호별 총계
2. GROUP BY '' ==> 전체총계

예시 : GROUP BY ROLLUP (job, deptno)
1. GROUP BY job, deptno => 담당업무 부서번호별 총계
2. GROUP BY job ==> 담당업무별 총계
3. GROUP BY '' ==> 전체 총계

* ROLLUP절에 N개의 컬럼을 기술 했을 때 SUBGROUP의 개수는 : N+1


SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT job, deptno, GROUPING(job), GROUPING(deptno), SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

group ad2

SELECT DECODE(GROUPING(job), 1, '총계',
                            job) job,
             deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);







