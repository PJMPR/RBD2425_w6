# 📘 Triggery w MariaDB

## 🧠 Co to są triggery?

**Trigger (wyzwalacz)** to specjalny obiekt bazy danych, który **automatycznie wykonuje określony blok kodu SQL** w reakcji na operację `INSERT`, `UPDATE` lub `DELETE` wykonywaną na określonej tabeli.

Trigger działa jak „strażnik” tabeli – zawsze reaguje wtedy, gdy coś się zmienia.

---

## 🎯 Po co stosuje się triggery?

- Do **walidacji danych przed zapisem**
- Do **automatycznego uzupełniania danych zależnych** (np. aktualizacja stanu magazynowego)
- Do **logowania operacji** (np. historia zmian w tabeli)
- Do **utrzymania spójności danych** bez potrzeby ręcznego wywoływania dodatkowych poleceń

---

## 🔄 Rodzaje triggerów w MariaDB:

- `BEFORE INSERT`, `BEFORE UPDATE`, `BEFORE DELETE`
- `AFTER INSERT`, `AFTER UPDATE`, `AFTER DELETE`

Trigger może być przypisany tylko **do jednej tabeli** i do **jednego zdarzenia jednocześnie**.

---

## 🧾 Składnia tworzenia triggera:

```sql
DELIMITER //
CREATE TRIGGER nazwa_triggera
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON nazwa_tabeli
FOR EACH ROW
BEGIN
    -- ciało triggera
END //
DELIMITER ;
```

Wewnątrz triggera dostępne są pseudotabele:
- `NEW.kolumna` – nowe dane (dla `INSERT`, `UPDATE`)
- `OLD.kolumna` – stare dane (dla `UPDATE`, `DELETE`)

---

## ✅ Przykład 1: Automatyczne ustawienie daty aktualizacji

Tabela `inventory` ma kolumnę `last_updated`, którą chcemy automatycznie uzupełniać przy zmianie ilości:

```sql
DELIMITER //
CREATE TRIGGER trg_inventory_update_date
BEFORE UPDATE ON inventory
FOR EACH ROW
BEGIN
    SET NEW.last_updated = NOW();
END //
DELIMITER ;
```

---

## ✅ Przykład 2: Logowanie usunięcia klienta do osobnej tabeli

Zakładamy, że mamy tabelę `deleted_customers` z polami `customer_id`, `full_name`, `deleted_at`:

```sql
DELIMITER //
CREATE TRIGGER trg_log_customer_delete
AFTER DELETE ON customers
FOR EACH ROW
BEGIN
    INSERT INTO deleted_customers (customer_id, full_name, deleted_at)
    VALUES (OLD.customer_id, CONCAT(OLD.first_name, ' ', OLD.last_name), NOW());
END //
DELIMITER ;
```

---

## ✅ Przykład 3: Walidacja liczby sztuk w zamówieniu

Nie pozwalamy na dodanie pozycji zamówienia z ilością większą niż 100:

```sql
DELIMITER //
CREATE TRIGGER trg_check_order_quantity
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    IF NEW.quantity > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nie można zamówić więcej niż 100 sztuk produktu!';
    END IF;
END //
DELIMITER ;
```

---


