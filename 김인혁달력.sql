달력만들기 수정1;
SELECT  
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM    (SELECT (TO_DATE(:month, 'YYYYMM') + level -1) dt,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level -1,'D') d,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')+ level,'IW') iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY sat;

달력만들기 수정2
SELECT 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM    
        (SELECT (TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D') + level) dt,
                TO_CHAR((TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D') + level),'D') d,
                TO_CHAR(TO_DATE(:month, 'YYYYMM')-TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D')+ level+1,'IW') iw
         FROM dual
         CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'DD')+ TO_CHAR(TO_DATE(:month, 'YYYYMM'),'D')-1 +
                                    (7-TO_CHAR(LAST_DAY(TO_DATE(:month, 'YYYYMM')), 'D')))
GROUP BY iw
ORDER BY sun;