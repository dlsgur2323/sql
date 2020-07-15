오라클 객체(object)
table - 데이터 저장공간
    .ddl 생성, 수정, 삭제
view - sql(쿼리다) 논리적인 데이터 정의, 실체가 없다.
    view 를 구성하는 테이블의 데이터가 변경되면 view의 결과도 달라진다.
sequence - 중복되지 않는 정수값을 반환해주는 객체
            유일한 값이 필요할 때 사용할 수 있는 객체
            nextval, currval
index - 테이블의 일부 컬럼을 기준으로 미리 정렬해 놓은 데이터
        ==> 테이블 없이 단독적으로 생성불가, 특정 테이블에 종속
            table 삭제를 하면 관련 인덱스도 같이 삭제

DB 구조에서 중요한 전제 조건
1. DB에서 I/O의 기준은 행단위가 아니라 block 단위
    한건의 데이터를 조회하더라도, 해당 행이 존재하는 block 전체를 읽는다.
    
데이터 접근방식
1. table full access
    multi block io ==> 읽어야 할 블럭 여러개를 한번에 읽어들이는 방식
                        (일반적으로는 8~16 block)
    사용자가 원하는 데이터의 결과가 table의 모든 데이터를 다 읽어야 처리가 가능한 경우
    ==> 인덱스보다 여러 블럭을 한번에 많이 조회하는 table full access 방식이 유리할 수 있다.
    ex : 
    전제조건은 mgr, sal, comm 컬럼으로 인덱스가 없을 때
    mgr, sal, comm 정보를 table에서만 획득이 가능할 때
    SELECT COUNT(mgr), SUM(sal), SUM(comm), AVG(sa)
    FROM emp;
    
    
2. index 접근, index 접근 후 table access
    single block io ==> 읽어야 할 행이 있는 데이터 block만 읽어서 처리하는 방식
    소수의 몇건 데이터를 사용자가 조회할 경우, 그리고 조건에 맞는 인덱스가 존재할 경우 빠르게 응답을 받을 수 있다.
    
    하지만 single blokc io가 빈번하게 일어나면 multi block io 보다 오히려 느리다.
    
2. extent, 공간할단 기준

현재 상태
인덱스 : IDX_NU_emp_01 (empno), idx_nu_emp_02 (job)

emp 테이블의 job 컬럼을 기준으로 2번째 NON-UCIQUE 인덱스 생성
CREATE INDEX idx_nu_emp_02 ON emp (job);
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

SELECT job, rowid
FROM emp
ORDER BY job;

Plan hash value: 3525611128
 
---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |     1 |    36 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP           |     1 |    36 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_NU_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')


인덱스 추가 생성
emp 테이블의 job, ename 컬럼으로 복합 non-unique index생성
idx_nu_emp_03
CREATE INDEX idx_nu_emp_03 ON emp (job, ename); --< job 컬럼이 동일하면 ename 으로 정렬한다. order by랑 비슷

현재 상태
인덱스 : IDX_NU_emp_01 (empno), idx_nu_emp_02 (job), idx_nu_emp_03 (job, ename)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

SELECT *
FROM TABLE(dbms_xplan.display);

위의 쿼리와 변경된 부분은 LIKE 패턴이 변경
LIKE 'C%' ==> LIKE '%C'

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

인덱스 추가
emp 테이블에 ename, job 컬럼을 기준으로 non-unique 인덱스 생성(idx_nu_emp_04)
CREATE INDEX idx_nu_emp_04 ON emp (ename, job);

현재 상태
인덱스 : IDX_NU_emp_01 (empno)
        idx_nu_emp_02 (job)
        idx_nu_emp_03 (job, ename) ==> 삭제
        idx_nu_emp_04 (ename, job) : 복합 컬럼 인덱스의 컬럼 순서가 미치는 영향

DROP INDEX idx_nu_emp_03;

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE (dbms_xplan.display);

조인에서의 인덱스 활용
emp : pk_emp, fk_emp_dept 생성
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

emp : pk_emp (empno), idx_...
dept : pk_dept (deptno)

접근방식 : emp 1. table full access, 2. 인덱스 * 4 : 방법 5가지 존재
          dept 1. table full access, 2. 인덱스 * 1 : 방법 2가지 존재
          가능한 경우의 수가 10가지
          방향성 emp, dept를 먼저 처리할지 ==> 20가지

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.empno = 7788;
   
SELECT *
FROM TABLE (dbms_xplan.display);


Plan hash value: 999219729
 
-----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |               |     1 |    56 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |               |       |       |            |          |
|   2 |   NESTED LOOPS                |               |     1 |    56 |     2   (0)| 00:00:01 |
|*  3 |    TABLE ACCESS BY INDEX ROWID| EMP           |     1 |    36 |     1   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_NU_EMP_01 |     1 |       |     0   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT       |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT          |     4 |    80 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------
 4 - 3 - 5 - 2 - 6 - 1 - 0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter("EMP"."DEPTNO" IS NOT NULL)
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")


EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

   
SELECT *
FROM TABLE (dbms_xplan.display);


Plan hash value: 844388907
 
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |    14 |   784 |     6  (17)| 00:00:01 |
|   1 |  MERGE JOIN                  |         |    14 |   784 |     6  (17)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     4 |    80 |     2   (0)| 00:00:01 |
|   3 |    INDEX FULL SCAN           | PK_DEPT |     4 |       |     1   (0)| 00:00:01 |
|*  4 |   SORT JOIN                  |         |    14 |   504 |     4  (25)| 00:00:01 |
|*  5 |    TABLE ACCESS FULL         | EMP     |    14 |   504 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 3 - 2 - 5 - 4 - 1 - 0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
       filter("EMP"."DEPTNO"="DEPT"."DEPTNO")
   5 - filter("EMP"."DEPTNO" IS NOT NULL)


실습 idx1
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1 = 1


CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_nu_dept_test2_02 ON dept_test2 (dname);
CREATE INDEX idx_nu_dept_test2_03 ON dept_test2 (deptno, dname);

실습 idx2
DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_nu_dept_test2_02;
DROP INDEX idx_nu_dept_test2_03;

실습 idx3
access 패턴 분석
1. empno(=)
2. ename(=)
3. deptno(=), empno(LIKE)
4. deptno(=), sal(between)
5. deptno(=), empno(=)
6. deptno, hiredate 컬럼으로 구성된 인덱스가 있을경우 table 접근이 필요없음

1) (empno)
2) (deptno, empno, sal, hiredate)
3) (ename)



empno ename




1. empno (유니크(중복없음)
2. ename (중복 가능)
  ==> index (empno, ename)
  
3. 1)사번으로 해당 사원 탐색.
    2)그 사원의 부서번호 탐색
    3)dept 테이블에서 그 부서번호의 인덱스 탐색
    4)dept 테이블에서 그 인덱스의 정보 탐색
   ==>  ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
        ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

    
4. 1) 해당 부서 사람들의
   2) 해당 급여 범위 안에 있는 사원 탐색
   == > ( deptno, sal)

5. 1) 해당부서 사원을 탐색
    2) 그 사원의 매니저번호 탐색
    3) 그 매니저 번호와 같은 사원번호 탐색 해서 조회
    ==> ( deptno mgr empno)
    
6. 1) 부서번호와 입사 연월이 같은 사원들끼리 그룹 
    2) 같은 부서 입사동기 COUNT
    ==> INDEX (부서,입사연월) 

SYNONYM : 오라클 객체의 별칭을 생성
dlsgur.v_emp ==> v_emp

생성방법
CREATE [PUBLIC] SYNONYM 시노님이름 FOR 원본객체이름;
PUBLIC : 모든 사용자가 사용할 수 있는 시노님
         권한이 있어야 생성가능
PRIVATE [DEFAULT] : 해당 사용자만 사용할 수 있는 시노님 (기본적용)



삭제방법
DROP SYNONYM 시노님이름;












