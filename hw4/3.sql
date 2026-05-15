/*
Дана таблица carts (корзины юзеров) с полями:
cart_id (тип UInt32),
items (тип Array(String)),
prices(тип Array(Float32)),
created_date (тип Date).
Для каждой корзины (cart_id) нужно посчитать:
items_count - количество товаров в корзине
total_price - общая стоимость корзины
has_laptop - есть ли в корзине товар "laptop" (1 - да, 0 - нет)
avg_item_price - средняя цена товара в корзине (округлить до двух знаков)
Результат отсортируйте по убыванию общей стоимости корзины.
*/
DROP TABLE IF EXISTS carts;
CREATE TABLE carts (
    cart_id UInt32,
    items Array(String),
    prices Array(Float32),
    created_date Date
) ENGINE = MergeTree()
ORDER BY cart_id;

INSERT INTO carts VALUES
(1, ['laptop', 'mouse', 'keyboard'], [1200.00, 25.00, 80.00], '2024-03-01'),
(2, ['monitor', 'headphones'], [300.00, 150.00], '2024-03-01'),
(3, ['laptop', 'mousepad', 'usb', 'webcam'], [1200.00, 10.00, 15.00, 60.00], '2024-03-01'),
(4, ['keyboard', 'mouse'], [80.00, 25.00], '2024-03-02'),
(5, ['laptop', 'monitor'], [1200.00, 300.00], '2024-03-02'),
(6, ['headphones', 'usb', 'mousepad'], [150.00, 15.00, 10.00], '2024-03-02'),
(7, ['webcam'], [60.00], '2024-03-03'),
(8, ['laptop', 'keyboard', 'mouse', 'headphones'], [1200.00, 80.00, 25.00, 150.00], '2024-03-03');

SELECT 
    c.cart_id,
    length(c.items) items_count,
    arrayReduce('sum', c.prices) total_price,
    CASE
        WHEN has(c.items, 'laptop') THEN 1
        ELSE 0
    END has_laptop,
    round(arrayReduce('avg', c.prices), 2) avg_item_price
FROM carts c
ORDER BY total_price DESC;