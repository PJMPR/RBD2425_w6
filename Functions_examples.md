# 🧪 Przykłady funkcji składowanych w MariaDB z użyciem w SELECT

Poniżej przedstawiono dodatkowe przykłady funkcji składowanych, które można wykorzystać bezpośrednio w zapytaniach SQL. Każdy przykład zawiera kod funkcji oraz przykład jej użycia w `SELECT`.

---

## 🔸 1. Sprawdzenie dostępności produktu w magazynie

### 📘 Cel:
Zwrócenie `TRUE` lub `FALSE` w zależności od tego, czy dany produkt ma dostępny zapas większy od zera.

```sql
DELIMITER //
CREATE FUNCTION is_product_available(p_product_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE available BOOLEAN;

    SELECT quantity > 0 INTO available
    FROM inventory
    WHERE product_id = p_product_id;

    RETURN IFNULL(available, FALSE);
END //
DELIMITER ;
```

**Użycie w zapytaniu SELECT:**
```sql
SELECT name, is_product_available(product_id) AS dostepny
FROM products;
```

---

## 🔸 2. Zliczenie zamówień klienta

### 📘 Cel:
Zwrócenie liczby zamówień przypisanych do danego klienta.

```sql
DELIMITER //
CREATE FUNCTION customer_order_count(p_customer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM orders
    WHERE customer_id = p_customer_id;

    RETURN total;
END //
DELIMITER ;
```

**Użycie w zapytaniu SELECT:**
```sql
SELECT first_name, last_name, customer_order_count(customer_id) AS liczba_zamowien
FROM customers;
```

---

## 🔸 3. Zwrot statusu zamówienia jako czytelny tekst

### 📘 Cel:
Zamiana technicznego statusu zamówienia na bardziej opisowy tekst.

```sql
DELIMITER //
CREATE FUNCTION get_order_status_label(p_status VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CASE p_status
        WHEN 'new' THEN 'Nowe zamówienie'
        WHEN 'shipped' THEN 'Wysłane'
        WHEN 'delivered' THEN 'Dostarczone'
        WHEN 'cancelled' THEN 'Anulowane'
        ELSE 'Nieznany status'
    END;
END //
DELIMITER ;
```

**Użycie w zapytaniu SELECT:**
```sql
SELECT order_id, get_order_status_label(status) AS status_opisowy
FROM orders;
```

---
