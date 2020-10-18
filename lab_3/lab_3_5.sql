-- 1. Составьте на выборку данных с использованием рефлексивного соединения
-- для таблицы из задания 5 лабораторной работы №2.
SELECT LEFT_ACTOR.ID             AS ACTOR_ID,
       RIGHT_ACTOR.NAME          AS ACTOR_NAME,
       RIGHT_ACTOR.ORIGINAL_NAME AS ACTOR_ORIGINAL_NAME
FROM ACTOR LEFT_ACTOR
         JOIN ACTOR RIGHT_ACTOR ON LEFT_ACTOR.ID = RIGHT_ACTOR.ID;

-- 2. Составьте запросы на выборку данных с использованием
-- ПРОСТОГО ОПЕРАТОРА CASE.
SELECT MOVIE.ID                AS MOVIE_ID,
       MOVIE.NAME              AS MOVIE_NAME,
       MOVIE_GENRE.GENRE_LEVEL AS GENRE_LEVEL,
       GENRE.NAME              AS GENRE_NAME,
       CASE MOVIE_GENRE.GENRE_LEVEL
           WHEN 1 THEN 'ONE'
           WHEN 2 THEN 'TWO'
           WHEN 3 THEN 'THREE'
           WHEN 4 THEN 'FOUR'
           WHEN 5 THEN 'FIVE'
           END                 AS WORD_GENRE_LEVEL
FROM MOVIE
         JOIN MOVIE_GENRE ON MOVIE.ID = MOVIE_GENRE.MOVIE_ID
         JOIN GENRE ON MOVIE_GENRE.GENRE_ID = GENRE.ID
ORDER BY MOVIE.ID, MOVIE_GENRE.GENRE_LEVEL;
