GROUP 함수의 특징.
1. NULL은 그룹함수 연산에서 제외된다.

부서번호별 사원의 sal, comm 컬럼의 합
NULL을 무시하는것은 행간 연산에 해당하고 열끼리의 연산에서는 주의를 해야한다.
SELECT deptno, sum(sal + comm), sum(sal + NVL(comm, 0)), SUM(sal) + SUM(comm)
FROM emp
GROUP BY deptno;


SELECT deptno, SUM(sal) + NVL(SUM(comm), 0)
FROM emp
GROUP BY deptno;

SELECT deptno, SUM(sal) + SUM(NVL(comm, 0)
FROM emp
GROUP BY deptno;
==> 위의 방법이 좀 더 효율적 (NVL을 SUM값 한번에만 처리하면 되기 때문)

실습 GRP1
emp 테이블을 이용하여 다음을 구하시오
1. 직원 중 가장 높은 급여
2. 직원 중 가장 낮은 급여
3. 직원의 급여 평균(소수점 두자리까지 나오게)
4. 직원의 급여 합
5. 직원 중 급여가 있는 직원의 수
6. 직원 중 상급자가 있는 직원의 수
7. 전체 직원의 수

SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;

실습 grp3
emp테이블을 이용하여 다음을 구하시오
grp2 에서 작성한 쿼리를 활용하여
deptno 대신 부서명이 나올 수 있도록 수정하시오
SELECT DECODE(deptno,
                     10, 'ACCOUNTING',
                     20, 'RESEARCH',
                     30, 'SALES') dname,
       MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY dname;

실습 grp4
emp테이블을 이용하여
직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성

SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy, count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');


실습 grp6
회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리(dept테이블 사용)

SELECT COUNT(*) cnt
FROM dept;

실습 grp7
직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오 emp 테이블 사용
SELECT COUNT(*)
FROM
    (SELECT deptno
     FROM  emp
     GROUP BY deptno);

SELECT COUNT(COUNT(deptno))
FROM emp
GROUP BY deptno;

JOIN : 컬럼을 확장하는 방법 (데이터를 연결한다)
       다른 테이블의 컬럼을 가져온다.
RDBMS가 중복을 최소화하는 구조이기 때문에
하나의 테이블에 데이타를 전부 담지 않고, 목적에 맞게 설계한 테이블에 데이터가 분산이 된다.
하지만 데이터를 조회할 때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다.

ANSI-SQL : American National Standard Institute SQL
ORACLE-SQL 문법

JOIN : ANST-SQL
       ORACLE-SQL의 차이가 다소 발생

ANSI-SQL join
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로 행을 연결
               컬럼 이름 뿐만 아니라 데이터 타입도 동일해야함.

문법 :
SELECT 컬럼...
FROM 테이블1 NATURAL JOIN 테이블2

emp, dept 두 테이블에 공통된 이름을 갖는 컬럼 : deptno
;
SELECT *
FROM emp NATURAL JOIN dept;
--> 조인 조건으로 사용된 컬럼은 테이블 한정자를 적용하지 못한다.
SELECT emp.empno, emp.ename, deptno, dept.dname
FROM emp NATURAL JOIN dept;

위의 쿼리를 oracle 로 변경
오라클에서는 조인조건을 WHERE절에 기술
행을 제한하는 조건, 조인조건 ==> WHERE 절에 기술

SELECT emp.*, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
==> 이름이 동일한 컬럼으로 조인조건을 쓸때 한정자를 붙여준다.
WHERE emp.deptno != dept.deptno; --> != 를 사용하면 각 컬럼의 값이 동일하지 않은 행들의 값들을 조인해준다.

조인 테이블간 동일한 이름의 컬럼이 복수개 인데
일부로만 조인을 하고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING (deptno);
--> 위는 안티, 아래는 오라클
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANTI-SQL : JOIN WITH ON
위에서 배운 NATYRAL JOIN, JOIN with USING의 경우 조인 테이블의 조인컬럼 이름이 같아야 한다는 제약조건이 있음.
설계상 두 테이블의 컬럼이름이 다를 수 있음. 다를 경우 개발자가 직업 조인조건을 기술할 수 있도록 제공해주는 문법

SELECT *
FROM emp, JOIN dept ON (emp.deptno = dept.deptno);
--> 위는 안티 아래는 오라클
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELF-JOIN : 동일한 테이블끼리 조인 할 때 지정하는 명칭
            (별도의 키워드가 아니다)
         ;   
SELECT 사원번호, 사원이름, 사원의 상사 사원번호, 사원의 상사 이름
FROM emp;

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

사원 중 사원의 번호가 7369~7698인 사원만 대상으로 해당 사원의
사원번호, 이름, 상사의 사원번호, 상사의 이름
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


NON-EQUI-JOIN : 조인 조건이 =이 아닌 조인
!= : 값이 다르면 연결

급여등급 조회하기
SELECT *
FROM salgrade;

SELECT empno, ename, sal, grade 
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;


실습 join0
emp dept 테이블을 이용하여 다음과 같이 조회

SELECT empno, ename, emp.deptno, dname 
FROM emp, dept
WHERE emp.deptno = dept.deptno;

실습 join0_1
emp, dept테이블 이용
부서번호가 10, 30인 데이터만 조회

SELECT empno, ename, emp.deptno, dname 
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.deptno IN (10, 30);

SELECT empno, ename, emp.deptno, dname 
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.deptno IN (10, 30);



