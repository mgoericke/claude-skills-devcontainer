-- Neue Spalten für Kategorie und Produktbild
-- Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via frontend-skill

ALTER TABLE product ADD COLUMN category VARCHAR(100) NOT NULL DEFAULT 'Sonstiges';
ALTER TABLE product ADD COLUMN image_url TEXT;

-- Beispieldaten: Strickwaren Online-Shop

-- Kategorie: Wolle
INSERT INTO product (id, name, description, price, category, image_url, created_at, updated_at) VALUES
(gen_random_uuid(), 'Merino-Wolle Classic', 'Feinste Merinowolle, 100g Knäuel, maschinenwaschbar. Perfekt für Pullover, Schals und Mützen.', 8.95, 'Wolle', 'https://placehold.co/400x400/e8d5b7/5c4033?text=Merino+Wolle', NOW(), NOW()),
(gen_random_uuid(), 'Alpaka-Wolle Soft', 'Luxuriöse Alpaka-Wolle, 50g Knäuel, besonders weich und wärmend. Ideal für empfindliche Haut.', 12.50, 'Wolle', 'https://placehold.co/400x400/d4c5a9/5c4033?text=Alpaka+Wolle', NOW(), NOW()),
(gen_random_uuid(), 'Baumwollgarn Natur', 'Bio-Baumwollgarn, 100g Knäuel, GOTS-zertifiziert. Perfekt für Sommerkleidung und Amigurumi.', 5.49, 'Wolle', 'https://placehold.co/400x400/f5f0e1/5c4033?text=Baumwollgarn', NOW(), NOW()),
(gen_random_uuid(), 'Mohair Deluxe', 'Flauschiges Mohairgarn, 25g Knäuel, mit Seidenanteil. Für hauchzarte Tücher und Stolen.', 9.95, 'Wolle', 'https://placehold.co/400x400/e8c8d0/5c4033?text=Mohair', NOW(), NOW()),
(gen_random_uuid(), 'Sockenwolle 4-fach', 'Strapazierfähige Sockenwolle mit Polyamidanteil, 100g Knäuel. Maschinenwaschbar bei 40°C.', 6.95, 'Wolle', 'https://placehold.co/400x400/b8d4e3/5c4033?text=Sockenwolle', NOW(), NOW()),
(gen_random_uuid(), 'Chunky Wolle XL', 'Dicke Wolle für schnelle Projekte, 200g Knäuel. Ideal für kuschelige Decken und Kissen.', 14.95, 'Wolle', 'https://placehold.co/400x400/c9b99a/5c4033?text=Chunky+XL', NOW(), NOW());

-- Kategorie: Nadeln
INSERT INTO product (id, name, description, price, category, image_url, created_at, updated_at) VALUES
(gen_random_uuid(), 'Rundstricknadel Bambus 4mm', 'Rundstricknadel aus Bambus, 80cm Seillänge. Leicht und warm in der Hand, ideal für Anfänger.', 7.95, 'Nadeln', 'https://placehold.co/400x400/d4e8c2/3d5a1e?text=Bambus+4mm', NOW(), NOW()),
(gen_random_uuid(), 'Nadelspiel Metall 3mm', 'Set mit 5 Nadeln aus beschichtetem Metall, 20cm lang. Perfekt für Socken und Handschuhe.', 9.50, 'Nadeln', 'https://placehold.co/400x400/c0c0c0/333333?text=Nadelspiel+3mm', NOW(), NOW()),
(gen_random_uuid(), 'Häkelnadel-Set Ergonomisch', '8-teiliges Set (2-6mm) mit ergonomischem Soft-Griff. Schont die Handgelenke bei langen Sessions.', 18.95, 'Nadeln', 'https://placehold.co/400x400/e8b4b8/5c2033?text=H%C3%A4kelnadel+Set', NOW(), NOW()),
(gen_random_uuid(), 'Stricknadeln Holz 6mm', 'Klassische Jackenstricknadeln aus Birkenholz, 35cm lang. Für dicke Wolle und schnelle Projekte.', 6.50, 'Nadeln', 'https://placehold.co/400x400/deb887/5c4033?text=Holz+6mm', NOW(), NOW()),
(gen_random_uuid(), 'Rundstricknadel-Set Edelstahl', 'Austauschbares Nadelsystem, 13 Größen (2,5-10mm) mit verschiedenen Seillängen. Profi-Set.', 49.95, 'Nadeln', 'https://placehold.co/400x400/b0c4de/333333?text=Profi+Set', NOW(), NOW());

-- Kategorie: Strickanleitungen
INSERT INTO product (id, name, description, price, category, image_url, created_at, updated_at) VALUES
(gen_random_uuid(), 'Anleitung: Norwegerpullover', 'Detaillierte Anleitung mit Zählmuster für einen traditionellen Norwegerpullover. Größen S-XXL.', 7.50, 'Anleitungen', 'https://placehold.co/400x400/1e3a5f/ffffff?text=Norwegerpullover', NOW(), NOW()),
(gen_random_uuid(), 'Anleitung: Baby-Decke Sternenmuster', 'Anfängerfreundliche Anleitung für eine kuschelige Baby-Decke im Sternenmuster. 80x100cm.', 4.95, 'Anleitungen', 'https://placehold.co/400x400/ffd1dc/5c2033?text=Baby+Decke', NOW(), NOW()),
(gen_random_uuid(), 'Anleitung: Socken stricken Basis', 'Schritt-für-Schritt-Anleitung mit Fotos. Von der Ferse bis zur Spitze. Größen 36-46.', 3.95, 'Anleitungen', 'https://placehold.co/400x400/87ceeb/1e3a5f?text=Socken+Basis', NOW(), NOW()),
(gen_random_uuid(), 'Anleitung: Amigurumi Tiere', 'Häkelanleitungen für 5 niedliche Tiere: Hase, Bär, Katze, Fuchs und Eule. Mit Materialliste.', 9.95, 'Anleitungen', 'https://placehold.co/400x400/98fb98/2d5a2d?text=Amigurumi', NOW(), NOW()),
(gen_random_uuid(), 'Anleitung: Lochmuster-Schal', 'Eleganter Spitzenschal mit detailliertem Strickmuster. Perfekt als Geschenk.', 5.50, 'Anleitungen', 'https://placehold.co/400x400/dda0dd/4b0082?text=Lochmuster', NOW(), NOW());

-- Kategorie: Zubehör
INSERT INTO product (id, name, description, price, category, image_url, created_at, updated_at) VALUES
(gen_random_uuid(), 'Maschenmarkierer-Set', '20 bunte Maschenmarkierer aus Kunststoff. Unverzichtbar für Muster und Rundenmarkierung.', 3.95, 'Zubehoer', 'https://placehold.co/400x400/ff6b6b/ffffff?text=Markierer', NOW(), NOW()),
(gen_random_uuid(), 'Wollwickler mit Tischklemme', 'Handkurbel-Wollwickler für perfekte Knäuel. Stabile Tischklemme, verarbeitet bis 300g.', 24.95, 'Zubehoer', 'https://placehold.co/400x400/4ecdc4/ffffff?text=Wollwickler', NOW(), NOW()),
(gen_random_uuid(), 'Projekt-Tasche Canvas', 'Große Projekt-Tasche aus gewachstem Canvas mit Innenfächern. Hält Wolle und Nadeln organisiert.', 29.95, 'Zubehoer', 'https://placehold.co/400x400/c9b99a/ffffff?text=Projekt+Tasche', NOW(), NOW()),
(gen_random_uuid(), 'Reihenzähler Digital', 'Elektronischer Reihenzähler mit LCD-Display. Zählt vorwärts und rückwärts, batteriebetrieben.', 8.50, 'Zubehoer', 'https://placehold.co/400x400/45b7d1/ffffff?text=Reihenz%C3%A4hler', NOW(), NOW());
