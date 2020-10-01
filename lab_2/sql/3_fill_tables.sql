INSERT INTO actor (name, original_name) VALUES ('Алан Рикман', 'Alan Rickman');
INSERT INTO actor (name, original_name) VALUES ('Бенедикт Камбербэтч', 'Benedict Cumberbatch');
INSERT INTO actor (name, original_name) VALUES ('Бенисио Дель Торо', 'Benicio del Toro');
INSERT INTO actor (name, original_name) VALUES ('Роберт Дауни — младший', 'Robert Downey Jr.');

INSERT INTO producer (name, original_name) VALUES ('Джозеф Сарджент', 'Joseph Sargent');
INSERT INTO producer (name, original_name) VALUES ('Джон Мактирнан', 'John McTiernan');
INSERT INTO producer (name, original_name) VALUES ('Энтони Руссо', 'Anthony Russo');
INSERT INTO producer (name, original_name) VALUES ('Брайан Сингер', 'Brian Singer');

INSERT ALL
    INTO storage (storage_name, storage_size) VALUES ('SSD Kingston 2000', 262144)
    INTO storage (storage_name, storage_size) VALUES ('SSD Samsung EVO 960', 131072)
SELECT *
FROM dual;

INSERT INTO movie (name, original_name, release_date, country, genre_level,producer_id, storage_id)
VALUES ('Творение Господне', 'Something the Lord Made', 2004, 'USA', 5, 1, 1);
INSERT INTO movie (name, original_name, release_date, country, genre_level,producer_id, storage_id)
VALUES ('Крепкий орешек', 'Toughie', 2004, 'USA', 4, 2, 1);
INSERT INTO movie (name, original_name, release_date, country, genre_level,producer_id, storage_id)
VALUES ('Мстители: Финал', 'Avengers Endgame', 2019, 'USA', 5, 3, 1);
INSERT INTO movie (name, original_name, release_date, country, genre_level,producer_id, storage_id)
VALUES ('Мстители: Война бесконечности', 'Avengers: Infinity War', 2018, 'USA',5, 3, 2);
INSERT INTO movie (name, original_name, release_date, country, genre_level,producer_id, storage_id)
VALUES ('Подозрительные лица', 'Suspicious persons', 1995, 'USA', 2, 4, 1);

INSERT INTO movie_actor (movie_id, actor_id) VALUES (1, 1);
INSERT INTO movie_actor (movie_id, actor_id) VALUES (2, 1);
INSERT INTO movie_actor (movie_id, actor_id) VALUES (3, 2);
INSERT INTO movie_actor (movie_id, actor_id) VALUES (4, 2);
INSERT INTO movie_actor (movie_id, actor_id) VALUES (4, 3);
INSERT INTO movie_actor (movie_id, actor_id) VALUES (5, 3);
INSERT INTO movie_actor (movie_id, actor_id) VALUES (3, 4);
INSERT INTO movie_actor (movie_id, actor_id) VALUES (4, 4);