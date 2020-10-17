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

-- 4. Найти сведения о номерах сотрудников, получивших за какой-либо месяц
-- зарплату большую, чем средняя зарплата за 2007 г. или большую чем средняя
-- зарплата за 2008г (ОПЕРАТОРЫ ANY/ALL).
SELECT DISTINCT EMP.EMPNO
FROM EMP
         JOIN SALARY ON EMP.EMPNO = SALARY.EMPNO
WHERE SALVALUE > ANY
      (SELECT AVG(SALVALUE)
       FROM SALARY
       WHERE YEAR IN (2007, 2008)
       GROUP BY YEAR);

-- 5. Найти сведения о номерах сотрудников, получивших зарплату за какой-либо
-- месяц большую, чем средние зарплаты за все годы начислений (ОПЕРАТОРЫ ANY/ALL).
SELECT DISTINCT EMP.EMPNO
FROM EMP
         JOIN SALARY ON EMP.EMPNO = SALARY.EMPNO
WHERE SALVALUE > ANY
      (SELECT AVG(SALVALUE)
       FROM SALARY
       GROUP BY YEAR);

-- 6. Определить годы, в которые начисленная средняя зарплата была больше
-- средней зарплаты за все годы начислений (HAVING С ВЛОЖЕННЫМИ ПОДЗАПРОСАМИ).
SELECT YEAR
FROM SALARY
GROUP BY YEAR
HAVING AVG(SALVALUE) > (SELECT AVG(SALVALUE) FROM SALARY);

-- 7. Определить номера отделов, в которых работали или работают сотрудники,
-- имеющие начисления зарплаты (КОРРЕЛИРУЮЩИЕ ПОДЗАПРОСЫ).

-- Отделы, в которых хотя бы один сотрудник, у которого были/есть зарплатные
-- выплаты.
SELECT DEPTNO
FROM DEPT
WHERE (SELECT COUNT(DEPTNO)
       FROM CAREER
                JOIN SALARY ON CAREER.EMPNO = SALARY.EMPNO
       WHERE CAREER.DEPTNO = DEPT.DEPTNO) > 0;

-- Отделы, в которых хотя бы один сотрудник, у которого были/есть зарплатные
-- выплаты.
SELECT DISTINCT DEPTNO
FROM CAREER
WHERE (SELECT COUNT(EMPNO)
       FROM SALARY
       WHERE SALARY.EMPNO = CAREER.EMPNO) > 0
  AND DEPTNO IS NOT NULL;

-- 8. Определить номера отделов, в которых работали или работают сотрудники,
-- имеющие начисления зарплаты (ОПЕРАТОР EXISTS).

-- Отделы, в которых хотя бы один сотрудник, у которого были/есть зарплатные
-- выплаты.
SELECT DEPTNO
FROM DEPT
WHERE EXISTS(SELECT *
             FROM CAREER
                      JOIN SALARY ON CAREER.EMPNO = SALARY.EMPNO
             WHERE CAREER.DEPTNO = DEPT.DEPTNO);

-- Отделы, в которых хотя бы один сотрудник, у которого были/есть зарплатные
-- выплаты.
SELECT DISTINCT DEPTNO
FROM CAREER
WHERE EXISTS(SELECT *
             FROM SALARY
             WHERE SALARY.EMPNO = CAREER.EMPNO)
  AND DEPTNO IS NOT NULL;
