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

-- 7. Требуется получить первый и последний дни текущего месяца
-- (ОПРЕДЕЛЕНИЕ ПЕРВОГО И ПОСЛЕДНЕГО ДНЕЙ МЕСЯЦА).
SELECT SYSDATE,
       TRUNC(SYSDATE, 'MM') AS FIRST_DAY_OF_MONTH,
       LAST_DAY(SYSDATE)    AS LAST_DAY_OF_MONTH
FROM DUAL;

-- 8. Требуется возвратить даты начала и конца каждого из четырех кварталов
-- данного года (ВЫБОР ВСЕХ ДАТ ГОДА, ВЫПАДАЮЩИХ НА ОПРЕДЕЛЕННЫЙ ДЕНЬ НЕДЕЛИ).

-- Текущая дата усекается для каждой колонки.
SELECT ROWNUM                AS QUARTER_NUM,
       TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), (ROWNUM - 1) * 3),
               'DD-MM-YYYY') AS STARTDATE,
       TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), ROWNUM * 3) - 1,
               'DD-MM-YYYY') AS ENDDATE
-- FROM SYS.ODCINUMBERLIST(1,2,3,4)
-- WHERE ROWNUM <= 4;
FROM DUAL
CONNECT BY ROWNUM <= 4;

-- Текущая дата усекается в подзапросе и в основной запросе используется уже
-- усечённая дата.
SELECT QUARTER_NUM,
       TO_CHAR(ADD_MONTHS(CURR_DATE, (QUARTER_NUM - 1) * 3),
               'DD-MM-YYYY') AS STARTDATE,
       TO_CHAR(ADD_MONTHS(CURR_DATE, (QUARTER_NUM - 1) * 3 - 1),
               'DD-MM-YYYY') AS ENDDATE
FROM (SELECT ROWNUM AS              QUARTER_NUM,
             TRUNC(SYSDATE, 'YEAR') CURR_DATE
--       FROM SYS.ODCINUMBERLIST(1,2,3,4)
--       WHERE ROWNUM <= 4
      FROM DUAL
      CONNECT BY ROWNUM <= 4);

-- 9. Требуется найти все даты года, соответствующие заданному дню недели.
-- Сформируйте список понедельников текущего года.

-- Запрос привязан к русском у языку
SELECT TO_CHAR(DATE_BY_DAY, 'DD-MM-YYYY') AS DATE_BY_DAY
FROM (SELECT TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1                 AS DATE_BY_DAY,
             TO_CHAR(TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1, 'DAY') AS DAY
      FROM DUAL
      CONNECT BY TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1 <
                 ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12))
WHERE DAY = 'ПОНЕДЕЛЬНИК';

-- Запрос не привязан к русскому языка
SELECT TO_CHAR(DATE_BY_DAY, 'DD-MM-YYYY') AS DATE_BY_DAY
FROM (SELECT TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1               AS DATE_BY_DAY,
             TO_CHAR(TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1, 'D') AS DAY
      FROM DUAL
      CONNECT BY TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1 <
                 ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12))
WHERE DAY = '1';

-- 10. Требуется создать календарь на текущий месяц. Календарь должен иметь
-- семь столбцов в ширину и пять строк вниз (СОЗДАНИЕ КАЛЕНДАРЯ).

-- Календарь на текущий месяц (с номерами недель).
SELECT TO_CHAR(DT, 'IW')                                     AS WEEK,
       MAX(DECODE(TO_CHAR(DT, 'D'), '1', TO_CHAR(DT, 'DD'))) AS MON,
       MAX(DECODE(TO_CHAR(DT, 'D'), '2', TO_CHAR(DT, 'DD'))) AS TUE,
       MAX(DECODE(TO_CHAR(DT, 'D'), '3', TO_CHAR(DT, 'DD'))) AS WED,
       MAX(DECODE(TO_CHAR(DT, 'D'), '4', TO_CHAR(DT, 'DD'))) AS THU,
       MAX(DECODE(TO_CHAR(DT, 'D'), '5', TO_CHAR(DT, 'DD'))) AS FRI,
       MAX(DECODE(TO_CHAR(DT, 'D'), '6', TO_CHAR(DT, 'DD'))) AS SAT,
       MAX(DECODE(TO_CHAR(DT, 'D'), '7', TO_CHAR(DT, 'DD'))) AS SUN
FROM (SELECT TRUNC(SYSDATE, 'MM') + ROWNUM - 1 AS DT
      FROM DUAL
      CONNECT BY TRUNC(SYSDATE, 'MM') + ROWNUM - 1 <
                 ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1))
GROUP BY TO_CHAR(DT, 'IW')
ORDER BY WEEK;

-- Календарь на текущий год (с номерами недель).
SELECT TO_CHAR(DT, 'Month YYYY')                             AS MONTH,
       TO_CHAR(DT, 'IW')                                     AS WEEK,
       MAX(DECODE(TO_CHAR(DT, 'D'), '1', TO_CHAR(DT, 'DD'))) AS MON,
       MAX(DECODE(TO_CHAR(DT, 'D'), '2', TO_CHAR(DT, 'DD'))) AS TUE,
       MAX(DECODE(TO_CHAR(DT, 'D'), '3', TO_CHAR(DT, 'DD'))) AS WED,
       MAX(DECODE(TO_CHAR(DT, 'D'), '4', TO_CHAR(DT, 'DD'))) AS THU,
       MAX(DECODE(TO_CHAR(DT, 'D'), '5', TO_CHAR(DT, 'DD'))) AS FRI,
       MAX(DECODE(TO_CHAR(DT, 'D'), '6', TO_CHAR(DT, 'DD'))) AS SAT,
       MAX(DECODE(TO_CHAR(DT, 'D'), '7', TO_CHAR(DT, 'DD'))) AS SUN
FROM (SELECT TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1 AS DT
      FROM DUAL
      CONNECT BY TRUNC(SYSDATE, 'YYYY') + ROWNUM - 1 <
                 ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12))
GROUP BY TO_CHAR(DT, 'Month YYYY'), TO_CHAR(DT, 'IW')
ORDER BY TO_DATE(MONTH, 'Month YYYY'), WEEK;
