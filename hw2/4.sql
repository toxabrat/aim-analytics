-- =============================================
-- ОЧИСТКА И ПОДГОТОВКА
-- =============================================
DROP TABLE IF EXISTS taxi."order" CASCADE;
DROP SCHEMA IF EXISTS taxi CASCADE;
CREATE SCHEMA taxi;

-- =============================================
-- СОЗДАНИЕ ТАБЛИЦЫ
-- =============================================
CREATE TABLE taxi."order" (
    user_id UUID,
    order_id UUID,
    city_name VARCHAR(100),
    car_model VARCHAR(100),
    order_status BOOLEAN,
    amount_rub FLOAT,
    created_at TIMESTAMP
);

-- =============================================
-- INSERT DATA
-- =============================================
INSERT INTO taxi."order" (user_id, order_id, city_name, car_model, order_status, amount_rub, created_at) VALUES
-- ============================================================================
-- МОСКВА (Должно попасть в топ-5: Kia, Hyundai, BMW, Mercedes, Toyota)
-- ============================================================================
-- 1. Kia Rio (5 заказов в 2025) -> ТОП 1
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', TRUE, 350.00, TIMESTAMP '2025-01-15 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', TRUE, 380.00, TIMESTAMP '2025-02-10 11:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', TRUE, 320.00, TIMESTAMP '2025-03-05 12:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', TRUE, 360.00, TIMESTAMP '2025-04-20 13:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', TRUE, 340.00, TIMESTAMP '2025-05-15 14:00:00'),

-- 2. Hyundai Solaris (4 заказа в 2025) -> ТОП 2
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Hyundai Solaris', TRUE, 330.00, TIMESTAMP '2025-01-20 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Hyundai Solaris', TRUE, 350.00, TIMESTAMP '2025-02-25 11:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Hyundai Solaris', TRUE, 310.00, TIMESTAMP '2025-03-30 12:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Hyundai Solaris', TRUE, 340.00, TIMESTAMP '2025-04-10 13:00:00'),

-- 3. BMW 5 (3 заказа в 2025) -> ТОП 3
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'BMW 5', TRUE, 1200.00, TIMESTAMP '2025-02-15 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'BMW 5', TRUE, 1300.00, TIMESTAMP '2025-03-20 11:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'BMW 5', TRUE, 1100.00, TIMESTAMP '2025-04-25 12:00:00'),

-- 4. Mercedes E (2 заказа в 2025) -> ТОП 4
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Mercedes E', TRUE, 1500.00, TIMESTAMP '2025-03-10 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Mercedes E', TRUE, 1400.00, TIMESTAMP '2025-04-15 11:00:00'),

-- 5. Toyota Camry (2 заказа в 2025) -> ТОП 5
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Toyota Camry', TRUE, 900.00, TIMESTAMP '2025-05-05 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Toyota Camry', TRUE, 950.00, TIMESTAMP '2025-06-10 11:00:00'),

-- 6. Audi A6 (1 заказ в 2025) -> НЕ ПОПАДЕТ (6 место)
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Audi A6', TRUE, 1300.00, TIMESTAMP '2025-07-01 10:00:00'),

-- 7. Volkswagen Polo (1 заказ в 2025) -> НЕ ПОПАДЕТ (7 место)
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Volkswagen Polo', TRUE, 400.00, TIMESTAMP '2025-08-01 10:00:00'),

-- ЛОВУШКИ (Не должны попасть в выборку)
-- Отмененный заказ (FALSE) - не должен считаться
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', FALSE, 350.00, TIMESTAMP '2025-09-01 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', FALSE, 350.00, TIMESTAMP '2025-10-01 10:00:00'),
-- Заказ в 2024 году - не должен считаться
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', TRUE, 350.00, TIMESTAMP '2024-12-31 23:59:00'),
-- Заказ в 2026 году - не должен считаться
(gen_random_uuid(), gen_random_uuid(), 'Москва', 'Kia Rio', TRUE, 350.00, TIMESTAMP '2026-01-01 00:00:00'),

-- ============================================================================
-- САНКТ-ПЕТЕРБУРГ (Должно попасть в топ-5: Kia, Hyundai, Skoda, BMW, VW)
-- ============================================================================
-- 1. Kia Rio (4 заказа в 2025) -> ТОП 1
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Kia Rio', TRUE, 340.00, TIMESTAMP '2025-01-15 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Kia Rio', TRUE, 360.00, TIMESTAMP '2025-02-15 11:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Kia Rio', TRUE, 350.00, TIMESTAMP '2025-03-15 12:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Kia Rio', TRUE, 370.00, TIMESTAMP '2025-04-15 13:00:00'),

-- 2. Hyundai Solaris (3 заказа в 2025) -> ТОП 2
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Hyundai Solaris', TRUE, 320.00, TIMESTAMP '2025-01-20 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Hyundai Solaris', TRUE, 330.00, TIMESTAMP '2025-02-20 11:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Hyundai Solaris', TRUE, 340.00, TIMESTAMP '2025-03-20 12:00:00'),

-- 3. Skoda Octavia (3 заказа в 2025) -> ТОП 3
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Skoda Octavia', TRUE, 500.00, TIMESTAMP '2025-02-10 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Skoda Octavia', TRUE, 520.00, TIMESTAMP '2025-03-10 11:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Skoda Octavia', TRUE, 510.00, TIMESTAMP '2025-04-10 12:00:00'),

-- 4. BMW 3 (2 заказа в 2025) -> ТОП 4
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'BMW 3', TRUE, 1100.00, TIMESTAMP '2025-03-05 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'BMW 3', TRUE, 1150.00, TIMESTAMP '2025-04-05 11:00:00'),

-- 5. Volkswagen Polo (2 заказа в 2025) -> ТОП 5
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Volkswagen Polo', TRUE, 390.00, TIMESTAMP '2025-04-01 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Volkswagen Polo', TRUE, 400.00, TIMESTAMP '2025-05-01 11:00:00'),

-- 6. Toyota Camry (1 заказ в 2025) -> НЕ ПОПАДЕТ (6 место)
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Toyota Camry', TRUE, 880.00, TIMESTAMP '2025-05-15 10:00:00'),

-- ЛОВУШКИ
-- Отмененный заказ
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Kia Rio', FALSE, 340.00, TIMESTAMP '2025-06-01 10:00:00'),
-- 2024 год
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Kia Rio', TRUE, 340.00, TIMESTAMP '2024-06-01 10:00:00'),
-- 2026 год
(gen_random_uuid(), gen_random_uuid(), 'Санкт-Петербург', 'Kia Rio', TRUE, 340.00, TIMESTAMP '2026-06-01 10:00:00'),

-- ============================================================================
-- КАЗАНЬ (Меньше 5 моделей - проверка, что запрос не сломается)
-- ============================================================================
-- 1. Kia Rio (3 заказа в 2025) -> ТОП 1
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Kia Rio', TRUE, 300.00, TIMESTAMP '2025-01-10 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Kia Rio', TRUE, 310.00, TIMESTAMP '2025-02-10 11:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Kia Rio', TRUE, 320.00, TIMESTAMP '2025-03-10 12:00:00'),

-- 2. Hyundai Solaris (2 заказа в 2025) -> ТОП 2
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Hyundai Solaris', TRUE, 290.00, TIMESTAMP '2025-01-15 10:00:00'),
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Hyundai Solaris', TRUE, 300.00, TIMESTAMP '2025-02-15 11:00:00'),

-- 3. Skoda Rapid (1 заказ в 2025) -> ТОП 3
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Skoda Rapid', TRUE, 450.00, TIMESTAMP '2025-03-01 10:00:00'),

-- ЛОВУШКИ
-- Отмененный заказ
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Kia Rio', FALSE, 300.00, TIMESTAMP '2025-04-01 10:00:00'),
-- 2026 год
(gen_random_uuid(), gen_random_uuid(), 'Казань', 'Kia Rio', TRUE, 300.00, TIMESTAMP '2026-01-15 10:00:00')
;