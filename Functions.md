# 📘 Funkcje składowane w MariaDB

## 🧠 Co to są funkcje składowane?

Funkcje składowane (*stored functions*) to obiekty bazy danych podobne do procedur, ale **zawsze zwracają jedną konkretną wartość** i mogą być wykorzystywane w zapytaniach SQL (np. `SELECT`, `WHERE`).

---

## 🎯 Po co stosuje się funkcje?

- Aby **przeliczać i zwracać konkretne wartości** (np. suma zamówień klienta)
- Do **ponownego użycia tej samej logiki** w wielu miejscach
- Do **uproszczenia zapytań SQL**
- Do **izolowania obliczeń lub walidacji** (np. sprawdzenie poprawności danych)

---

## 🛠️ Przykładowe zastosowania funkcji:

- Obliczanie łącznej wartości zamówienia
- Wyciągnięcie imienia i nazwiska klienta jako jednego ciągu
- Sprawdzenie, czy dany produkt jest dostępny w magazynie

---

## 🧾 Składnia tworzenia funkcji w SQL (MariaDB):

```sql
DELIMITER //
CREATE FUNCTION nazwa_funkcji(parametry)
RETURNS typ_danych
DETERMINISTIC
BEGIN
    -- ciało funkcji
    RETURN wartość;
END //
DELIMITER ;
```

- `RETURNS` – określa typ danych zwracany przez funkcję
- `DETERMINISTIC` – oznacza, że ta sama wartość wejściowa da zawsze taki sam wynik (optymalizacja)

**Użycie funkcji:**
```sql
SELECT nazwa_funkcji(...);
```

---

## ✅ Przykład 1: Oblicz wartość zamówienia

```sql
DELIMITER //
CREATE FUNCTION get_order_total(p_order_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(oi.quantity * p.price)
    INTO total
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    WHERE oi.order_id = p_order_id;

    RETURN IFNULL(total, 0.00);
END //
DELIMITER ;
```

**Użycie:**
```sql
SELECT get_order_total(1);
```

---

## ✅ Przykład 2: Połącz imię i nazwisko klienta

```sql
DELIMITER //
CREATE FUNCTION get_customer_fullname(p_customer_id INT)
RETURNS VARCHAR(150)
DETERMINISTIC
BEGIN
    DECLARE fullname VARCHAR(150);

    SELECT CONCAT(first_name, ' ', last_name)
    INTO fullname
    FROM customers
    WHERE customer_id = p_customer_id;

    RETURN fullname;
END //
DELIMITER ;
```

**Użycie:**
```sql
SELECT get_customer_fullname(3);
```

---
