실습 outerjoin1
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b RIGHT JOIN prod p ON (b.buy_prod = p.prod_id AND buy_date = TO_DATE('20050125', 'YY/MM/DD'));

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
      AND buy_date(+) = TO_DATE('20050125', 'YY/MM/DD');


실습 outerjoin2
SELECT NVL(buy_date, TO_DATE('20050125', 'YY/MM/DD')), buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b RIGHT JOIN prod p ON (b.buy_prod = p.prod_id AND buy_date = TO_DATE('20050125', 'YY/MM/DD'));

SELECT NVL(buy_date, TO_DATE('20050125', 'YY/MM/DD')), buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
      AND buy_date(+) = TO_DATE('20050125', 'YY/MM/DD');

      
실습 outerjoin3
SELECT NVL(buy_date, TO_DATE('20050125', 'YY/MM/DD')), buy_prod, prod_id, prod_name, NVL(buy_qty,0)
FROM buyprod b RIGHT JOIN prod p ON (b.buy_prod = p.prod_id AND buy_date = TO_DATE('20050125', 'YY/MM/DD'));

SELECT NVL(buy_date, TO_DATE('20050125', 'YY/MM/DD')), buy_prod, prod_id, prod_name, NVL(buy_qty,0)
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
      AND buy_date(+) = TO_DATE('20050125', 'YY/MM/DD');


실습 outerjoin4
SELECT p.pid, pnm, NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid AND c.cid(+) = 1;

SELECT p.pid, pnm, NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM cycle c RIGHT JOIN product p ON (c.pid = p.pid AND c.cid = 1);


실습 outerjoin 5
SELECT p.pid, pnm, NVL(c.cid,1) cid, NVL(cnm,'brown'), NVL(day,0) day, NVL(cnt,0) cnt
FROM cycle c, product p, customer s
WHERE c.pid(+) = p.pid AND c.cid = s.cid(+)
        AND c.cid(+) = 1;

SELECT p.pid, pnm, NVL(c.cid,1) cid, NVL(cnm,'brown'), NVL(day,0) day, NVL(cnt,0) cnt
FROM cycle c RIGHT JOIN product p ON (c.pid = p.pid AND c.cid = 1) LEFT JOIN customer s ON (c.cid = s.cid);







