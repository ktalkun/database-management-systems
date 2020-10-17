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
