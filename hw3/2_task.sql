/*
    2. Та же таблица sales

Для каждой категории необходимо найти товары, которые входят в топ-2 по сумме продаж. Если несколько товаров делят второе место (имеют одинаковую сумму), включить их все. То есть в результате для категории может быть более двух записей, если есть совпадения сумм на границе топ-2.
*/
WITH collect_items AS (
    SELECT s.product,
        s.category,
        SUM(s.amount) total_sum
    FROM sales s
    GROUP BY s.category,
        s.product
),
row_num_coll_items AS (
    SELECT *,
        DENSE_RANK() OVER(
            PARTITION BY c.category
            ORDER BY c.total_sum DESC
        ) dense_rank
    FROM collect_items c
)
SELECT r.product,
    r.category,
    r.total_sum
FROM row_num_coll_items r
WHERE r.dense_rank < 3
ORDER BY r.category, r.total_sum DESC;
