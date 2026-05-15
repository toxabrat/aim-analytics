select
    *
FROM
    transactions;

SELECT
    *
FROM
    products;

SELECT
    *
FROM
    weather;

-- 1. Имеется таблица transactions:
-- id (транзакции)
-- client (клиент)
-- txn_date (дата операции)
-- amount (сумма)
-- Для каждого клиента необходимо рассчитать нарастающий итог сумм транзакций (cumulative total) по датам.
-- То есть для каждой транзакции показать общую сумму всех транзакций этого клиента,
-- включая текущую, начиная с самых ранних. Результат отсортировать по клиенту и дате
SELECT
    t.client,
    t.txn_date,
    sum(t.amount) over (
        PARTITION BY
            t.client
        ORDER BY
            t.txn_date
    ) as sum_transaction
from
    transactions t
ORDER BY
    t.client,
    t.txn_date;

-- 2. Таблица products:
-- id (товара)
-- category (категория)
-- price (цена)
-- Для каждой категории необходимо вывести все товары, отсортированные по убыванию цены, и дополнительно:
-- столбец max_price_in_category – максимальная цена в данной категории;
-- столбец price_diff_from_max – отклонение цены текущего товара от максимума 
-- (в процентах: (price / max_price_in_category - 1) * 100), округлённое до двух знаков.
SELECT
    p.category,
    p.price,
    MAX(p.price) over (
        PARTITION BY
            p.category
    ) as max_price_in_category,
    ROUND(
        (
            p.price * 1.0 / MAX(p.price) over (
                PARTITION BY
                    p.category
            ) - 1
        ) * 100.0,
        2
    ) || '%' as price_diff_from_max
FROM
    products p
ORDER BY
    p.category,
    p.price;

-- 3. Таблица weather:
-- city (город)
-- date (дата)
-- temperature (температура)
-- Для каждого города необходимо рассчитать скользящее среднее температуры 
-- за последние 3 дня (включая текущий) и за последние 5 дней. 
-- Если данных за предыдущие дни недостаточно, среднее считается по имеющимся. 
-- Результат должен содержать: город, дату, температуру, avg_3d и avg_5d.
SELECT
    w.city,
    w.date,
    w.temperature,
    avg(w.temperature) OVER (
        PARTITION BY
            w.city
        ORDER BY
            w.date ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW
    ) as avg_3d,
    avg(w.temperature) OVER (
        PARTITION BY
            w.city
        ORDER BY
            w.date ROWS BETWEEN 4 PRECEDING
            AND CURRENT ROW
    ) as avg_5d
FROM
    weather w
ORDER BY
    city,
    date;

-- 4. Таблица weather:
-- city (город)
-- date (дата)
-- weather (sunny, cloudy, rainy, snowy) -характер погоды
-- Для каждого города вывести даты начала и конца самого длинного солнечного периода. Считаем, что пропусков в датах нет.
SELECT
    *
from
    weather w;

with
    delimeter_table as (
        SELECT
            CASE
                WHEN w.weather != LAG(w.weather, 1, 'null') over (
                    PARTITION BY
                        w.city
                    ORDER BY
                        w.date
                )
                and w.weather = 'sunny' THEN 1
                WHEN w.weather != LEAD(w.weather, 1, 'null') over (
                    PARTITION BY
                        w.city
                    ORDER BY
                        w.date
                )
                and w.weather = 'sunny' THEN 2
                ELSE 0
            END prev_val,
            *
        FROM
            weather w
    ),
    sunny_date as (
        select
            CASE
                WHEN d.prev_val = 1 THEN LEAD(d.date, 1, d.date) over (
                    PARTITION BY
                        d.city
                    ORDER BY
                        d.date
                ) - d.date + 1
                ELSE 0
            END as diff,
            LEAD(d.date, 1, d.date) OVER (
                PARTITION BY
                    d.city
                ORDER BY
                    d.date
            ) as date_to_sunny,
            *
        from
            delimeter_table d
        where
            d.prev_val != 0
    ),
    sunny_day_rn as (
        select
            *,
            ROW_NUMBER() over (
                PARTITION by
                    s.city
                ORDER by
                    diff desc
            )
        from
            sunny_date s
    )
select
    sr.date start_sunny,
    sr.date_to_sunny finish_sunny,
    sr.diff size_sunny,
    sr.city
from
    sunny_day_rn sr
where
    sr.row_number = 1
order by
    sr.diff desc;




