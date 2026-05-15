/*
 Вывести в каждом городе топ-5 моделей авто по кол-ву завершенных заказов 
 (то есть поездка состоялась) за 2025 год. Вывести поля: город, модель, кол-во заказов. 
 Отсортировать: по городу в алфавитном порядке и по убыванию кол-ва заказов.
 
 таблицы: taxi.order
 */
WITH race_rating AS (
    SELECT COUNT(*) AS count_race,
        o.city_name,
        o.car_model
    FROM taxi."order" o
    WHERE o.order_status = TRUE
        AND EXTRACT(
            YEAR
            FROM o.created_at
        ) = 2025
    GROUP BY o.city_name,
        o.car_model
),
count_race_rating AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY r.city_name
            ORDER BY r.count_race DESC
        ) AS row_num
    FROM race_rating AS r
)
SELECT c.city_name,
    c.car_model,
    c.count_race
FROM count_race_rating c
WHERE c.row_num <= 5
ORDER BY c.city_name,
    c.count_race DESC;