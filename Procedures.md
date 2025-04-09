# 📘 Procedury składowane w MariaDB

## 🧠 Co to są procedury?

Procedury składowane (ang. *stored procedures*) to bloki kodu SQL, które są zapisywane i przechowywane w bazie danych. Można je wywołać, aby wykonać z góry zdefiniowane operacje — często składające się z wielu instrukcji SQL.

---

## 🎯 Po co stosuje się procedury?

- **Automatyzacja** powtarzalnych operacji (np. przetwarzanie zamówień, czyszczenie danych)
- **Centralizacja logiki biznesowej** w bazie danych
- **Zwiększenie bezpieczeństwa** (logika po stronie serwera, bez potrzeby nadmiarowego dostępu)
- **Lepsza wydajność** – mniejsze przesyłanie danych między aplikacją a serwerem

---

## 🛠️ Przykładowe problemy, które rozwiązują procedury:

- Tworzenie nowego zamówienia z automatyczną aktualizacją stanu magazynowego
- Wysyłanie masowej aktualizacji statusów zamówień
- Generowanie raportów podsumowujących zamówienia klientów

---

## 🧾 Składnia tworzenia procedury w SQL (MariaDB):

```sql
DELIMITER //
CREATE PROCEDURE procedura_nazwa(IN param1 Typ, OUT param2 Typ, ...)
BEGIN
    -- instrukcje SQL
END //
DELIMITER ;
```

- **IN** – parametr wejściowy
- **OUT** – parametr wyjściowy
- **INOUT** – parametr wejściowo-wyjściowy

Procedury wywołuje się przez:
```sql
CALL nazwa_procedury(param1, param2, ...);
```

---

## ✅ Przykład 1: Dodanie nowego zamówienia

Dodajemy zamówienie i przypisujemy je do klienta:

```sql
DELIMITER //
CREATE PROCEDURE add_order(IN p_customer_id INT)
BEGIN
    INSERT INTO orders (customer_id, order_date, status)
    VALUES (p_customer_id, NOW(), 'new');
END //
DELIMITER ;
```

**Wywołanie:**
```sql
CALL add_order(5);
```

---

## ✅ Przykład 2: Zmiana statusu zamówienia

Zmienia status zamówienia, jeśli istnieje:

```sql
DELIMITER //
CREATE PROCEDURE update_order_status(
    IN p_order_id INT,
    IN p_new_status VARCHAR(50)
)
BEGIN
    UPDATE orders
    SET status = p_new_status
    WHERE order_id = p_order_id;
END //
DELIMITER ;
```

**Wywołanie:**
```sql
CALL update_order_status(3, 'shipped');
```

---

W następnych krokach możemy rozszerzyć temat o funkcje składowane i triggery z przykładami opartymi na tej samej bazie danych.

