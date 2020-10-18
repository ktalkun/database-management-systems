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

-- 3. Составьте запросы на выборку данных с использованием
-- ПОИСКОВОГО ОПЕРАТОРА CASE.
SELECT MOVIE.ID                AS MOVIE_ID,
       MOVIE.NAME              AS MOVIE_NAME,
       MOVIE_GENRE.GENRE_LEVEL AS GENRE_LEVEL,
       GENRE.NAME              AS GENRE_NAME,
       CASE
           WHEN MOVIE_GENRE.GENRE_LEVEL BETWEEN 1 AND 2 THEN 'LOW_CORRESPONDING'
           WHEN MOVIE_GENRE.GENRE_LEVEL BETWEEN 3 AND 4
               THEN 'MIDDLE_CORRESPONDING'
           WHEN MOVIE_GENRE.GENRE_LEVEL = 5 THEN 'HIGH_CORRESPONDING'
           END                 AS CORRESPONDIG
FROM MOVIE
         JOIN MOVIE_GENRE ON MOVIE.ID = MOVIE_GENRE.MOVIE_ID
         JOIN GENRE ON MOVIE_GENRE.GENRE_ID = GENRE.ID
ORDER BY MOVIE.ID, MOVIE_GENRE.GENRE_LEVEL;

-- 4. Составьте запросы на выборку данных с использованием ОПЕРАТОРА WITH.
WITH PRODUCER_TMP AS (SELECT * FROM PRODUCER)
SELECT MOVIE.ID          AS MOVIE_ID,
       MOVIE.NAME        AS MOVIE_NAME,
       PRODUCER_TMP.NAME AS PRODUCER
FROM MOVIE
         JOIN PRODUCER_TMP ON MOVIE.PRODUCER_ID = PRODUCER_TMP.ID;

-- 5. Составьте запросы на выборку данных с использованием
-- ВСТРОЕННОГО ПРЕДСТАВЛЕНИЯ.
SELECT ID   AS MOVIE_ID,
       NAME AS MOVIE_NAME
FROM (SELECT * FROM MOVIE);

-- 6. Составьте запросы на выборку данных с использованием
-- НЕКОРРЕЛИРОВАННОГО ЗАПРОСА.
SELECT MOVIE.ID   AS MOVIE_ID,
       MOVIE.NAME AS MOVIE_NAME
FROM MOVIE
WHERE MOVIE.STORAGE_ID = (SELECT ID
                          FROM STORAGE
                          WHERE STORAGE_NAME = 'Kingston 2000');

-- 7. Составьте запросы на выборку данных с использованием
-- КОРРЕЛИРОВАННОГО ЗАПРОСА.
SELECT MOVIE.ID   AS MOVIE_ID,
       MOVIE.NAME AS MOVIE_NAME
FROM MOVIE
WHERE MOVIE.STORAGE_ID = (SELECT ID
                          FROM STORAGE
                          WHERE MOVIE.STORAGE_ID = STORAGE.ID
                            AND STORAGE_NAME = 'Kingston 2000');

-- 8. Составьте запросы на выборку данных с использованием ФУНКЦИИ NULLIF.
SELECT MOVIE.NAME    AS MOVIE_NAME,
       PRODUCER.NAME AS PRODUCER_NAME,
       NULLIF(PRODUCER.NAME, LEAD(PRODUCER.NAME) over (ORDER BY PRODUCER.NAME))
                     AS IF_NEXT_PRODUCER_LIKE_THIS
FROM MOVIE
         JOIN PRODUCER ON MOVIE.PRODUCER_ID = PRODUCER.ID;

-- 9. Составьте запросы на выборку данных с использованием ФУНКЦИИ NVL2.
SELECT MOVIE.NAME                                   AS MOVIE_NAME,
       PRODUCER.NAME                                AS PRODUCER_NAME,
       NVL2(NULLIF(PRODUCER.NAME,
                   LEAD(PRODUCER.NAME) over (ORDER BY PRODUCER.NAME)),
            'Продюссер следующего фильма не такой же',
            'Продюссер средующего фильма такой же') AS IF_NEXT_PRODUCER_LIKE_THIS
FROM MOVIE
         JOIN PRODUCER ON MOVIE.PRODUCER_ID = PRODUCER.ID;
