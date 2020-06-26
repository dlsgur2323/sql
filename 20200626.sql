WHERE 절에서 사용 가능한 연산자 : LIKE
사용용도 : 문자의 일부분으로 검색을 하고 싶을 때 사용
            ex : ename 컬럼의 값이 s로 시작하는 사원들을 조회

사용방법 : 컬럼 LIKE '패턴문자열'
마스킬 문자열 : 1. % : 문자가 없거나, 어떤 문자든 여러개의 문자열
                    's%' : s로 시작하는 모든 문자열
                          s, ss, SMITH

              2. _ : 어떤 문자든 딱 하나의 문자를 의미
                    's_' : s로 시작하고 두번째 문자열가 어떤 문자든 하나의 문자가 오는 2자리 문자열
                    's____' : s로 시작하고 전체 문자열의 길이가 5글자인 문자열 (즉 문자열의 자릿수를 정해주는 의미)

emp 테이블에서 ename 컬럼의 값이 S로 시작하는 사원들만 조회


SELECT *
FROM emp
WHERE ename LIKE 'S%';

실습 where 4
member 테이브에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리 작성

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

실습 where 5
member 테이블에서 회원의 이름에 [이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리
하기 전에 테이블 수정사항(선생님이 해주심)
UPDATE member set mem_name= '쁜이'
WHERE mem_id = 'b001';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

NULL비교 : = 연산자로 비교 불가 ==> IS 로 비교
NULL을  =로 비교하여 조회

comm 컬럼의 값이 null인 사원들만 조회
SELECT empno, ename, comm
FROM emp
WHERE comm = NULL;

NULL 값에 대한 비교는 IS 연산자를 사용한다.
SELECT empno, ename, comm
FROM emp
WHERE comm IS NULL;

where 6 문제
emp테이블에서 comm 값이 NULL이 아닌 데이터를 조회
SELECT empno, ename, comm
FROM emp
WHERE comm IS NOT NULL;

논리연산자 : AND, OR, NOT
and : 판단식 두개를 동시에 만족하는 행만 참
        일반적으로 AND 조건이 많이 붙으면 조회되는 행의 수가 줄어든다.
or : 판단식 두개 중에 하나만 만족하면 참

nor : 조건을 반대로 해석하는 부정형 연산
        NOT IN
        IS NOT NULL

emp 테이블에서 mgr 값이 7698이면서 sal 값이 1000보다 큰 사원 조회
2가지 조건을 동시에 만족하는 사원 리스트
SELECT *
FROM emp
WHERE mgr = 7698 AND sal > 1000;

mgr 값이 7698이거나 (5명)
sal 값이 1000보다 크거나 (12명) 두개의 조건을 하나라도 만족하는 행을 조회
SELECT *
FROM emp
WHERE mgr = 7698 OR sal > 1000;

emp 테이블에서 mgt가 7698, 7839가 아닌 사원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839);
++++ mgr 컬럼에 NULL값이 있을 경ㅇ 비교 연산으로 NULL 비교가 불가하기 때문에 NULL 을 갖는 행은 무시된다.

mgr 사번이 7698이 아니고, 7839가 아니고, null이 아닌 직원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839, NULL);
++++ not 이 아닌 IN(7698, 7839, NULL) 은 조회 가능 할 때도 있다.


실습 where7
emp 테이블에서 job이 SALESMAN 이고 입사일자가 1981년 06 01일 이후인 직원의 정보를 다음과 같이 조회하세요

SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate > TO_DATE('19810601', 'YYYY/MM/DD');

실습 where 8
emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요 ( IN, NOT IN 금지)

SELECT *
FROM emp
WHERE deptno != 10 AND hiredate > TO_DATE('19810601', 'YYYY/MM/DD');

실습 where 9
whwere8번 조건을 NOT IN을 사용하여 조회

SELECT *
FROM emp
WHERE deptno NOT IN (10) AND hiredate > TO_DATE('19810601','YYYY/MM/DD');

실습 where10
emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
SELECT *
FROM emp
WHERE deptno IN (20, 30) AND hiredate > TO_DATE('19810601','YYYY/MM/DD');

실습 where11
emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate > TO_DATE('19810601','YYYY/MM/DD');

실습 where 12 -13
emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%'; --형변환 : 명시적, 묵시적

LIKE 쓰지말고 위의 정보 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899 OR empno BETWEEN 780 AND 789 OR empno = 78;

연산자 우선순위
*, / > +, -
3 + 5 * 7 = 38

일반 수학과 마찬가지로 괄호()로 우선순위를 변경 할 수 있다.

실습 where 14
emp테이블에서 job이 SALESMAN 이거나 사원번호가 78로 시작하면서 입사일자가 1981 06 01 이후인 직원의 정보를 다음과 같이 조회

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%' AND hiredate > TO_DATE('19810601','YYYY/MM/DD'));


정렬
RDBMS 집합적인 사상을 따른다.,.
집합에는 순서가 없다. (1, 3, 5) == (3, 5, 1)
집합에는 중복이 없다. (1, 3, 5, 1) == (3, 5, 1)

데이터 정렬 (ORDER BY)
사용 방법 (컬럼 뒤에 [ ASC | DESC] 를 기술하여 오름차순 내림차순 지정 가능)
1. ORDER BY 컬럼
2. ORDER BY 별칭
3. ORDER BY SELECT 절에 나열된 컬럼의 인덱스 번호
SELECT *
FROM emp
ORDER BY ename; -- 기본 오름차순 

SELECT *
FROM emp
ORDER BY ename DESC; --내림차순

별칭으로 ORDER BY
SELECT empno, ename, sal, sal*12 salary
FROM emp
ORDER BY salary;

SELECT절에 기술된 컬럼순서(인덱스)로 정렬
SELECT empno, ename, sal, sal*12 salary
FROM emp
ORDER BY 4;

실습 orderby 1 
dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

실습 orderby2
emp테이블에서 상여정보가 있는 사람만 조회하고, 상여를 많이 받는 사람이 먼저 조회되고, 상여가 같은경우 사번으로 내림차순 정렬(상여가 0인 사람은 상여가 없는 것으로 간주)
SELECT *
FROM emp
WHERE comm != 0
ORDER BY comm DESC, empno DESC;












