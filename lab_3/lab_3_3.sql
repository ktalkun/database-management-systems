-- 1. Требуется представить имя каждого сотрудника таблицы EMP, а также имя его
-- руководителя(РЕФЛЕКСИВНОЕ СОЕДИНЕНИЕ (SELF JOIN)).
SELECT LEFT_EMP.EMPNO,
       LEFT_EMP.EMPNAME,
       LEFT_EMP.BIRTHDATE,
       LEFT_EMP.MANAGER_ID,
       LEFT_EMP.EMPNAME || ' works for ' || RIGHT_EMP.EMPNAME AS EMP_MANAGER
FROM EMP LEFT_EMP
         JOIN EMP RIGHT_EMP ON LEFT_EMP.MANAGER_ID = RIGHT_EMP.EMPNO;
