mybatis
SELECT : 결과가 1건이냐, 복수냐
    1건 : sqlSession.selectOne("네임스페이스.sqlid", [인자]) == overloading
            리턴타입 : resultType
    복수 : sqlSession.selectList("네임스페이스.sqlid", [인자]) == overloading
            리턴타입 : List<resultType>

EmpDad 운영코드 작성
==> 테스트 할 수 있는 테스트 코드

src/test/java
운영코드Test
EmpDaoTest


오라클 계층쿼리 : 하나의 테이블(혹은 인라인 뷰)에서 특정 행을 기준으로 다른 행을 찾아가는 문법
조인 : 테이블 - 테이블
계층쿼리 : 행 - 행

1. 시작점(행) 설정
2. 시작점과 다른 행을 연결시킬 조건을 기술

1. 시작점 : mgr이 없는 KING
2. 연결조건 : KING을 MGR컬럼으로 하는 사원
;
SELECT LPAD('기준문자열', 15, '*')
FROM dual;


SELECT LPAD(' ', (LEVEL-1)*4) || ename, LEVEL
FROM emp
START WITH ename = 'BLAKE'
CONNECT BY PRIOR empno = mgr;

최하단노드에서 상위 노드로 연결하는 상향식 연결방법
시작점 : 스미스
**PRIOR 키워드는 CONNECT BY 키워드와 떨어져서 사용해도 무관
**PRIOR 키워드는 현재 읽고 있는 행을 지칭하는 키워드
SELECT LPAD(' ', (LEVEL-1)*4) || ename, emp.*
FROM emp
START WITH ename = 'SMITH'
CONNECT BY empno = PRIOR mgr AND PRIOR hiredate < hiredate;

SELECT *
FROM dept_h;

xx회사 부터 시작하는 하향식 계층쿼리 작성 , 부서이름과 level컬럼을 이용하여 들여쓰기 표현
SELECT LPAD(' ', (LEVEL-1)*4) || deptnm
FROM dept_h
START WITH p_deptcd is NULL
CONNECT BY PRIOR deptcd = p_deptcd;

디자인팀에서 시작하는 상향식 계층쿼리
SELECT deptcd,LPAD(' ', (LEVEL-1)*4)||deptnm deptnm , p_deptcd
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;



