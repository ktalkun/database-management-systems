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
