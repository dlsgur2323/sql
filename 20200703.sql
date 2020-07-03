실습 join 1
SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p JOIN lprod l ON (p.prod_lgu = l.lprod_gu); 

실습 join 3
SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p, buyer b
WHERE b.buyer_id = p.prod_buyer
ORDER BY p.prod_id;

SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p JOIN buyer b ON (b.buyer_id = p.prod_buyer)
ORDER BY p.prod_id;

실습 join 3
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM prod, cart, member
WHERE prod.prod_id = cart.cart_prod AND cart.cart_member = member.mem_id;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM  member JOIN cart ON (member.mem_id = cart.cart_member) JOIN prod ON (cart_prod = prod.prod_id);

CUSTOMER : 고객
PRODUCT : 제품
CYCLE : 고객 제춤 애음 주기
SELECT *
FROM cycle;

실습 join4
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid AND customer.cnm IN('brown', 'sally');

SELECT customer.cid, cnm, pid, day, cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid)
WHERE customer.cnm IN('brown', 'sally');

join5
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid AND customer.cnm IN('brown', 'sally');

SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid) JOIN product ON(cycle.pid = product.pid)
WHERE customer.cnm IN('brown', 'sally');

join6 (cycle을 먼저 그룹해서 조인해도 됨, 테이블의 행 개수가 너무 많을 경우 이게 더 효율적일 수도)
SELECT customer.cid, cnm, cycle.pid, pnm, SUM(cnt)
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, cycle.pid, pnm;

SELECT customer.cid, cnm, cycle.pid, pnm, SUM(cnt)
FROM customer JOIN cycle ON(customer.cid = cycle.cid) JOIN product ON(cycle.pid = product.pid)
GROUP BY customer.cid, cnm, cycle.pid, pnm;

join7
SELECT pid, pnm, SUM(cnt)
FROM cycle NATURAL JOIN product
GROUP BY pid, pnm;

SELECT cycle.pid, pnm, SUM(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm;

조인 성공여부로 데이터 조회를 결정하는 구분방법
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인 방법
OUTER JOIN : 조인에 실패 하더라도, 개발자가 지정한 기준이 되는 테이블의 데이터는 나오도록 하는 조인
OUTER <==> INNER JOIN

복습 - 사원의 관리자 이름을 알고싶은 상황
    조회컬럼 : 사원의 사번, 사원 이름, 사원의 관리자 사번, 사원의 관리자 이름

동일한 테이블끼리 조인 되었기 때문에 : SELF-JOIN
조인 조건을 만족하는 데이터만 조회 되었기 때문에 : INNER-JOIN
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

KING의 경우 PRESIDENT이기 때문에 mgr컬럼의 값이 null ==> 조인에 실패
==> king의 데이터는 조회되지 않음 (총 14건의 데이터 중 13건의 데이터만 조인 성공)

OUTER 조인을 이용해서 조인 테이블 중 조인의 기준이 되는 테이블을 선택하면,
 조인에 실패하더라도 기준 테이블의 데이터는 조회되도록 할 수 있다.
LEFT / RIGHT OUTER

ANSI-SQL
테이블1 JOIN 테이블2 ON(.....)
테이블1 LEFT OUTER JOIN 테이블2 ON(.....)
위 워키는 아래와 동일
테이블2 RIGHT OUTER JOIN 테이블2 ON (....)

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);





