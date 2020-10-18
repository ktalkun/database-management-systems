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

-- 2. Требуется найти разность между двумя датами и представить результат в днях.
-- Вычислите разницу в днях между датами приема на работу сотрудников
-- JOHN MARTIN и ALEX BOUSH (ОПРЕДЕЛЕНИЕ КОЛИЧЕСТВА ДНЕЙ МЕЖДУ ДВУМЯ ДАТАМИ).
SELECT MARTIN_STARTDATE,
       BOUSH_STARTDATE,
       ABS(MARTIN_STARTDATE - BOUSH_STARTDATE) AS DAYS_BETWEEN_DATES
FROM (SELECT STARTDATE AS MARTIN_STARTDATE
      FROM CAREER
               JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
      WHERE EMPNAME = 'JOHN MARTIN'),
     (SELECT STARTDATE AS BOUSH_STARTDATE
      FROM CAREER
               JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
      WHERE EMPNAME = 'ALEX BOUSH');

SELECT STARTDATE, EMPNAME
FROM CAREER
         JOIN EMP ON CAREER.EMPNO = EMP.EMPNO;

-- 3. Требуется найти разность между двумя датами в месяцах и в годах
-- (ОПРЕДЕЛЕНИЕ КОЛИЧЕСТВА МЕСЯЦЕВ ИЛИ ЛЕТ МЕЖДУ ДАТАМИ).
SELECT MARTIN_STARTDATE,
       BOUSH_STARTDATE,
       FLOOR(ABS(MONTHS_BETWEEN(MARTIN_STARTDATE, BOUSH_STARTDATE)))
           AS MONTHS_BETWEEN_DATES,
       FLOOR(ABS(MONTHS_BETWEEN(MARTIN_STARTDATE, BOUSH_STARTDATE)) / 12)
           AS YEARS_BETWEEN_DATES
FROM (SELECT STARTDATE AS MARTIN_STARTDATE
      FROM CAREER
               JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
      WHERE EMPNAME = 'JOHN MARTIN'),
     (SELECT STARTDATE AS BOUSH_STARTDATE
      FROM CAREER
               JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
      WHERE EMPNAME = 'ALEX BOUSH');

-- 4. Требуется определить интервал времени в днях между двумя датами.
-- Для каждого сотрудника 20-го отдела найти сколько дней прошло между датой
-- его приема на работу и датой приема на работу следующего сотрудника
-- (ОПРЕДЕЛЕНИЕ ИНТЕРВАЛА ВРЕМЕНИ МЕЖДУ ТЕКУЩЕЙ И СЛЕДУЮЩЕЙ ЗАПИСЯМИ).
SELECT STARTDATE,
       COALESCE(TO_CHAR(ABS(
                   STARTDATE - LEAD(STARTDATE) OVER (ORDER BY STARTDATE))),
                'undefined') AS STARTDATE_DAYS_BETWEEN_FOR_NEAR_EMPLOYEE
FROM CAREER
WHERE DEPTNO = 20;

-- 5. Требуется подсчитать количество дней в году по столбцу START_DATE
-- (ОПРЕДЕЛЕНИЕ КОЛИЧЕСТВА ДНЕЙ В ГОДУ).
SELECT STARTDATE,
       ADD_MONTHS(TRUNC(STARTDATE, 'YYYY'), 12) - TRUNC(STARTDATE, 'YYYY')
           AS DAYS_PER_YEAR_OF_STARTDATE
FROM CAREER;

-- 6. Требуется разложить текущую дату на день, месяц, год, секунды, минуты,
-- часы. Результаты вернуть в численном виде (ИЗВЛЕЧЕНИЕ ЕДИНИЦ ВРЕМЕНИ ИЗ ДАТЫ).
SELECT SYSDATE,
       TO_CHAR(SYSDATE, 'DD')   AS DAY,
       TO_CHAR(SYSDATE, 'MM')   AS MONTH,
       TO_CHAR(SYSDATE, 'YYYY') AS YEAR,
       TO_CHAR(SYSDATE, 'SS')   AS SECOND,
       TO_CHAR(SYSDATE, 'MI')   AS MINUTE,
       TO_CHAR(SYSDATE, 'HH24') AS HOUR
FROM DUAL;
