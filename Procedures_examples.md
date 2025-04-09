# 🧪 Przykłady zaawansowanych konstrukcji w procedurach MariaDB

Poniżej przedstawiono po jednym przykładzie dla każdej z konstrukcji logicznych dostępnych w procedurach składowanych w MariaDB. Każdy przykład zawiera wyjaśnienie działania poszczególnych elementów kodu.

---

## 🔸 1. Zmienna lokalna (`DECLARE`, `SET`)

### 📘 Cel:
Zliczanie liczby zamówień dla danego klienta i zapisanie ich do zmiennej.

```sql
DELIMITER //
CREATE PROCEDURE count_customer_orders(IN p_customer_id INT)
BEGIN
    -- Deklarujemy zmienną lokalną total_orders typu INT
    DECLARE total_orders INT DEFAULT 0;

    -- Przypisujemy do zmiennej wynik zapytania zliczającego zamówienia klienta
    SELECT COUNT(*) INTO total_orders
    FROM orders
    WHERE customer_id = p_customer_id;

    -- Wyświetlamy wynik jako pojedynczy komunikat
    SELECT CONCAT('Liczba zamówień klienta: ', total_orders) AS wynik;
END //
DELIMITER ;
```

**Wywołanie:**
```sql
CALL count_customer_orders(5);
```

---

## 🔸 2. Instrukcja warunkowa (`IF`, `ELSEIF`, `ELSE`)

### 📘 Cel:
Zmiana statusu zamówienia w zależności od liczby pozycji w zamówieniu.

```sql
DELIMITER //
CREATE PROCEDURE check_order_items(IN p_order_id INT)
BEGIN
    -- Tworzymy zmienną, która przechowa liczbę pozycji zamówienia
    DECLARE item_count INT;

    -- Pobieramy liczbę pozycji dla konkretnego zamówienia
    SELECT COUNT(*) INTO item_count
    FROM order_items
    WHERE order_id = p_order_id;

    -- Logika warunkowa: zależnie od liczby pozycji zmieniamy status zamówienia
    IF item_count = 0 THEN
        UPDATE orders SET status = 'cancelled' WHERE order_id = p_order_id;
    ELSEIF item_count < 3 THEN
        UPDATE orders SET status = 'new' WHERE order_id = p_order_id;
    ELSE
        UPDATE orders SET status = 'shipped' WHERE order_id = p_order_id;
    END IF;
END //
DELIMITER ;
```

**Wywołanie:**
```sql
CALL check_order_items(2);
```

---

## 🔸 3. Pętla `WHILE`

### 📘 Cel:
Wypisanie kolejnych identyfikatorów produktów od 1 do 5.

```sql
DELIMITER //
CREATE PROCEDURE list_products()
BEGIN
    -- Deklarujemy zmienną iteracyjną
    DECLARE i INT DEFAULT 1;

    -- Pętla WHILE wykonuje się, dopóki i <= 5
    WHILE i <= 5 DO
        -- Dla każdej wartości i wypisujemy identyfikator produktu
        SELECT CONCAT('Produkt ID: ', i);

        -- Zwiększamy wartość i
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
```

**Wywołanie:**
```sql
CALL list_products();
```

---

## 🔸 4. Obsługa błędów (`DECLARE HANDLER`)

### 📘 Cel:
Próba usunięcia klienta – jeśli ma on powiązane dane (np. zamówienia), błąd jest przechwytywany i zamiast wyjątku wyświetlamy komunikat.

```sql
DELIMITER //
CREATE PROCEDURE delete_customer_safe(IN p_customer_id INT)
BEGIN
    -- Deklarujemy handler: przechwytuje wyjątki SQL i wykonuje alternatywne instrukcje
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Jeśli wystąpi wyjątek, pokazujemy komunikat
        SELECT 'Nie można usunąć klienta — powiązane dane istnieją' AS komunikat;
    END;

    -- Próba usunięcia klienta
    DELETE FROM customers WHERE customer_id = p_customer_id;

    -- Jeśli usunięcie się powiedzie, wyświetlamy inny komunikat
    SELECT 'Klient usunięty pomyślnie' AS komunikat;
END //
DELIMITER ;
```

**Wywołanie:**
```sql
CALL delete_customer_safe(1);
```

---
