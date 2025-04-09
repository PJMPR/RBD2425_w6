# 👋 Wstęp do prezentacji – Czy zwykły SQL wystarczy?

Wyobraźcie sobie taką sytuację:

> "Chcemy zbudować prosty system obsługi sklepu online – mamy klientów, produkty, zamówienia. Potrzebujemy automatycznie aktualizować stany magazynowe, liczyć wartość zamówienia, a może nawet blokować pewne akcje, jeśli dane są niespójne."

Brzmi znajomo? Można próbować to wszystko ogarnąć za pomocą klasycznych zapytań SQL:

```sql
-- Dodaj zamówienie
INSERT INTO orders (...);

-- Dodaj pozycje zamówienia
INSERT INTO order_items (...);

-- Ręczna aktualizacja stanu magazynowego
UPDATE inventory SET quantity = quantity - ...;
```

Ale… czy to wystarczy?

---

## 🤔 Pytania na start

- Jak upewnić się, że stan magazynowy nie spadnie poniżej zera?
- Jak automatycznie obliczyć wartość zamówienia?
- Jak zapewnić, że dane są zawsze spójne bez konieczności pisania wielu zapytań?

Czy czysty SQL poradzi sobie ze wszystkim? Niekoniecznie.

---

## 🧨 Przykład problematycznej operacji w "czystym" SQL

Załóżmy, że chcemy:
1. Dodać nowe zamówienie,
2. Dodać kilka pozycji do zamówienia,
3. Zmniejszyć odpowiednio stan magazynowy,
4. Obliczyć łączną wartość zamówienia,
5. Zmienić status zamówienia na 'shipped', jeśli wszystko poszło dobrze,
6. A jeśli coś pójdzie nie tak – wycofać wszystkie zmiany.

Z poziomu klasycznego SQL (bez logiki proceduralnej) wyglądałoby to tak:

```sql
START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUES (5, NOW(), 'new');

SET @order_id = LAST_INSERT_ID();

-- Dodanie pozycji (przykładowe produkty)
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(@order_id, 1, 2),
(@order_id, 2, 3);

-- Sprawdź dostępność
SELECT quantity FROM inventory WHERE product_id IN (1, 2);
-- Ręczna analiza wyniku...

-- Zmniejsz stan
UPDATE inventory SET quantity = quantity - 2 WHERE product_id = 1;
UPDATE inventory SET quantity = quantity - 3 WHERE product_id = 2;

-- Oblicz wartość
SELECT SUM(oi.quantity * p.price) AS total_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = @order_id;

-- Zaktualizuj status zamówienia
UPDATE orders SET status = 'shipped' WHERE order_id = @order_id;

COMMIT;
```

😵‍💫 Dużo rzeczy do ogarnięcia.
- Co jeśli w międzyczasie ktoś zmieni stan magazynowy?
- Co jeśli ktoś pominie krok?
- Jak sprawdzić, czy wszystko poszło dobrze?

---

## 🔍 Czego będziemy się uczyć

Tu wchodzą do gry:

- **Procedury** – by wykonywać całe sekwencje instrukcji jednym wywołaniem
- **Funkcje** – by przeliczać dane i zwracać wyniki w zapytaniach
- **Triggery** – by reagować automatycznie na zmiany danych w tabelach

To potężne narzędzia, które pozwalają zbudować logikę aplikacji **po stronie bazy danych** i znacznie uprościć kod po stronie klienta lub aplikacji webowej.

---

Zastanowimy się:
- **kiedy** warto sięgnąć po te narzędzia,
- **jak** z nich korzystać,
- i **dlaczego** są nieocenione w prawdziwych projektach.


