DECODE : 조건에 따라 반환 값이 달라지는 함수
        ==> 비교, java(if), sql(case)와 비슷
        단, 비교연산이 (=)만 가능
        
        CASE의 WHEN절에 기술할 수 있는 코드는 참 거짓 판단할 수 있는 코드면 가능
        EX : sal > 1000
        이것과 다르게 DECODE 함수에서는 sal = 1000, sal = 2000

DECODE는 가변인자(인자의 갯수가 정해지지 않았음. 상황에 따라 늘어날 수 있다.)를 갖는 함수
문법 : DESCODE(기준값[col | expression],
                비교값1, 반환값1,
                비교값2, 반환값2,
                비교값3, 반환값3,
                옵션[기준값이 비교값 중에 일치하는 값이 없을 때 기본적으로 반환할 값])

==> java
if ( 기준값 == 비교값1){
    반환값1을 반환;
}   else if ( 기준값 == 비교값2){
    반환값2를 반환;
}   else if ( 기준값 == 비교값3){
    반환값3을 반환;
} else {
    마지막 인자가 있을 경우 마지막 인자를 반환하고
    마지막 인자가 없을 경우 null을 반환
}

SELECT empno, ename,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp;

어제 작성한 위의 SQL을 DECODE

SELECT empno, ename, deptno,
        DECODE(deptno,
                        10, 'ACCOUNTING',
                        20, 'RESEARCH',
                        30, 'SALES',
                        40, 'OPERATIONS',
                        'DDIT') dname
FROM emp;

SELECT ename, job, sal,
        DECODE(job,
                    'SALESMAN', sal*1.05,
                    'MANAGER', sal*1.10,
                    'PRESIDENT', sal*1.20,
                    sal) bonus
FROM emp;

위의 문제처럼 job에 따라 sal를 인상한다.
단 추가조건으로 job이 MANAGER이면서 소속부서가 30번이면 SAL* 1.5

SELECT 
FROM emp;
SELECT empno, ename, sal,
        CASE 
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' AND deptno = '30' THEN sal * 1.5
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus
FROM emp;
-->행에서 한번 조건이 해당되면 그 아래의 when, then은 수행하지 않고 다음 행으로 넘어간다. (각 행을 기준으로 시행된다고 생각하면 될듯)
==> 또다른 방법
SELECT empno, ename, job, sal,
        CASE 
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN 
                                        CASE
                                            WHEN deptno =30 THEN sal * 1.5
                                            ELSE sal * 1.1
                                        END
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
        END bonus
FROM emp;

위의 거랑 유사한 방법
SELECT empno, ename, job, sal,
        DECODE(job,
                    'SALESMAN', sal*1.05,
                    'MANAGER', DECODE(deptno, 30,
                                                sal*1.5,
                                                sal*1.1),
                    'PRESIDENT', sal*1.20,
                    sal) bonus
FROM emp;


실습 cond2
emp테이블을 이용하여 hiredate에 따라 올해 건강보험 검진대상자인지 조회하는 쿼리를 작성하세요.
홀수년도-홀수해 출생자 / 짝수년도-짝수해 출생자

SELECT empno, ename, hiredate,
        DECODE(MOD(TO_CHAR(hiredate, 'YY'),2),
                                              MOD(TO_CHAR(SYSDATE, 'YY'),2), '대상자',
                                              '비대상자') contact_to_doctor
FROM emp;

SELECT empno, ename, hiredate,
        CASE
            WHEN MOD(TO_CHAR(hiredate,'YY'),2) = MOD(TO_CHAR(SYSDATE,'YY'),2) THEN '대상자'
            ELSE '비대상자'
        END contact_to_doctor
FROM emp;

실습 cond3

SELECT userid, usernm, REPLACE(alias, alias, ' ') alias, reg_dt,
        CASE
            WHEN MOD(TO_CHAR(reg_dt,'YY'),2) = MOD(TO_CHAR(SYSDATE,'YY'),2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END contact_to_doctor
FROM users
ORDER BY userid; 

그룹함수 : 여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
SUM : 합계
COUNT : 행의 수
AVG : 평균
MAX : 최대값
MIN : 최소값

사용방법

SELECT 행들을 묶을 기준1, 행들을 묶을 기준2, 행들을 묶을 기준3, 그룹함수, ...
FROM 테이블명
[WHERE]
GROUP BY 행들을 묶을 기준1, 행들을 묶을 기준2, 행들을 묶을 기준3, ...

1.부서번호별 SAL 컬럼의 합
==> 부서번호가 같은 행들을 하나의 행으로 만든다.;
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

2. 부서번호별 가장 큰 급여를 받는 사람의 급여액수
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;
3. 부서별 가장 작은 급여 급여액수
SELECT deptno, SUM(sal), MAX(sal), MIN(sal)
FROM emp
GROUP BY deptno;
4. 부서별 평균급여
SELECT deptno, SUM(sal), MAX(sal), MIN(sal), ROUND(AVG(sal),2)
FROM emp
GROUP BY deptno;

5.부서별 사원수(sal 컬럼이 null이 아닌 행의 수)
SELECT deptno, SUM(sal), MAX(sal), MIN(sal), COUNT(sal)
FROM emp
GROUP BY deptno;

6. 그 그룹의 행수 ( COUNT에 *를 사용하면 그 그룹의 모든 행 수를 반환)
SELECT deptno, SUM(sal), MAX(sal), MIN(sal), COUNT(sal), COUNT(comm), COUNT(*)
FROM emp
GROUP BY deptno;

그룹함수의 특징 1. : null 값을 무시
30번 부서의 사원 6명중 2명은 comm값은 null;
SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;

그룹함수의 특징 2. : GROUP BY를 적용 여러행을 하나의 행으로 묶게 되면
                    SELECT 절에 기술할 수 있는 컬럼이 제한됨
                    ==> SELECT 절에 기술되는 일반 컬럼들은 (그룹 함수를 적용하지 않은)
                        반드시 GROUP BY 절에 기술되어야 한다.
                        단, 그룹핑에 영향을 주지 않는 고정된 상수, 함수는 기술하는 것이 가능하다.;
SELECT  deptno, ename, SUM(sal)
FROM emp
GROUP BY deptno;
==> ename 이 논리적으로 말이 안되기 때문에 에러가 나온다.


그룹함수의 특징 3. : 일반 함수를 WHERE절에서 사용하는게 가능
                   WHERE UPPER('smith') = 'SMITH');
                   그룹함수의 경우 WHERE절에서 사용하는게 불가능
                   하지만 HAVING 절에 기술하여 동일한 결과를 나타낼 수 있다.;
SUM(sal)값이 9000 이상인 행만 조회하고 싶은 경우
SELECT deptno, SUM(sal)
FROM emp
WHERE SUM(sal) > 9000
GROUP BY deptno;
--> WHERE 절에 SUM을 써서 에러가 난다.

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

위의 쿼리를 HAVING절 없이 SQL 작성; -->팁 IN-LINE VIEW 사용
SELECT deptno, sum_sal
FROM (SELECT deptno, SUM(sal) sum_sal
      FROM emp
      GROUP BY deptno)
WHERE sum_sal > 9000;

SELECT 쿼리 문법 총정리
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준을 작성
EX : 부서번호별로 그룹을 만들경우 : 
    GROUP BY deptno
    
전체행을 기준으로 그룹핑을 하려면 GROUP BY 절에 어떤 컬럼을 기술해야 할까?
emp 테이블에 등록된 14명의 사원 전체의 급여 합계를 구하려면? ==> 결과는 1개의 행;
==> GROUP BY 절을 기술하지 않고 그룹함수를 조회한다.
SELECT SUM(sal)
FROM emp;
==>대신 위 처럼 사용하려면 SELECT 절에 그룹함수가 아닌 컬럼은 적지 않는다.

++ GROUP BY절에 기술한 컬럼은 SELECT절에 기술하지 않은 경우??
SELECT SUM(sal)
FROM emp
GROUP BY deptno;
==> 잘된다.

그룹함수의 제한사항
부서번호별 가잘 높은 급여를 받는 사람의 급여액
그러나 그 사람이 누구인지는 못구함. ==> 2가지 방법으로 해결 가능 (서브쿼리, 분석함수)
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;

그룹함수 이해하기 힘들다 ==> 엑셀에 데이터를 그려보자














