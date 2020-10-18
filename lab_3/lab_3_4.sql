-- 1. Требуется используя значения столбца START_DATE получить дату
-- за десять дней до и после приема на работу, пол года до и после приема
-- на работу, год до и после приема на работу сотрудника JOHN KLINTON
-- (ДОБАВЛЕНИЕ, ВЫЧИТАНИЕ ДНЕЙ, МЕСЯЦЕВ, ЛЕТ).
SELECT STARTDATE,
       STARTDATE - 10             AS TEN_DAYS_BEFORE,
       STARTDATE + 10             AS TEN_DAYS_AFTER,
       ADD_MONTHS(STARTDATE, -6)  AS HALF_YEAR_BEFORE,
       ADD_MONTHS(STARTDATE, 6)   AS HALF_YEAR_AFTER,
       ADD_MONTHS(STARTDATE, -12) AS YEAR_BEFORE,
       ADD_MONTHS(STARTDATE, 12)  AS YEAR_AFTER
FROM CAREER
         JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
WHERE EMPNAME = 'JOHN KLINTON';
