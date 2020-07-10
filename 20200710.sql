SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT *
FROM emp;

UPDATE : 상수값으로 업데이트 ==> 서브쿼리 사용가능

INSERT INTO emp (empno, ename, job) VALUES (9999, 'brown', 'RANGER');
방급 입력한 9999사번을 갖고 있는 사원의 deptno와 job컬럼의 값을 smith사원의 deptno와 job값으로 업데이트

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
               job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

==> UPDATE 쿼리 하나를 실행할 때 안쪽 SELECT 쿼리가 2개가 포함됨 ==> 비효율적
    고정된 값을 업데이트 하는 것이 아니라 다른 테이블에 있는 값을 통해서 업데이트 할 때 비효율이 존재
    ==> MERGE 구문을 통해 보다 효율적으로 업데이트가 가능

SELECT *
FROM emp;

DELETE : 테이블의 행을 삭제할 때 사용하는 SQL
         특정 컬럼만 삭제하는 거는 UPDATE
         DELETE 구문은 행 자체를 삭제
1. 어떤 테이블에서 삭제할지
2. 테이블의 어떤 행을 삭제 할지

문법 
DELETE [FROM] 테이블
WHERE 삭제할 행을 선택하는 조건;

UPDATE 쿼리 실습시 9999번 사원을 등록함. 해당 사원을 삭제하는 쿼리를 작성

DELETE emp
WHERE empno = 9999;

SELECT *
FROM emp

DELETE 쿼리도 SELECT 쿼리 작성시 사용한 WHERE 절과 동일
서브쿼리 사용 가능

사원 중에 mgr가 7698인 사원들만 삭제

DELETE emp
WHERE mgr = 7698;

DELETE emp
WHERE empno IN (SELECT empno
               FROM emp
               WHERE mgr = 7698);
ROLLBACK;

DBMS의 경우 데이터의 복구를 위해서 
DML구문을 실행할 때마다 로그를 생성
대량의 데이터를 지울 때는 로그 기록도 부하가 되기 때문에
개발환경에서는 테이블의 모든 데이터를 지우는 경우에 한해서
TRUNCATE TABLE 테이블명; 명령을 통해 로그를 남기지 않고 빠르게 삭제가 가능하다.
단, 로그가 없기 때문에 복구가 불가능하다.


emp 테이블을 이용해서 새로운 테이블을 생성
CREATE TABLE emp_copy AS
SELECT *
FROM emp;
 
SELECT *
FROM emp_copy;

TRUNCATE TABLE emp_copy; 
ROLLBACK;

 
TRANSACTION; --ppt 보면서 공부해야될듯

SELECT *
FROM dept
 
LEVEL 1 : repeatable read;
선행 트랜잭션에서 읽은 데이터를 후행 트랜잭션에서 수정하지 못하게 막아서 선행 트랜잭션 안에서는 항상 동일한 데이터가 조회 되도록 보장하는 레벨
 
 
lv2에서는 테이블에 존재하는 데이터에 대해 후행 트랜잭션에서 작업하지 막을 수는 있지만 후행 트랜잭션에서 신규로 입력하는 데이터는 막을 수 없다.
즉, 선행 트랜잭션에서 처음 읽은 데이터와 후행트랜잭션에서 신규입력 후 커밋한 이후에 조회한 데이터가 불일치 할 수 있다.
(없던 데이터가 갑자기 생성되는 현상) 

lv3 : SERIALIZABLE READ
후행 트랜잭션에서 데이터를 입력, 수정삭제 하더라도 선행트랜잭션에서는 트랜잭션 시작 시점의 데이터가 보이도록 보장

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
==> 후행트랜잭션에서 dept 테이블에 데이터 입력 후 commit

DML : 데이터를 다루는(조작) SQL
SELECT, INSERT, UPDATE, DELETE

DDL (Data Definition Language) : 데이터를 정의하는 sql
DDL 은 자동커밋, ROLLBACK 불가
EX: 테이블을 생성하는 DDL 실행 ==> 롤백불가
     ==> 테이블 삭제 DDL 실행해야함
데이터가 들어갈 공간(table)  생성, 삭제
컬럼 추가
각종 객체 생성, 수정, 삭제;

테이블 삭제
문법
DROP 객체종류 객체이름;
DROP TABLE emp_copy;
삭제한 테이블과 관련된 데이터는 삭제
나중에 배울 내용 제약조건 이런 것들도 다같이 삭제
테이블과 관련된 내용은 모두 삭제;


DML문과 DDL문을 혼합해서 사용할 경우 발생할 수 있는 문제점
==> 의도와 다르게 DML문에 대해서 COMMIT이 될 수 있다.
SELECT *
FROM emp;

INSERT INTO emp (empno, ename)
        VALUES (9999, 'brown');

SELECT COUNT(*)
FROM emp;

DROP TABLE batch;
[COMMIT];

ROLLBACK;

SELECT COUNT(*)
FROM emp;

테이블 생성
문법
CREATE TABLE 테이블명 (
    컬럼명1 컬럼1타입,
    컬럼명2 컬럼2타입,
    컬럼명3 컬럼3타입 DEFAULT 기본값
);

ranger 라는 이름의 테이블 생성

CREATE TABLE ranger (
    ranger_no NUMBER,
    ranger_nm VARCHAR2 (50),
    reg_dt DATE DEFAULT SYSDATE
);

SELECT *
FROM ranger;

INSERT INTO ranger (ranger_no, ranger_nm) VALUES (100, 'brown');

SELECT *
FROM ranger;

데이터 무결성 : 잘못된 데이터가 들어가는 것을 방지하는 성격
ex : 1. 사원 테이블에 중복된 사원번호가 등록되는 것을 방지
     2. 반드시 입력이 되어야 되는 컬럼의 값을 확인
     ==> 파일시스템이 가질 수 없는 성격
     
오라클에서 제공하는 데이터 무결성을 지키기 위해 제공하는 제약조건 (5가지)
1. NOT NULL 제약 : 해당 컬럼에 NULL 값이 들어오는 것을 제약, 방지
    ex : emp테이블의 empno컬럼
    
2. UNIQUE
    전체 행중에 해당 컬럼의 값이 중복이 되면 안된다.
    ex : emp 테이블에서 empno 컬럼이 중복되면 안된다.
    단, null에 대한 중복은 허용
    
3. PRIMARY KEY = UNIQUE + NOT NULL
    값이 반드시 존재하면서 중복이 나오면 안된다.
    
4. FOREIGN KEY
    연관된 테이블에 해당 데이터가 존재해야만 입력이 가능
    emp테이블과 dept테이블은 deptno 컬럼으로 연결이 되어있음
    emp테이블에 데이터를 입력할 때 dept테이블에 존재하지 않는 deptno 값을 입력하는 것을 방지
    
5. CHECK 제약조건
   컬럼에 들어오는 값을 정해진 로직에 따라서 제어
   ex : 어떤 테이블에 성별 컬럼이 존재하면
      남성 = M, 여성 = F
      M, F 두가지 값만 저장될 수 있도록 제어
      
      C 성별을 입력하면 ?? 시스템 요구사항을 정의할 때 정의하지 않은 값이기 때문에 추후 문제가 될 수 있다.

제약조건 생성 방법
1. 테이블 생성시, 컬럼 옆에 기술하는 경우
    * 상대적으로 세세하게 제어하는 것은 불가능

2. 테이블을 생성할 때, 모든 컬럼 기술 이후 제약조건만 별도로 기술
    *1번 방법보다 세세하게 제어하는게 가능

3. 테이블 생성이후, 객체 수정명령을 통해 제약조건을 추가
    
1번 방법으로 PRIMARY KEY 생성
dept 테이블과 동일한 컬럼명, 타입으로 dept_test 라는 테이블 이름으로 생성
1. dept 테이블의 컬럼 구성정보 확인

DESC dept;

CREATE TABLE dept_test (
    DEPTNO    NUMBER(2) PRIMARY KEY,    
    DNAME     VARCHAR2(14),
    LOC       VARCHAR2(13) 
);

SELECT *
FROM dept_test;

PRIMARY KEY 제약조건 확인
==> UNIQUE + NOT NULL
1. NULL 값을 입력 테스트
PRIMARY KEY 제야조건에 의해 deptno 컬럼에는 null 값이 들어갈 수 없다.
INSERT INTO dept_test VALUES (null, 'ddit', 'daejeon');

2. 값 중복 테스트
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
SELECT *
FROM dept_test;

첫번째 INSERT 구문에 의해 99번 부서는 dept_test 테이블에 존재
deptno 컬럼의 값이 99번인 데이터가 이미 존재하기 때문에 중복 데이터 입력이 불가능.
INSERT INTO dept_test VALUES (99, 'ddit2', '대전');

현 시점에서 dept 테이블에는 deptno 컬럼에 PRIMARY KEY 제약이 걸려있지 않은 상황

SELECT *
FROM dept;
이미 존재하는 10번부서 추가로 등록

INSERT INTO dept VALUES (10, 'ddit', 'daejeon');

테이블 생성시 제약조건 명을 설정한 경우
DROP TABLE dept_test;
컬럼명 컬럼타입 CONSTRAINT  제약조건이름 제약조건타입(PRIMARY KEY)

PRIMARY KEY 제약조건 명명 규칙 : pk_테이블명
CREATE TABLE dept_test (
    DEPTNO    NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,    
    DNAME     VARCHAR2(14),
    LOC       VARCHAR2(13) 
);

INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'ddit2', '대전');







