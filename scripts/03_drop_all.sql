
-- SKRYPT 3: Cofanie zmian (usuwanie relacji i tabel)

-- Najpierw usuń klucze obce
ALTER TABLE order_items DROP FOREIGN KEY fk_order_items_order;
ALTER TABLE order_items DROP FOREIGN KEY fk_order_items_product;
ALTER TABLE orders DROP FOREIGN KEY fk_orders_customer;
ALTER TABLE inventory DROP FOREIGN KEY fk_inventory_product;
ALTER TABLE addresses DROP FOREIGN KEY fk_addresses_customer;

-- Następnie usuń tabele
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS customers;
