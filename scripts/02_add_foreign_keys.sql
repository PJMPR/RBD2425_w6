
-- SKRYPT 2: Dodawanie kluczy obcych ALTER TABLE

ALTER TABLE addresses
ADD CONSTRAINT fk_addresses_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id) REFERENCES products(product_id);
