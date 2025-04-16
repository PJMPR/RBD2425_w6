# 🧪 Przykłady praktycznych triggerów w MariaDB


---

## 🔸 1. Automatyczne aktualizowanie stanu magazynowego po dodaniu pozycji zamówienia

### 📘 Cel:
Zmniejszenie stanu magazynowego produktu o liczbę zamówionych sztuk po dodaniu pozycji do `order_items`.

```sql
DELIMITER //
CREATE TRIGGER trg_decrease_inventory
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET quantity = quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //
DELIMITER ;
```

📌 **Uwaga:** Dobrze jest w praktyce dodać warunki zapobiegające ujemnym stanom.

---

## 🔸 2. Przywracanie stanu magazynowego po usunięciu pozycji zamówienia

### 📘 Cel:
Gdy pozycja z zamówienia zostanie usunięta, zwracamy ilość produktu z powrotem do magazynu.

```sql
DELIMITER //
CREATE TRIGGER trg_restore_inventory
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET quantity = quantity + OLD.quantity
    WHERE product_id = OLD.product_id;
END //
DELIMITER ;
```

---

## 🔸 3. Ustawienie domyślnego statusu zamówienia tylko przy dodaniu rekordu bez podania statusu

### 📘 Cel:
Wymuszenie statusu `new`, jeśli użytkownik pominął pole statusu w `INSERT` (na wypadek, gdyby domyślna wartość w tabeli została usunięta).

```sql
DELIMITER //
CREATE TRIGGER trg_default_order_status
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.status IS NULL THEN
        SET NEW.status = 'new';
    END IF;
END //
DELIMITER ;
```

---

## 🔸 4. Blokada usuwania produktu, jeśli ma przypisane zamówienia

### 📘 Cel:
Uniemożliwienie usunięcia produktu, który był kiedykolwiek użyty w zamówieniu.

```sql
DELIMITER //
CREATE TRIGGER trg_prevent_product_delete
BEFORE DELETE ON products
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM order_items WHERE product_id = OLD.product_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nie można usunąć produktu powiązanego z zamówieniami.';
    END IF;
END //
DELIMITER ;
```

---
