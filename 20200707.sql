시도, 시군구별, 햄버거 도시발전지수 ==> kfc + 버거킹 + 맥도날드 / 롯데리아

한 행에 다음과 같이 컬럼이 구성되면 공식을 쉽게 적용할 수 있다.

시도, 시군구, kfc개수, 버거킹 개수, 맥도날드 개수, 롯데리아 개수

주어진 것 : 점포 하나 하나의 주소
1. 시도, 시군구 프랜차이즈 별로 GROUP BY *4

1-1. 시도, 시군구, KFC개수
1-2. 시도, 시군구, 버거킹 개수
1-3. 시도, 시군구, 맥도날드 개수
1-4. 시도, 시군구, 롯데리아 개수

1.1~1.4 4개의 데이터셋을 이용해서 컬럼 확장이 가능함 ==> JOIN
시도, 시군구 같은 데이터끼리 조인

2. 시도, 시군구, 프랜차이즈 별로 GROUP BY * 2
 2.1 시도, 시군구, 분자 프랜차이즈 합 개수
 2.2 시도, 시군구, 분모 프랜차이즈(롯데리아) 합 개수
 
2.1~2.2 2개의 테이터 셋을 이용해서 컬럼 확장 ==> JOIN
 시도, 시군구 같은 데이터끼리 조인


3. 모든 프랜차이즈를 한번만 읽고서 처리하는 방법
 3.1 fastfood 테이블의 한행은 하나의 프랜차이즈에 속함
 3.2 가상의 컬럼을 4개 생성
 3.3 해당 row가 kfc 이면 1
     해당 row가 mac이면 1
     해당 row가 버거킹이면 1
     해당 row가 롯데리아면 1

 3.4 3.3 과정에서 생성된 컬럼 4개중에 값이 존재하는 컬럼은 하나만 존재함.
        (하나의 행은 하나의 프랜차이즈 주소를 나타내는 정보)
 3.5 시도, 시군구별로 3.4 과정에서 생성한 컬럼을 더하면 우리가 구하고자 하는 프랜차이즈별 건수가 된다.

;
SELECT sido, sigungu, SUM(DECODE(gb,'롯데리아', 1)), SUM(DECODE(gb,'KFC', 1)),
                        SUM(DECODE(gb,'버거킹', 1)), SUM(DECODE(gb,'맥도날드', 1))
FROM fastfood
WHERE gb IN ('KFC', '롯데리아', '버거킹', '맥도날드')
GROUP BY sido, sigungu;

SELECT ROWNUM rn, sido, sigungu, indices
FROM
    (SELECT sido, sigungu,  ROUND((NVL(SUM(DECODE(storecategory,'MACDONALD', 1)),0)+ 
                                 NVL(SUM(DECODE(storecategory,'KFC', 1)),0) +
                                 NVL(SUM(DECODE(storecategory,'BURGER KING', 1)),0)) /
                                 NVL(SUM(DECODE(storecategory,'LOTTERIA', 1)),1),2) indices
    FROM burgerstore
    WHERE storecategory IN ('KFC', 'LOTTERIA', 'BURGER KING', 'MACDONALD')
    GROUP BY sido, sigungu
    ORDER BY indices DESC) burger;


SELECT *
FROM tax;

순위, 햄버거 발전지수 시도, 햄버거 발전지수 시군구, 햄버거 발전지수,
근로소득 순위, 근로소득 시도, 근로소득 시군구, 1인당 근로소득액
같은 순위끼리 하나의 행에 데이터가 보여지도록

햄발순위, 시도, 시군구, 햄지수, 햄발순위에 대한 근로소득 순위, 시도, 시군구, 1인당 근로소득액
1, 서울, 강남구, 6.4, 1, 울산, 동구, 80
2, 강원, 춘천시, 6, 2, 서울, 강남구, 70
SELECT ROWNUM rn, sido, sigungu, gni
    FROM
        (SELECT sido, sigungu, ROUND(sal / people,2) gni
        FROM tax
        ORDER BY gni DESC);


SELECT burger.*, income.*
FROM
    (SELECT ROWNUM rn, sido, sigungu, gni
    FROM
        (SELECT sido, sigungu, ROUND(sal / people,2) gni
        FROM tax
        ORDER BY gni DESC)) income,
   (SELECT ROWNUM rn, sido, sigungu, indices
    FROM
        (SELECT sido, sigungu,  ROUND((NVL(SUM(DECODE(storecategory,'MACDONALD', 1)),0)+ 
                                     NVL(SUM(DECODE(storecategory,'KFC', 1)),0) +
                                     NVL(SUM(DECODE(storecategory,'BURGER KING', 1)),0)) /
                                     NVL(SUM(DECODE(storecategory,'LOTTERIA', 1)),1),2) indices
        FROM burgerstore
        WHERE storecategory IN ('KFC', 'LOTTERIA', 'BURGER KING', 'MACDONALD')
        GROUP BY sido, sigungu
        ORDER BY indices DESC)) burger
WHERE burger.rn(+) = income.rn
ORDER BY income.rn;


CROSS JOIN : 테이블간 조인 조건을 기술하지 않는 형태로
             두 테이블의 행간 모든 가능한 조합으로 조인이 되는 형태
크로스 조인의 조회결과를 필요로 하는 메뉴는 거의 없음
* SQL 중간 단계에서 필요한 경우는 존재

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d;
--WHERE e.deptno = d.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e CROSS JOIN dept d;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e JOIN dept d ON (1=1);

ORACLE-SQL 에서는 WHERE절에 아무런 조건도 기술하지 않으면 적용
ANSI-SQL에서는 CROSS JOIN 으로 명시 또는 ON 절에 항상 TRUE가 되는 조건 기술

실습 crossjoin1

SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c, product p;

SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c CROSS JOIN product p;

SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c JOIN product p ON(1=1);


SUBQUERY : SQL 내부에서 사용된 SQL (Main 쿼리에서 사용된 쿼리)
사용위치에 따른 분류
1. SELECT 절 : scalar(단일의) subquery
2. FROM 절 : IN-LINE-VIEW
3. WHERE 절 : SUBQUERY

반환하는 행, 컬럼 수에 따른 분류
1. 단일행, 단일컬럼
2. 단일행, 복수컬럼
3. 다중행, 단일컬럼
4. 다중행, 복수컬럼

서브쿼리에서 메인쿼리의 컬럼을 사용하는 유무에 따른 분류
1. 서브쿼리에서 메인쿼리의 컬럼 사용 :correlated subquery ==> 상호 연관 서브쿼리
                            ==> 서브쿼리 단독으로 실행하는 것이 불가능
2. 서브쿼리에서 메인쿼리의 컬럼 미사용 : non correlated subquery ==> 비상호 연관 서브쿼리
                            ==> 서브쿼리 단독으로 실행하는 것이 가능
SMITH 사원이 속한 부서에 속하는 사원들은 누가 있을까????

2번의 쿼리가 필요
1. SMITH가 속한 부서의 번호를 확인하는 쿼리
2. 1번에서 확인한 부서번호로 해당 부서에 속하는 사원들을 조회하는 쿼리
1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';
2.
SELECT *
FROM emp
WHERE deptno = 20;

SMITH가 현재 상황에서 속한 부서는 20번인데
나중에 30번 부서로 부서전배가 이뤄지면
2번에서 작성한 쿼리가 수정이 되어야 한다.
WHERE deptno = 20 ==> WHERE deptno = 30

우리가 원하는 것은 고정된 부서번호로 사원 정보를 조회하는 것이 아니라, SMITH 가 속한 부서를 통해 데이터를 조회
==> SMITH가 속한 부서가 바뀐다 하더라도 쿼리를 수정하지 않도록 하는것.

위에서 작성한 두개의 쿼리를 하나로 합칠 수 있다.
==> SMITH의 부서번호가 변경 되더라도 우리가 원하는 데이터 셋을 쿼리 수정없이 조회할 수 있다 ==> 코드변경이 필요없다. ==> 유지보수가 편하다
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

SUBQUERY는 WHERE절에서 기술되고 그 것을 사용하는 쿼리를 메인쿼리라 한다.

1. 스칼라 서브쿼리 : SELECT 절에서 사용된 서브쿼리
* 제약사항 : 반드시 서브쿼리가 하나의 행, 하나의 컬럼을 반환 해야한다.

스칼라 서브쿼리가 다중행 복수컬럼을 리턴하는 경우 (x)
SELECT empno, ename, (SELECT deptno, dname FROM dept)
FROM emp;

스칼라 서브쿼리가 단일행 복수컬럼을 리턴하는 경우 (x)
SELECT empno, ename, (SELECT deptno, dname FROM dept WHERE deptno =10)
FROM emp;

스칼라 서브쿼리가 단일행, 단일컬럼을 리턴하는 경우 (o)
SELECT empno, ename,
        (SELECT deptno FROM dept WHERE deptno =10) deptno,
        (SELECT dname FROM dept WHERE deptno =10) dname
FROM emp;

메인 쿼리의 컬럼을 사용하는 스칼라 서브쿼리
SELECT empno, ename, deptno,
            (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

IN-LINE VIEW : 그동안 많이 사용


SUBQUERY : WHERE 절에서 사용된 것
SMITH가 속한 부서에 속하는 사원들 조회
WHERE 절에서 서브 쿼리 사용시 주의점
연산자와 서브쿼리의 반환 행 수 주의
= 연산자 사용시 서브쿼리에서 여러개의 행(값)을 리턴하면 논리적으로 맞지가 않다.
 IN연산자를 사용시 서브쿼리에서 리턴하는 여러개 행(값)과 비교가 가능
SMITH 20 ALLEN 30 
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'ALLEN'));


실습 sub1

SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);   

실습 sub2
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);   








