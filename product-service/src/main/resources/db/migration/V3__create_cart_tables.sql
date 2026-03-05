-- Warenkorb-Tabellen
-- Co-Author: Claude (claude-sonnet-4-6, Anthropic)

CREATE TABLE cart (
    id         UUID      NOT NULL DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,

    CONSTRAINT pk_cart PRIMARY KEY (id)
);

CREATE TABLE cart_item (
    id         UUID         NOT NULL DEFAULT gen_random_uuid(),
    cart_id    UUID         NOT NULL,
    product_id UUID         NOT NULL,
    quantity   INT          NOT NULL DEFAULT 1,
    created_at TIMESTAMP    NOT NULL,
    updated_at TIMESTAMP    NOT NULL,

    CONSTRAINT pk_cart_item PRIMARY KEY (id),
    CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES cart (id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_item_product FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE,
    CONSTRAINT uq_cart_item_cart_product UNIQUE (cart_id, product_id)
);

CREATE INDEX idx_cart_item_cart_id ON cart_item (cart_id);
