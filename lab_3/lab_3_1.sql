-- 1. Выдать информацию о местоположении отдела продаж (SALES) компании
-- (ПРОСТЕЙШИЕ ЗАПРОСЫ).
SELECT DEPTADDR
FROM DEPT
WHERE DEPTNAME = 'SALES';

-- 2. Выдать информацию об отделах, расположенных в Chicago и New York
-- (ПРОСТЕЙШИЕ ЗАПРОСЫ).
SELECT *
FROM DEPT
WHERE DEPTADDR = 'CHICAGO'
   OR DEPTADDR = 'NEW YORK';

-- 3. Найти минимальную заработную плату, начисленную в 2009 году (ФУНКЦИИ).
SELECT MIN(SALVALUE)
FROM SALARY
WHERE YEAR = 2009;

-- 4. Выдать информацию обо всех работниках, родившихся не позднее 1 января
-- 1960 года (ФУНКЦИИ).
SELECT *
FROM EMP
WHERE BIRTHDATE <= TO_DATE('01-01-1960', 'DD-MM-YY');

-- 5. Подсчитать число работников, сведения о которых имеются в базе данных
-- (ФУНКЦИИ).

-- Кол-во сотрудников, о которых есть какие-либо сведения.
SELECT COUNT(*) AS NUMBER_OF_EMP
FROM EMP;

-- Кол-во сотрудников, о которых есть какие-либо все сведения.
SELECT COUNT(*) AS NUMBER_OF_EMP
FROM EMP
WHERE BIRTHDATE IS NOT NULL
  AND MANAGER_ID IS NOT NULL;

-- 6. Найти работников, чьё имя состоит из одного слова. Имена выдать на нижнем
-- регистре, с удалением стоящей справа буквы t (ФУНКЦИИ).

-- С удалением одной стоящей справа буквы t.
SELECT REGEXP_REPLACE(LOWER(EMPNAME), 't$') AS EMPNAME, BIRTHDATE
FROM EMP
WHERE REGEXP_COUNT(EMPNAME, '[^ ]+') = 1;

-- C удалением всех стоящих справа буквы t.
SELECT RTRIM(LOWER(EMPNAME), 't') AS EMPNAME, BIRTHDATE
FROM EMP
WHERE REGEXP_COUNT(EMPNAME, '[^ ]+') = 1;

-- 7.	Выдать информацию о работниках, указав дату рождения в формате
-- день(число), месяц(название), год(название) (ФУНКЦИИ).
SELECT EMPNAME, TO_CHAR(BIRTHDATE, 'DD, MONTH, YEAR') AS BIRTHDATE, MANAGER_ID
FROM EMP;
-- Тоже, но год числом.
SELECT EMPNAME, TO_CHAR(BIRTHDATE, 'DD, MONTH, YYYY') AS BIRTHDATE, MANAGER_ID
FROM EMP;

-- 8.	Выдать информацию о должностях, изменив названия должности “CLERK” и
-- “DRIVER” на “WORKER” (ФУНКЦИИ).
SELECT JOBNO, REGEXP_REPLACE(JOBNAME, 'CLERK|DRIVER', 'WORKER'), MINSALARY
FROM JOB;

-- 9. Определите среднюю зарплату за годы, в которые были начисления не менее
-- чем за три месяца (HAVING).
SELECT YEAR, COUNT(MONTH) AS MONTH_COUNT, AVG(SALVALUE) AS AVERAGE_SAL
FROM SALARY
GROUP BY YEAR
HAVING COUNT(MONTH) >= 3
ORDER BY YEAR;

-- 10. Выведете ведомость получения зарплаты с указанием имен служащих
-- (СОЕДИНЕНИЕ ПО РАВЕНСТВУ).
SELECT EMPNAME, SALARY.*
FROM SALARY
         JOIN EMP ON EMP.EMPNO = SALARY.EMPNO;

-- 11. Укажите  сведения о начислении сотрудникам зарплаты, попадающей в вилку:
-- минимальный оклад по должности - минимальный оклад по должности плюс пятьсот.
-- Укажите соответствующую вилке должность (СОЕДИНЕНИЕ НЕ ПО РАВЕНСТВУ).
SELECT SALARY.*, JOBNAME
FROM CAREER
         JOIN JOB ON CAREER.JOBNO = JOB.JOBNO
         JOIN SALARY ON CAREER.EMPNO = SALARY.EMPNO
WHERE SALVALUE BETWEEN MINSALARY AND MINSALARY + 500;
