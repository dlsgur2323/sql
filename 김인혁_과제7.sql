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

CREATE INDEX idx_nu_emp_01 ON emp (empno);
CREATE INDEX idx_nu_emp_02 ON emp (deptno, sal);
CREATE INDEX idx_nu_dept_01 ON dept (deptno, loc);


선생님 답안

1. emp : empno(=){e.1}
2. dept : deptno(=){d.1}
3. emp : deptno(=), empno(like)
    dept : deptno(=){d.1}
4. emp : deptno(=), sal(between)
5. emp : deptno(=){d.1}
    dept : deptno(=), [loc(=)]{d.1}
    
    emp : deptno(=){d.1}
    dept : loc(=)
    
    
emp : 1.(empno)
        2. deptno, empno
        3. deptno, sal
        
        2-2. deptno, empno, sal
        
dept : 1. (deptno, loc)
        2. loc

























