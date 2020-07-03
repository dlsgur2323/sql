SELECT empno, ename, sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal>2500
ORDER BY dept.dname;

SELECT empno, ename, sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal>2500 AND empno > 7600;

SELECT empno, ename, sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal>2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY ename;