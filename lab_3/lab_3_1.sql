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
