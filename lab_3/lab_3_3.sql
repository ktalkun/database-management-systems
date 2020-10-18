-- 1. Требуется представить имя каждого сотрудника таблицы EMP, а также имя его
-- руководителя(РЕФЛЕКСИВНОЕ СОЕДИНЕНИЕ (SELF JOIN)).
SELECT LEFT_EMP.EMPNO,
       LEFT_EMP.EMPNAME,
       LEFT_EMP.BIRTHDATE,
       LEFT_EMP.MANAGER_ID,
       LEFT_EMP.EMPNAME || ' works for ' || RIGHT_EMP.EMPNAME AS EMP_MANAGER
FROM EMP LEFT_EMP
         JOIN EMP RIGHT_EMP ON LEFT_EMP.MANAGER_ID = RIGHT_EMP.EMPNO;

-- 2. Требуется представить имя каждого сотрудника таблицы EMP
-- (даже сотрудника, которому не назначен руководитель) и имя его
-- руководителя (ИЕРАРХИЧЕСКИЙ (РЕКУРСИВНЫЙ) ЗАПРОС).

-- Начинаем с корневого сотрудника (менеджера)
-- (т.е. у которого 'MANAGER_ID' = NULL)
SELECT LEVEL,
       LEFT_EMP.EMPNO,
       LEFT_EMP.EMPNAME,
       LEFT_EMP.BIRTHDATE,
       LEFT_EMP.EMPNAME || ' reports to ' || RIGHT_EMP.EMPNAME AS EMP_MANAGER
FROM EMP LEFT_EMP
         LEFT JOIN EMP RIGHT_EMP ON LEFT_EMP.MANAGER_ID = RIGHT_EMP.EMPNO
START WITH LEFT_EMP.MANAGER_ID IS NULL
CONNECT BY PRIOR LEFT_EMP.EMPNO = LEFT_EMP.MANAGER_ID;

-- В виде дерева с сортировкой по имени внутри каждого уровня иерархии.
-- У корневого элемента иерарахии MANAGER_ID = NULL, поэтому будет установлено
-- 'NO'
SELECT LPAD(' ', 3 * LEVEL) || LEVEL || '.' || EMPNAME || ' - ' ||
       EMPNO || ' - ' || COALESCE(TO_CHAR(MANAGER_ID), 'NO') || ' - ' ||
       BIRTHDATE AS TREE
FROM EMP
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPNO = MANAGER_ID
ORDER SIBLINGS BY EMPNAME;

-- 3. Требуется показать иерархию от CLARK до JOHN KLINTON
-- (ПРЕДСТАВЛЕНИЕ ОТНОШЕНИЙ ПОТОМОК-РОДИТЕЛЬ-ПРАРОДИТЕЛЬ).
SELECT RTRIM(REVERSE(SYS_CONNECT_BY_PATH(REVERSE(LEFT_EMP.EMPNAME), '>-')),
             '->')
           AS LEEF_BRANCH_ROOT
FROM EMP LEFT_EMP
         LEFT JOIN EMP RIGHT_EMP ON LEFT_EMP.MANAGER_ID = RIGHT_EMP.EMPNO
WHERE LEFT_EMP.EMPNAME = 'CLARK'
START WITH LEFT_EMP.MANAGER_ID IS NULL
CONNECT BY PRIOR LEFT_EMP.EMPNO = LEFT_EMP.MANAGER_ID;

-- 4. Требуется получить результирующее множество, описывающее иерархию всей
-- таблицы (ИЕРАРХИЧЕСКОЕ ПРЕДСТАВЛЕНИЕ ТАБЛИЦЫ).
SELECT LTRIM(SYS_CONNECT_BY_PATH(LEFT_EMP.EMPNAME, '->'), '->')
           AS LEEF_BRANCH_ROOT
FROM EMP LEFT_EMP
         LEFT JOIN EMP RIGHT_EMP ON LEFT_EMP.MANAGER_ID = RIGHT_EMP.EMPNO
START WITH LEFT_EMP.MANAGER_ID IS NULL
CONNECT BY PRIOR LEFT_EMP.EMPNO = LEFT_EMP.MANAGER_ID
ORDER SIBLINGS BY LEFT_EMP.EMPNAME;
