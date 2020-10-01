-- Create actor table
CREATE TABLE actor
(
    id            INTEGER GENERATED ALWAYS as IDENTITY (START with 1 INCREMENT by 1) NOT NULL,
    name          VARCHAR2(32 CHAR)                                                  NOT NULL,
    original_name VARCHAR2(32 CHAR)                                                  NOT NULL
);
ALTER TABLE actor
    ADD CONSTRAINT actor_pk PRIMARY KEY (id);
CREATE INDEX ACTOR_NAME_IND ON actor (name);
CREATE INDEX ACTOR_ORIGINAL_NAME_IND ON actor (original_name);

-- Create movie_actor table
CREATE TABLE movie_actor
(
    movie_id INTEGER NOT NULL,
    actor_id INTEGER NOT NULL
);
ALTER TABLE movie_actor
    ADD CONSTRAINT movie_actor_pk PRIMARY KEY (movie_id, actor_id);


-- Create producer table
CREATE TABLE producer
(
    id            INTEGER GENERATED ALWAYS as IDENTITY (START with 1 INCREMENT by 1) NOT NULL,
    name          VARCHAR2(32 CHAR)                                                  NOT NULL,
    original_name VARCHAR2(32 CHAR)                                                  NOT NULL
);
ALTER TABLE producer
    ADD CONSTRAINT producer_pk PRIMARY KEY (id);
CREATE INDEX PRODUCER_NAME_IND ON producer (name);
CREATE INDEX PRODUCER_ORIGINAL_NAME_IND ON producer (original_name);

-- Create storage table
CREATE TABLE storage
(
    id           INTEGER              NOT NULL,
    storage_name VARCHAR2(48 CHAR)    NOT NULL,
    storage_size INTEGER DEFAULT 4608 NOT NULL
);
ALTER TABLE storage
    ADD CONSTRAINT storage_pk PRIMARY KEY (id);
ALTER TABLE storage
    ADD CONSTRAINT constraint_size CHECK ( storage_size BETWEEN 1 AND 512000 );

CREATE INDEX STORAGE_NAME_IND ON storage (storage_name);

CREATE SEQUENCE storage_seq START WITH 1;

CREATE OR REPLACE TRIGGER storage_id_trigger
    BEFORE INSERT
    ON storage
    FOR EACH ROW
BEGIN
    SELECT storage_seq.NEXTVAL
    INTO :new.id
    FROM dual;
END;
/

-- Create movie table
CREATE TABLE movie
(
    id            INTEGER GENERATED ALWAYS as IDENTITY (START with 1 INCREMENT by 1) NOT NULL,
    name          VARCHAR2(48 CHAR)                                                  NOT NULL,
    original_name VARCHAR2(48 CHAR)                                                  NOT NULL,
    release_date  INTEGER                                                            NOT NULL,
    country       VARCHAR2(20 CHAR)                                                  NOT NULL,
    genre_level   SMALLINT                                                           NOT NULL,
    producer_id   INTEGER                                                            NOT NULL,
    storage_id    INTEGER                                                            NOT NULL
);
ALTER TABLE movie
    ADD CONSTRAINT movie_pk PRIMARY KEY (id);
ALTER TABLE movie
    ADD CONSTRAINT constraint_release_from CHECK (release_date >= 1883);

CREATE INDEX MOVIE_NAME_IND ON movie (name);
CREATE INDEX MOVIE_ORIGINAL_NAME_IND ON movie (original_name);
CREATE INDEX MOVIE_COUNTRY_IND ON movie (country);

CREATE OR REPLACE TRIGGER trg_check_dates
    BEFORE INSERT OR UPDATE
    ON movie
    FOR EACH ROW
BEGIN
    IF (:new.release_date > EXTRACT(YEAR FROM SYSDATE))
    THEN
        RAISE_APPLICATION_ERROR(-20001,
                                'Invalid release date: release date must be less than the current date = ' ||
                                to_char(:new.release_date,
                                        'YYYY-MM-DD HH24:MI:SS'));
    END IF;
END;
/

ALTER TABLE movie_actor
    ADD CONSTRAINT movie_actor_actor_fk FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE SET NULL;
ALTER TABLE movie_actor
    ADD CONSTRAINT movie_actor_movie_fk FOREIGN KEY (movie_id)
        REFERENCES movie (id) ON DELETE CASCADE;
ALTER TABLE movie
    ADD CONSTRAINT movie_producer_fk FOREIGN KEY (producer_id)
        REFERENCES producer (id) ON DELETE SET NULL;
ALTER TABLE movie
    ADD CONSTRAINT movie_storage_fk FOREIGN KEY (storage_id)
        REFERENCES storage (id) ON DELETE CASCADE;
