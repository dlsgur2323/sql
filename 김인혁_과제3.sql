실습 orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job , empno DESC;

실습 orderby4
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename DESC;