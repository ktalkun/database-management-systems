-- Generated by Oracle SQL Developer Data Modeler 20.2.0.167.1538
--   at:        2020-10-01 22:01:50 MSK
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c



DROP TABLE actor CASCADE CONSTRAINTS;

DROP TABLE movie CASCADE CONSTRAINTS;

DROP TABLE movie_actor CASCADE CONSTRAINTS;

DROP TABLE producer CASCADE CONSTRAINTS;

DROP TABLE storage CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE actor (
    id             INTEGER NOT NULL,
    name           VARCHAR2(32 CHAR),
    original_name  VARCHAR2(32 CHAR)
);

ALTER TABLE actor ADD CONSTRAINT actor_pk PRIMARY KEY ( id );

CREATE TABLE movie (
    id             INTEGER NOT NULL,
    name           VARCHAR2(48 CHAR) NOT NULL,
    original_name  VARCHAR2(48 CHAR) NOT NULL,
    release_date   INTEGER NOT NULL,
    country        VARCHAR2(20 CHAR) NOT NULL,
    genre_level    SMALLINT NOT NULL,
    producer_id    INTEGER NOT NULL,
    storage_id     INTEGER NOT NULL
);

ALTER TABLE movie ADD CONSTRAINT constraint_release_from CHECK ( release_date = 1883 );

ALTER TABLE movie ADD CONSTRAINT movie_pk PRIMARY KEY ( id );

CREATE TABLE movie_actor (
    movie_id  INTEGER NOT NULL,
    actor_id  INTEGER NOT NULL
);

ALTER TABLE movie_actor ADD CONSTRAINT movie_actor_pk PRIMARY KEY ( movie_id,
                                                                    actor_id );

CREATE TABLE producer (
    id             INTEGER NOT NULL,
    name           VARCHAR2(32 CHAR),
    original_name  VARCHAR2(32 CHAR)
);

ALTER TABLE producer ADD CONSTRAINT producer_pk PRIMARY KEY ( id );

CREATE TABLE storage (
    id            INTEGER NOT NULL,
    storage_name  VARCHAR2(48 CHAR) NOT NULL,
    storage_size  INTEGER DEFAULT 4608 NOT NULL
);

ALTER TABLE storage
    ADD CONSTRAINT constraint_size CHECK ( storage_size BETWEEN 1 AND 512000 );

ALTER TABLE storage ADD CONSTRAINT storage_pk PRIMARY KEY ( id );

ALTER TABLE movie_actor
    ADD CONSTRAINT movie_actor_actor_fk FOREIGN KEY ( actor_id )
        REFERENCES actor ( id );

ALTER TABLE movie_actor
    ADD CONSTRAINT movie_actor_movie_fk FOREIGN KEY ( movie_id )
        REFERENCES movie ( id );

ALTER TABLE movie
    ADD CONSTRAINT movie_producer_fk FOREIGN KEY ( producer_id )
        REFERENCES producer ( id );

ALTER TABLE movie
    ADD CONSTRAINT movie_storage_fk FOREIGN KEY ( storage_id )
        REFERENCES storage ( id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             5
-- CREATE INDEX                             0
-- ALTER TABLE                             11
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
