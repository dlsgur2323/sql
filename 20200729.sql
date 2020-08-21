정규화 몇 단계?
1-2-3-BCNF-4-5

정규화 순서 : 순서대로 하는게 맞음

정규화 : 데이터 상태이상을 방지

정규화 끝나고 나서 물리적인 고려 : 반정규화
NOMALIZATION                   DE-NOMALIZATION




pl/sql record type
java에서 클래스를 인스턴스로 생성하려면
1. class 생성
2. 1번에서 생성한 class를 확룡하여 new 연산자를 통해 instance 생성

dept 테이블의 10번 부서의 부서번호, 부서이름을 pl/sql record type으로 생성된 변수에 값을 담아서 출력
(dept 모든 컬럼을 조회하는 것이 아니라, 일부 컬럼만 조회)

TYPE 선언 방법:
TYPE 타입이름(CLASS 이름짓기) IS RECORD(
    컬럼명1 타입명1,
    컬럼명2 타입명2, ...
);
    변수명 변수타입;
    변수명 타입이름
    
SET SERVEROUTPUT ON;

DECLARE
    TYPE dept_rec_type IS RECORD (
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE
    );
    
    dept_rec dept_rec_type;
BEGIN
    SELECT deptno, dname INTO dept_rec
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('deptno : ' || dept_rec.deptno || ', dname : ' || dept_rec.dname);
END;
/

TABLE TYPE : 여러건의 행을 저장할 수 있는 타입
dept 테이블의 모든 행을 담아보는 실습

TABLE TYPE 선언
TYPE 테이블 타입 이름 IS TABLE OF 행의 타입(ROW, RECORD) INDEX BY BINARY_INTEGER

테이블 타입의 인덱스느 java와 다르게 1부터 시작한다!


DECLARE
    TYPE dept_tab_type IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
        dept_tab dept_tab_type;
BEGIN
    SELECT * BULK COLLECT INTO dept_tab
    FROM dept;
    FOR i IN 1.. dept_tab.count LOOP 
    DBMS_OUTPUT.PUT_LINE('deptno : ' || dept_tab(i).deptno);
    END LOOP;
END;
/

조건제어 - 분기(if)
구문
IF condition THEN
    실행할 문장
ELSIF condition THEN
    실행할 문장
ELSE 
    실행할 문장
END IF;

DECLARE
    p NUMBER := 2;
BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('P=1');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('P=2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ELSE');
    END IF;
END;
/

FOR LOOP
문법
FOR 인덱스변수 IN [REVERSE] 시작값..종료값 LOOP
    반복실행할 문장;
END LOOP;


DECLARE
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/



BEGIN
    FOR i IN 2..9 LOOP
        FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || ' * ' || j || ' = ' || i*j);
        END LOOP;
    END LOOP;
END;
/



while
문법
    WHILE 조건 LOOP
        반복할 문장;
    END LOOP;    
1~5
DECLARE
    i NUMBER := 0;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i +1;
    END LOOP;
END;
/

loop
    문법
    LOOP
        반복 실행할 문장;
        EXIT 탈출조건
        반복 실행할 문장;
    END LOOP;

DECLARE
    i NUMBER := 0;
BEGIN
    LOOP
        EXIT WHEN i > 5;
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
    END LOOP;
END;
/


CURSOR : SELECT 문이 실행되는 메모리 상의 공간
        다량의 데이터를 변수에 담게되면 메모리 낭비가 심해져 프로그램이 정상적으로 동작 못할 수도 있음.
        
        한번에 모든 데이터를 인출하지 않고, 개발자가 직접 인출 단계를 제어 함으로써
        변수에 모든 데이터를 담지 않고도 개발하는 것이 가능

CURSOR의 종류
묵시적 커서 : 커서이름을 별도로 지정하지 않을 경우 ==> ORACLE이 알아서 처리해줌
명시적 커서 : 커서를 명시적 이름과 함께 선언하고, 개발자가 해당 커서를 직접 제어 가능

CURSOR 사용 방법
1. 커서 선언 (DECLARE)
    CURSOR 커서이름 IS
        SELECT 쿼리;
2. 커서 열기
    OPEN 커서이름;
3. FETCH (인출)
    FETCH 커서이름 INTO 변수
4. 커서 닫기
    CLOSE 커서이름;

dept 테이블의 모든 행에 대해 부서번호, 부서이름을 cursor를 통해 데이터를 다루는 실습

DECLARE
    CURSOR dept_cur IS
        SELECT deptno, dname
        FROM dept;
        
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    OPEN dept_cur;
    LOOP
        FETCH dept_cur INTO v_deptno, v_dname;
        EXIT WHEN dept_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_deptno || ', ' || v_dname);
    END LOOP;
    CLOSE dept_cur;
END;
/

CURSOR의 경우 반복문과 사용되는 일이 많기 때문에 
PL/SQL에서는 FOR LOOP 문과 함께 사용하는 문법을 지원한다.
문법
    FOR 레코드명 IN 커서명 LOOP
        반복실행할 문장;
    END LOOP;
OPEN, FETCH,CLOSE : 2~4단계 - FOR LOOP에서 해결


DECLARE
    CURSOR dept_cur IS
        SELECT deptno, dname
        FROM dept;
BEGIN
    FOR dept_row IN dept_cur LOOP
        DBMS_OUTPUT.PUT_LINE(dept_row.deptno || ', ' || dept_row.dname);
    END LOOP;
END;
/

emp 테이블에서 특성 부서에 속하는 사원의 사번과 이름을 출력하는 로직을
파라미터가 있는 커서를 활용하여 작성하는 실습

DECLARE

    CURSOR emp_cur (p_deptno dept.deptno%TYPE) IS
        SELECT empno, ename
        FROM emp
        WHERE deptno = p_deptno;

BEGIN
    FOR emp_row IN emp_cur(30) LOOP
        DBMS_OUTPUT.PUT_LINE(emp_row.empno || ', ' || emp_row.ename);
    END LOOP;
END;
/

인라인 뷰
인라인 커서
FOR LOOP 기술시 커서를 직접 기술

BEGIN
    FOR dept_row IN (SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE(dept_row.deptno || ', ' || dept_row.dname);
    END LOOP;
END;
/


DECLARE
    sum NUMBER := 0;
    TYPE dt_tab_type IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
        dt_tab dt_tab_type;
    
BEGIN
    SELECT * BULK COLLECT INTO dt_tab
    FROM dt;
    
    FOR i IN 1.. (dt_tab.count-1) LOOP
        sum := sum + dt_tab(i).dt - dt_tab(i+1).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE((dt_tab.count-1));
END;
/

DECLARE
    TYPE dept_tab_type IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
        dept_tab dept_tab_type;
BEGIN
    SELECT * BULK COLLECT INTO dept_tab
    FROM dept;
    FOR i IN 1.. dept_tab.count LOOP 
    DBMS_OUTPUT.PUT_LINE('deptno : ' || dept_tab(i).deptno);
    END LOOP;
END;
/




SELECT *
FROM dt;







