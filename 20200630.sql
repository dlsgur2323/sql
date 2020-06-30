날짜관련 오라클 내장함수
내장함수 : 탑재가 되어있다.
            오라클에서 제공해주는 함수 (많이 사용하니까, 개발자가 별도로 개발하지 않도록)

(활용도 :*) MONTHS_BETWEEN(date1, date2) : 두 날짜 사이의 개월수를 반환  1.23414개월 ( 이게 몇개월??)
(활용도 :*****)ADD_MONTHS(date1, number) : date1 날짜에 number 만큼의 개월수를 더하고 뺀 날짜 변환
(활용도 :***)NEXT_DAY(date1, 주간요일(1~7) : date 이후에 등장하는 첫번째 주간요일의 날짜 반환
                                                20200630, 6 ==> 20200703 (가장 가까운 금요일)
(활용도 :***)LAST_DAY(date1) : date1 날짜가 속한 월의 마지막 날짜 반환
                                20200605 ==> 20200630
                                모든 달의 첫번째 날짜는 1일로 정해져 있으나 마지막 날짜를 다른 경우가 있다.
                                윤년의 경우 2월이 29일임.;

SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate)
FROM emp;


ADD_MONTHS;
SELECT ADD_MONTHS(SYSDATE, 5) aft5,
        ADD_MONTHS(SYSDATE, -5) bef5
FROM dual;

NEXT_DAY : 해당 날짜 이후에 등장하는 첫번째 주간요일의 날짜
SELECT NEXT_DAY(SYSDATE, 7)
FROM dual;

LAST_DAY : 해당 일자가 속한 얼의 마지막 일자를 반환
SELECT LAST_DAY(TO_DATE('2020/06/05', 'YYYY/MM/DD'))
FROM dual;

LAST_DAY는 있는데 FIRST_DAY는 없다. (모든 월의 시작은 1일로 동일하기 때문)

FIRST_DAY 직접 SQL로 구현
SYSDATE : 20200630 ==> 20200601

1. SYSDATE를 문자로 변경하는데 포맷을 YYYYMM
2. 1번의 결과에다가 문자열 결합을 통해 '01' 이라는 문자를 뒤에 붙여준다.
    YYYYMMDD
3. 2번의 결과를 날짜 타입으로 변경

SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYYMMDD') first_day
FROM dual;

경력자와 초보자의 차이 : 에러의 발생 시 얼마나 빨리 파악하냐 


date실습 fn3
- 파라미터로 yyyymm형식의 문자열을 사용 하여 해당 년월에 해당하는 일자 수를 구해보세요

SELECT '201912' param, TO_CHAR(LAST_DAY(TO_DATE('201912', 'YYYYMM')), 'DD') dt
FROM dual;

바인드 변수 이용

SELECT :param param, TO_CHAR(LAST_DAY(TO_DATE(:param, 'YYYYMM')), 'DD') dt
FROM dual;

실행계획 : DBMS가 요청받은 SQL을 처리하기 위해 세운 절차
          SQL 자체에는 로직이 없다. (어떻게 처리해라?? 가 없다. JAVA랑 다른점임)
실행계획 보는 방법:

1.실행계획을 생성
EXPLAIN PLAN FOR
실행계획을 보고자 하는 SQL;

2. 실행계획을 보는 단계
SELECT *
FROM TABLE(dbms_xplan.display);

empno 컬럼은 NUMBER 타입이지만 형변환이 어떻게 일어났는지 확인하기 위해
의도적으로 문자열 상수 비교를 진행

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

실행계획 읽는 방법 :
1. 위에서 아래로
2. 단 자식 노드가 있으면, 자식 노드부터 읽는다.
    자식노드 : 들여쓰기가 된 노드
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);



EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(dbms_xplan.display);

6,000,000 <====> 6000000
국제화 : i18n
    날짜 국가별로 형식이 다르다.
        한국 : yyyy-mm-dd
        미국 : mm-dd-yyyy
    숫자
        한국 : 9,000,000.00
        독일 : 9.000.000,00

sal (NUMBER) 컬럼의 값을 문자열 포멧팅 적용
SELECT ename, sal, TO_NUMBER(TO_CHAR(sal, 'L9,999.00'), 'L9,999.00')
FROM emp;

NULL과 관련된 함수 : NULL값을 다른값으로 치환하거나, 다른값을 강제로 NULL로 만드는 것 
1. NVL(expr1, expr2)
    if(expr1 == null){
        expr2를 반환;
    } else {
        expr1을 반환;
    }
SELECT empno, sal, comm, NVL(comm, 0),
       sal + comm, sal + nvl(comm, 0)
FROM emp;

    
2. NVL2(expr1, expr2, expr3)
    if(expr1 != null){
        expr2를 반환;
    } else {
        expr3를 반환;
    }
SELECT empno, sal, comm, NVL2(comm, comm, 0),
       sal + comm, sal + NVL2(comm, comm, 0)
FROM emp;


3. NULLIF(expr1, expr2) : null 값을 생성하는 목적
    if(expr1 == expr2){
        null을 반환;
    } else {
        expr1을 반환;
    }
SELECT ename, sal, comm, NULLIF(sal, 3000)
FROM emp;


4. COALESCE(expr1, expr2, ... ) : 인자중에 가장 처음으로 null값이 아닌 값을 갖는 인자를 반환
COALESCE(NULL, NULL, 30, NULL, 50) ==> 30
    IF(expr1 != null){
        expr1 을 반환;
    } else {
        COALESCE(expr2, ...)
    }

SELECT COALESCE(NULL, NULL, 30, NULL, 50)
FROM dual;

NULL 처리 실습
emp 테이블에 14명의 사원이 존재, 한명을 추가(INSERT)

INSERT INTO emp (empno, ename, hiredate) VALUES(9999, 'brown', NULL);
조회컬럼 ename, mgr, mgr컬럼 값이 null이면 111로 치환한 값=null이 아니면 mgr컬럼값, hiredate, hiredate가 null이면 sysdate로 표기
                                                                                null이 아니면 hiredate컬럼값으로
SELECT ename, mgr , NVL(mgr, 111), hiredate, NVL(hiredate, SYSDATE)
FROM emp;

NULL실습 fn4
- emp테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요(nvl, nvl2, coalesce)
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n, NVL2(mgr, mgr, 9999) mgr_n_1, COALESCE(mgr, 9999) mgr_n_2
FROM emp;


null 실습 fn5
- users테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
    reg_dt가 null일 경우 sysdate를 적용

SELECT userid, usernm, TO_CHAR(reg_dt, 'YY/MM/DD'), TO_CHAR(NVL(reg_dt, SYSDATE), 'YY/MM/DD') n_reg_dt
FROM users
WHERE userid != 'brown'; --> 브라운~~ 노오오오오우

SELECT ROUND(6/28* 100, 2) || '%'
FROM dual;

SQL 조건문
CASE
    WHEN 조건문(참 거짓 판단할 수 있는 문장) THEN 반환할 값
    WHEN 조건문(참 거짓 판단할 수 있는 문장) THEN 반환할 값2
    WHEN 조건문(참 거짓 판단할 수 있는 문장) THEN 반환할 값3
    ELSE 모든 WHEN절을 만족시키지 못할 때 반환할 기본값
END ==> 하나의 컬럼으로 취급

emp 테이블에 저장된 job 컬럼의 값을 기준으로 급여(sal)를 인상시키려고 한다.
sal컬럼과 함께 인상된 sal컬럼의 값을 비교하고 싶은 상황
급여 인상 기준
job이 SALESMAN :  5%인상 sal * 1.05
      MANAGER : 10% 인상
      PRESIDENT : 20%
      나머지는 : 인상 X

SELECT ename, job, sal,
       CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
            ELSE sal
       END inc_sal
FROM emp;

실습 cond1
- emp테이블을 이용하여 deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는 쿼리를 작성하세요

SELECT empno, ename,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp
WHERE empno != 9999;




