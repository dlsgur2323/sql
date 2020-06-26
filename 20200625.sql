expression : 컬럼값을 가공하거나, 존재하지 않는 새로운 상수값(정해진 값)을 표현
            연산을 통해 새로운 컬럼을 조회할 수 있다.
            연산을 하더라도 해당 sql 조회 결과에만 나올 뿐이고 실제 테이블의 데이터에는 영향을 주지 않는다.
            SELECT는 테이블의 데이터에 영향을 주지 않는다.
            
SELECT sal, sal + 500, sal - 500, sal/5, sal*5, 500
FROM emp;

SELECT *
FROM dept;

날짜의 사칙연산 : 수학적으로 정의가 되어 있지 않음
sql에서는 날짜데이터 +- 정수 ==> 정수를 일자 취급
'2020년 6월 25일' + 5 ==> 2020년 6월 25일부터 5일 지난 날짜
'2020년 6월 25일' - 5 ==> 2020년 6월 25일부터 5일 이전 날짜

데이터 베이스에서 주로 사용하는 데이터 타입 : 문자, 숫자, 날짜
empno : 숫자
ename : 문자
job : 문자
mgr : 숫자
hiredate : 날짜
sal : 숫자
comm : 숫자
eptno : 숫자

테이블의 컬럼구성 정보 확인 : 
DESC 테이블명 (DESCRIBE 테이블명)

DESC emp;

not null : 데이터가 빌 수 없다.
number() : 괄호 안에는 숫자의 자리수
varchar2() : 문자, 괄호 안에는 byte

SELECT hiredate, hiredate + 5, hiredate - 5
FROM emp;

실습
* users 테이블의 컴럼 타입을 확인하고
 reg_dt 컬럼 값에 5일 뒤 날짜를 새로운 컬럼으로 표현
 조회컬럼 : userid, reg_dt, reg_dt의 5일 뒤 날짜

DESC users;

SELECT userid, reg_dt, reg_dt + 5
FROM users;

SELECT *
FROM emp;

NULL : 아직 모르는 값. 할당되지 않은 값
NULL과 숫자타입의 0은 다르다.
NULL과 문자타입의 공백은 다르다.

NULL의 중요한 특징
NULL을 피연산자로 하는 연산의 결과는 항상 NULL
ex) NULL + 500 = NULL

emp 테이블에서 sal 컬럼과 comm컬럼의 합을 새로운 컬럼으로 표현
조회 컬럼 : empno, ename, sal, comm, sal과 comm의 합

ALIAS : 컬럼이나, EXPRSSION에 새로운 이름을 부여
적용 방법: 컬럼, EXPRESSION [AS] 별칭명
별칭을 소문자로 적용하고 싶은 경우 : 별칭명을 더블 쿼테이션("")으로 묶는다.(공백을 넣을 수도 있게된다.)

SELECT empno, ename, sal s,
       comm AS "commition",
       sal + comm AS sal_plus_comm,
       sal + comm AS "sal plus comm"
FROM emp;

실습 SELECT 2

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

literal : 값 자체
literal 표기법 : 값을 표현하는 방법.
ex : test 라는 문자열을 표기하는 방법
java : System.out.println("test") . java에서는 더블쿼테이션("")로 문자열을 표기한다.

SQL : 'test' . sql 에서는 싱글 쿼테이션으로 문자열을 표기

번외
int small = 10;
java 대입 연산자 : =
pl/sql 대입연산자 : t=

언어마다 연산자 표기, literal 표기법이 다르기 때문에 해당 언어에서 지정하는 방식을 잘 따라야 한다.

문자열 연산 : 결합
일상생활에서 문자열 결합 연산자가 존재??
java에서 문자열 결합 연산자 : +
sql에서 문자열 결합 연산자 : ||
sql에서 문자열 결합 함수 : concat(문자열1, 문자열2) ==> 문자열1||문자열2
                        두개의 문자열을 인자로 받아서 결합 후 결과를 리턴

user테이블의 userid컬럼과 usernm 컬럼을 결합
SELECT userid, usernm, userid || usernm  id_name, concat(userid, usernm) concat_id_name
FROM users;

임의 문자열 결합 ( sal+500, '아이디 :' || userid)

SELECT '아이디 : ' || userid, 500, 'test'
FROM users;

문자열 결합 실습 (sel_col1)
SELECT ' SELECT * FROM ' || TABLE_NAME || ';' query
FROM user_tables;

SELECT concat(concat(' SELECT * FROM ', TABLE_NAME), ';') query
FROM user_tables;

WHERE : 테이블에서 조회할 행의 조건을 기술
        WHERE 절에 기술한 조건이 참일 때 해당 행을 조회한다.
        SQL에서 가장 어려운 부분, 많은 응용이 발생하는 부분

SELECT *
FROM users
WHERE userid = 'brown';

emp 테이블에서 deptno 컬럽의 값이 30보다 크거나 같은 행을 조회, 컬럼은 모든 컬럼

SELECT *
FROM emp
WHERE deptno >= 30;

emp 총 행수 : 14
SELECT *
FROM emp
WHERE 1 = 2 ;

WHERE 은 논리성만 따지면 된다. (반드시 열과 관련될 필요가 없다.)

DATE 타입에 대한 WHERE절 조건 기술
emp 테이블에서 hiredate 값이 1982. 1월 1일 이후인 사원들만 조회

SQL에서 DATE 리터럴 표기법 : 'RR/mm/dd'
단, 서버 설정마다 표기법이 다르다. 따라서 사용 비권장
한국 : yy/mm/dd
미국 : mm/dd/yy
국가별로 해석이 다르기 때문에 DATE 리터럴 보다는 문자열은 DATE 타입으로 변경해주는 함수를 주로 사용
TO_DATE('날짜물자열', '첫번째 인자의 형식')

DATE 리터럴 표기법으로 실행
SELECT *
FROM emp
WHERE hiredate >= '82/01/01';

TO_DATE를 통해 문자열을 DATE 타입으로 변경 후 실행
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'yyyy/mm/dd');

SELECT *
FROM NLS_SESSION_PARAMETERS;

BETWEEN AND : 두 값 사이에 위치한 값을 참으로 인식
사용방법 : 비교값 BETWEEN 시작값 AND 종료값;
비교값이 시작값과 종료값을 포함하여 사이에 있으면 참으로 인식

emp 테이블에서 sal 값이 1000보다 크거나 같고 2000보다 작거나 같은 사원들만 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

sal BETWEEN 1000 AND 2000 조건을 부등호로 나타낸다면?
sal >= 1000 이면서(AND) sal <= 2000

SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000;

실습 (BETWEEN AND 실습 where1)

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN '1982/01/01' AND '1983/01/01';

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= '1982/01/01' AND hiredate <='1983/01/01';

IN 연산자 : 비교값이 나열된 값에 포함될 때 참으로 인식
사용방법 : 비교값 IN (비교대상 값1, 값2, 값3, ...)

사원의 소속 부서가 10번 혹은 20번인 사원을 조회하는 SQL을 IN연산자로 작성
SELECT *
FROM emp
WHERE deptno IN(10, 20);

IN연산자를 사용하지 않고 OR 연산을 통해서도 동일한 결과 조회
SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;








