-- 1. Найти имена сотрудников, получивших за годы начисления зарплаты
-- минимальную зарплату (ПОДЗАПРОСЫ, ВЫБИРАЮЩИЕ ОДНУ СТРОКУ).
SELECT EMP.EMPNAME
FROM EMP
         JOIN (SELECT DISTINCT CAREER.EMPNO
               FROM CAREER
                        JOIN JOB ON CAREER.JOBNO = JOB.JOBNO
                        JOIN SALARY ON CAREER.EMPNO = SALARY.EMPNO
               WHERE SALVALUE = MINSALARY) SUBQUERY
              ON EMP.EMPNO = SUBQUERY.EMPNO;

-- 2. Найти имена сотрудников, работавших или работающих в тех же отделах,
-- в которых работал или работает сотрудник с именем RICHARD MARTIN (ПОДЗАПРОСЫ,
-- ВОЗВРАЩАЮЩИЕ БОЛЕЕ ОДНОЙ СТРОКИ).
SELECT EMPNAME
FROM EMP
         JOIN (SELECT DISTINCT CAREER.EMPNO
               FROM CAREER
                        JOIN (SELECT DEPTNO
                              FROM CAREER
                                       JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
                              WHERE EMPNAME = 'RICHARD MARTIN') DEPTNUMS
                             ON CAREER.DEPTNO = DEPTNUMS.DEPTNO) EMPNUMS
              ON EMP.EMPNO = EMPNUMS.EMPNO;

-- 3. Найти имена сотрудников, работавших или работающих в тех же отделах и
-- должностях, что и сотрудник 'RICHARD MARTIN' (СРАВНЕНИЕ БОЛЕЕ ЧЕМ ПО ОДНОМУ
-- ЗНАЧЕНИЮ).

-- Работавших в тех же отделах или в тех же должностях.
SELECT EMPNAME
FROM EMP
         JOIN (SELECT DISTINCT CAREER.EMPNO
               FROM CAREER
                        JOIN (SELECT DEPTNO, JOBNO
                              FROM CAREER
                                       JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
                              WHERE EMPNAME = 'RICHARD MARTIN') DEPT_JOB_NUMS
                             ON CAREER.DEPTNO = DEPT_JOB_NUMS.DEPTNO OR
                                CAREER.JOBNO = DEPT_JOB_NUMS.JOBNO) EMPNUMS
              ON EMP.EMPNO = EMPNUMS.EMPNO;

-- Работавших в тех же отделах и в тех же должностях.
SELECT EMPNAME
FROM EMP
         JOIN (SELECT DISTINCT CAREER.EMPNO
               FROM CAREER
                        JOIN (SELECT DEPTNO, JOBNO
                              FROM CAREER
                                       JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
                              WHERE EMPNAME = 'RICHARD MARTIN') DEPT_JOB_NUMS
                             ON CAREER.DEPTNO = DEPT_JOB_NUMS.DEPTNO AND
                                CAREER.JOBNO = DEPT_JOB_NUMS.JOBNO) EMPNUMS
              ON EMP.EMPNO = EMPNUMS.EMPNO;
