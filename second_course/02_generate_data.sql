-- Data generator for Data Engineering lab
-- Target sizes:
--   customers     10 000
--   products       1 000
--   orders       100 000
--   order_items  200 000+

\set ON_ERROR_STOP on

-- Make random deterministic-ish per init
SELECT setseed(0.42);

-- Customers: 10k
INSERT INTO customers (first_name, last_name, email, phone, city, country, created_at, updated_at)
SELECT
  'Name' || gs::text AS first_name,
  'Surname' || gs::text AS last_name,
  'user' || gs::text || '@example.com' AS email,
  '+1-202-' || lpad(((random()*9999)::int)::text, 4, '0') AS phone,
  (ARRAY['Berlin','Paris','Madrid','Rome','Warsaw','Prague','Vienna','Lisbon','Helsinki','Oslo','Stockholm','Copenhagen','Dublin','London','Amsterdam'])[1 + (random()*13)::int] AS city,
  (ARRAY['DE','FR','ES','IT','PL','CZ','AT','PT','FI','NO','SE','DK','IE','UK','NL'])[1 + (random()*14)::int] AS country,
  now() - (random() * interval '365 days') AS created_at,
  now() - (random() * interval '30 days')  AS updated_at
FROM generate_series(1, 10000) AS gs;

-- Products: 1k
INSERT INTO products (sku, name, category, price, is_active, created_at, updated_at)
SELECT
  'SKU-' || lpad(gs::text, 6, '0') AS sku,
  'Product ' || gs::text AS name,
  (ARRAY['Electronics','Home','Sports','Toys','Books','Food','Beauty','Clothing'])[1 + (random()*7)::int] AS category,
  round((5 + random()*995)::numeric, 2) AS price,
  (random() > 0.05) AS is_active,
  now() - (random() * interval '365 days') AS created_at,
  now() - (random() * interval '30 days')  AS updated_at
FROM generate_series(1, 1000) AS gs;

-- Orders: 100k
INSERT INTO orders (customer_id, status, amount, created_at, updated_at)
SELECT
  1 + (random()*9999)::int AS customer_id,
  (ARRAY['NEW','PAID','SHIPPED','DELIVERED','CANCELLED','REFUNDED'])[1 + (random()*5)::int] AS status,
  round((10 + random()*490)::numeric, 2) AS amount,
  now() - (random() * interval '60 days') AS created_at,
  now() - (random() * interval '30 days') AS updated_at
FROM generate_series(1, 100000) AS gs;

-- Order items: 220k (200k+)
-- We spread items across orders deterministically to keep FKs valid and distribution decent.
INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_amount, created_at, updated_at)
SELECT
  1 + ((gs - 1) % 100000) AS order_id,
  1 + (random()*999)::int AS product_id,
  1 + (random()*4)::int AS quantity,
  round((5 + random()*995)::numeric, 2) AS unit_price,
  round(((1 + (random()*4)::int) * (5 + random()*995))::numeric, 2) AS line_amount,
  now() - (random() * interval '60 days') AS created_at,
  now() - (random() * interval '30 days') AS updated_at
FROM generate_series(1, 220000) AS gs;

ANALYZE;

