emp
1. empno(=)
2. deptno(=), sal(between) 


deptno
1. deptno(=)

emp dept
1. deptno(=), empno(like)
2. deptno(=), loc(=)

(empno)
(deptno sal)

(deptno loc)

CREATE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_u_emp_02 ON emp (deptno, sal);
CREATE INDEX idx_i_dept_01 ON deptno (deptno loc);
