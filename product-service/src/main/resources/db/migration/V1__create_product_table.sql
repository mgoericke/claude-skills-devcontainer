-- V1__create_product_table.sql
-- Flyway-Migration: Erstellt die Initialtabelle für Product
--
-- Co-Author: Claude (claude-sonnet-4-6, Anthropic)

CREATE TABLE product (
    id          UUID         NOT NULL DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    price       NUMERIC(19, 2) NOT NULL,
    created_at  TIMESTAMP    NOT NULL,
    updated_at  TIMESTAMP    NOT NULL,

    CONSTRAINT pk_product PRIMARY KEY (id)
);
