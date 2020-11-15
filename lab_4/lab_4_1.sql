-- 1. Поднимите нижнюю границу минимальной заработной платы в таблице JOB до
-- 1000$.
UPDATE JOB
SET MINSALARY = 1000
WHERE MINSALARY = (SELECT MIN(MINSALARY) FROM JOB);

-- 2. Поднимите минимальную зарплату в таблице JOB на 10% для всех
-- специальностей, кроме финансового директора.
UPDATE JOB
SET MINSALARY = MINSALARY * 0.1
WHERE JOBNAME != 'FINANCIAL DIRECTOR';

-- 3. Поднимите минимальную зарплату в таблице JOB на 10% для клерков и на 20%
-- для финансового директора (одним оператором).
UPDATE JOB
SET MINSALARY =
        CASE
            WHEN JOBNAME = 'CLERK' THEN MINSALARY * 0.1
            WHEN JOBNAME = 'FINANCIAL DIRECTOR' THEN MINSALARY * 0.2
            END
WHERE JOBNAME = 'CLERK'
   OR JOBNAME = 'FINANCIAL DIRECTOR';

-- 4. Установите минимальную зарплату финансового директора равной 90% от
-- зарплаты исполнительного директора.
UPDATE JOB
SET MINSALARY = (SELECT MINSALARY
                 FROM JOB
                 WHERE JOBNAME = 'EXECUTIVE DIRECTOR') * 0.9
WHERE JOBNAME = 'FINANCIAL DIRECTOR';

-- 5. Приведите в таблице EMP имена служащих, начинающиеся на букву 'J',
-- к нижнему регистру.
UPDATE EMP
SET EMPNAME = LOWER(EMPNAME)
WHERE SUBSTR(EMPNAME, 0, 1) = 'J';

-- 6. Измените в таблице EMP имена служащих, состоящие из двух слов, так, чтобы
-- оба слова в имени начинались с заглавной буквы, а продолжались прописными.
UPDATE EMP
SET EMPNAME = INITCAP(EMPNAME)
WHERE REGEXP_LIKE(EMPNAME, '^\w+ \w+$');

UPDATE EMP
SET EMPNAME = INITCAP(EMPNAME)
WHERE LENGTH(EMPNAME) - LENGTH(REPLACE(EMPNAME, ' ', '')) + 1 = 2;

-- 7. Приведите в таблице EMP имена служащих к верхнему регистру.
UPDATE EMP
SET EMPNAME = UPPER(EMPNAME);

-- 8. Перенесите отдел исследований (RESEARCH) в тот же город, в котором
-- расположен отдел продаж (SALES).
UPDATE DEPT
SET DEPTADDR = (SELECT DEPTADDR
                FROM DEPT
                WHERE DEPTNAME = 'SALES')
WHERE DEPTNAME = 'RESEARCH';

-- 9. Добавьте нового сотрудника в таблицу EMP. Его имя и фамилия должны
-- совпадать с Вашими, записанными латинскими буквами согласно паспорту, дата
-- рождения также совпадает с Вашей.
INSERT INTO EMP (EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID)
VALUES (7532, 'KIRYL TALKUN', '16/09/1999', 7790);

-- 10. Определите нового сотрудника (см. предыдущее задание) на работу в
-- бухгалтерию (отдел ACCOUNTING) начиная с текущей даты.
INSERT INTO CAREER (JOBNO, EMPNO, DEPTNO, STARTDATE, ENDDATE)
VALUES ((SELECT JOBNO
         FROM JOB
         WHERE JOBNAME = 'CLERK'),
        (SELECT EMPNO
         FROM EMP
         WHERE EMPNAME = 'KIRYL TALKUN'),
        (SELECT DEPTNO
         FROM DEPT
         WHERE DEPTNAME = 'ACCOUNTING'),
        SYSDATE,
        NULL);

-- 11. Удалите все записи из таблицы TMP_EMP. Добавьте в нее информацию о
-- сотрудниках, которые работают клерками в настоящий момент.
CREATE TABLE TMP_EMP AS
SELECT *
FROM EMP;

DELETE
FROM TMP_EMP;

INSERT INTO TMP_EMP (EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID)
SELECT EMP.EMPNO,
       EMP.EMPNAME,
       EMP.BIRTHDATE,
       EMP.MANAGER_ID
FROM EMP
         JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO
         JOIN JOB ON CAREER.JOBNO = JOB.JOBNO
WHERE JOBNAME = 'CLERK'
  AND ENDDATE IS NULL;

DROP TABLE TMP_EMP;

-- 12. Добавьте в таблицу TMP_EMP информацию о тех сотрудниках, которые уже не
-- работают на предприятии, а в период работы занимали только одну должность.
CREATE TABLE TMP_EMP AS
SELECT *
FROM EMP;

DELETE
FROM TMP_EMP;

INSERT INTO TMP_EMP (EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID)
SELECT EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID
FROM EMP
WHERE EMPNO IN (SELECT CAREER.EMPNO
                FROM CAREER
                         RIGHT JOIN (SELECT CAREER.EMPNO
                                     FROM CAREER
                                     GROUP BY CAREER.EMPNO
                                     HAVING COUNT(CAREER.EMPNO) = 1) RIGHT_CAREER
                                    ON CAREER.EMPNO = RIGHT_CAREER.EMPNO
                WHERE ENDDATE < SYSDATE);

DROP TABLE TMP_EMP;

-- 13. Выполните тот же запрос для тех сотрудников, которые никогда не приступали
-- к работе на предприятии.
INSERT INTO TMP_EMP (EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID)
SELECT EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID
FROM EMP
WHERE EMPNO IN (SELECT DISTINCT EMPNO
                FROM CAREER);

INSERT INTO TMP_EMP (EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID)
SELECT EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID
FROM EMP
WHERE EMPNO IN (SELECT DISTINCT EMPNO
                FROM CAREER
                WHERE STARTDATE IS NULL
                   OR STARTDATE > SYSDATE);

-- 14. Удалите все записи из таблицы TMP_JOB и добавьте в нее информацию по тем
-- специальностям, которые не используются в настоящий момент на предприятии.
CREATE TABLE TMP_JOB AS
SELECT *
FROM JOB;

DELETE
FROM TMP_JOB;

INSERT INTO TMP_JOB (JOBNO, JOBNAME, MINSALARY)
SELECT JOBNO, JOBNAME, MINSALARY
FROM JOB
WHERE JOBNO NOT IN (SELECT DISTINCT JOBNO
                    FROM CAREER
                    WHERE ENDDATE IS NULL
                       OR ENDDATE > SYSDATE);

DROP TABLE TMP_JOB;

-- 15. Начислите зарплату в размере 120% минимального должностного оклада всем
-- сотрудникам, работающим на предприятии. Зарплату начислять по должности,
-- занимаемой сотрудником в настоящий момент и отнести ее на прошлый месяц
-- относительно текущей даты.
INSERT INTO SALARY (EMPNO, MONTH, YEAR, SALVALUE)
SELECT EMPNO,
       TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'MM'),
       TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYY'),
       MINSALARY * 1.2
FROM CAREER
         JOIN JOB ON CAREER.JOBNO = JOB.JOBNO
WHERE ENDDATE IS NULL
   OR ENDDATE > SYSDATE;
