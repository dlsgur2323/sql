OUTER JOIN < == > INNER JOIN
INNER JOIN : 조인 조건을 만족하는 데이터만 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 기준이 되는 테이블 쪽의 데이터(컬럼)는 조회가 되도록 하는 조인 방식

OUTER JOIN :
            LEFT OUTER JOIN : 조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
            RIGHT OUTER JOIN : 조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
            FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복되는 것 제외  <-- 쓰는 경우가 드물다

ANSI-SQL
FROM 테이블1 LEFT OUTER JOIN 테이블2 ON (조인조건)

ORACLE-SQL : 데이터가 없는데 나와야 하는 테이블의 컬럼
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼(+)

ANSI-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

OUTER JOIN 시 조인 조건(ON 절에 기술) 과 일반 조건(WHERE 절에 기술) 적용 시 주의사항
: OUTER JOIN을 사용하는데 WHERE절에 별도의 다른 조건을 기술하면 원하는 결과가 안나올 수 있다.
==> OUTER JOIN의 결과가 무시

ANSI-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10); <== OUTER 조인은 제대로 작동

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;
위의 쿼리는 OUTER JOIN을 적용하지 않은 것과 동일한 결과를 나타낸다.

ORACLE-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
        AND m.deptno(+) = 10;

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
        AND m.deptno = 10;

RIGHT OUTER JOIN : 기준 테이블이 오른쪽
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno); : 14건
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno); : 21건


FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복제거
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

ORACLE-SQL에서는 FULL OUTER 문법을 제공하지 않음

FULL OUTER 검증
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
MINUS
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);



SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


WHERE : 행을 제한
JOIN : 
GROUP FUNCTION :

시도 : 서울특별시, 충청남도
시군구 : 강남구, 청주시
스토어 구분
순위, 시도, 시군구, 버거 도시발전지수(소수점 2자리까지)
정렬은 순위가 높은 행이 가장 먼저 나오도록
발전지수 = 
            (KFC + 버거킹 + 맥도날드)  / 롯데리아 갯수
;
방법 1-1
SELECT gb, sido, sigungu, count(*)
FROM fastfood
WHERE gb IN ('롯데리아','버거킹','KFC','맥도날드')
GROUP BY gb, sido, sigungu
ORDER BY SIGUNGU;

SELECT sido, sigungu, count(*) l_cnt
FROM fastfood
WHERE gb = '롯데리아'
GROUP BY sido, sigungu;

SELECT sido, sigungu, count(*) b_cnt
FROM fastfood
WHERE gb = '버거킹'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, count(*) k_cnt
FROM fastfood
WHERE gb = 'KFC'
GROUP BY sido, sigungu
ORDER BY sido;

SELECT sido, sigungu, count(*) m_cnt
FROM fastfood
WHERE gb = '맥도날드'
GROUP BY sido, sigungu;

SELECT ROWNUM lank, a.*
FROM
    (SELECT sido, sigungu, ROUND(NVL((kfc + mac + burk) / lott, 0),2) indices
     FROM
         (SELECT mc.sido, mc.sigungu, NVL(k_cnt, 0) kfc, NVL(m_cnt, 0) mac, NVL(b_cnt, 0) burk, l_cnt lott
          FROM 
               (SELECT sido, sigungu, count(*) m_cnt
               FROM fastfood
               WHERE gb = '맥도날드'
               GROUP BY sido, sigungu) mc,
                   (SELECT sido, sigungu, count(*) l_cnt
                   FROM fastfood
                   WHERE gb = '롯데리아'
                   GROUP BY sido, sigungu) lo,
                       (SELECT sido, sigungu, count(*) b_cnt
                       FROM fastfood
                       WHERE gb = '버거킹'
                       GROUP BY sido, sigungu) bu,  
                           (SELECT sido, sigungu, count(*) k_cnt
                           FROM fastfood
                           WHERE gb = 'KFC'
                           GROUP BY sido, sigungu) kf
          WHERE mc.sigungu = lo.sigungu AND mc.sido = lo.sido
               AND mc.sigungu = bu.sigungu AND mc.sido = bu.sido
               AND mc.sigungu = kf.sigungu AND mc.sido = kf.sido)
     ORDER BY indices DESC) a;
 
 
 방법 1-2

SELECT m.sido, m.sigungu, ROUND(m/d, 2) indices
FROM
(SELECT gb, sido, sigungu, count(*) m
FROM fastfood
WHERE gb IN ('롯데리아','버거킹','KFC','맥도날드')
GROUP BY gb, sido, sigungu) m,
(SELECT gb, sido, sigungu, count(*) d
FROM fastfood
WHERE gb = '롯데리아'
GROUP BY gb, sido, sigungu) d
WHERE m.sido = d.sido AND m.sigungu = d.sigungu
ORDER BY indices DESC;

1-3
SELECT sido, sigungu, 
        ROUND((NVL(SUM(DECODE(gb, 'kfc', 1)),0) +
        NVL(SUM(DECODE(gb, '맥도날드', 1)),0) +
        NVL(SUM(DECODE(gb, '버거킹', 1)),0)) /
        NVL(SUM(DECODE(gb, '롯데리아', 1)),1),2) score
FROM fastfood
WHERE gb IN ('kfc', '맥도날드', '버거킹', '롯데리아')
GROUP BY sido, sigungu
ORDER BY score DESC;


SELECT sido, sigungu,
        ROUND(NVL(SUM(DECODE(storecategory, 'BURGER KING',1)),0) +
        NVL(SUM(DECODE(storecategory, 'MACDONALD',1)),0) +
        NVL(SUM(DECODE(storecategory, 'KFC',1)),0) /
        NVL(SUM(DECODE(storecategory, 'LOTTERIA',1)),1),2) SCORE
FROM burgerstore
WHERE storecategory IN ('BURGER KING', 'MACDONALD', 'LOTTERIA', 'KFC')
GROUP BY sido, sigungu
ORDER BY SCORE DESC;


