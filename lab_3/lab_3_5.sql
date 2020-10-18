-- 1. Составьте на выборку данных с использованием рефлексивного соединения
-- для таблицы из задания 5 лабораторной работы №2.
SELECT LEFT_ACTOR.ID             AS ACTOR_ID,
       RIGHT_ACTOR.NAME          AS ACTOR_NAME,
       RIGHT_ACTOR.ORIGINAL_NAME AS ACTOR_ORIGINAL_NAME
FROM ACTOR LEFT_ACTOR
         JOIN ACTOR RIGHT_ACTOR ON LEFT_ACTOR.ID = RIGHT_ACTOR.ID;
