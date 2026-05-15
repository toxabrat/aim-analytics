/*
Дана таблица user_actions с полями: 
user_id (тип UInt32),
action (тип String, возможные значения - 'purchase', 'view'),
amount (тип String - обратите внимание!),
action_date (тип Date).
Посчитайте для каждого пользователя:
Общее количество покупок (purchase_count)
Сумму всех покупок (total_purchase_amount)
*/
DROP TABLE IF EXISTS user_actions;

CREATE TABLE user_actions (
    user_id UInt32,
    action String,
    amount String,
    action_date Date
) ENGINE = MergeTree()
ORDER BY
    (action_date, user_id);

INSERT INTO
    user_actions
VALUES
    (1, 'purchase', '1500', '2024-03-01'),
    (1, 'view', '0', '2024-03-01'),
    (1, 'purchase', '2300', '2024-03-05'),
    (2, 'purchase', '500', '2024-03-01'),
    (2, 'purchase', '150', '2024-03-02'),
    (2, 'view', '0', '2024-03-03'),
    (3, 'purchase', '3200', '2024-03-02'),
    (3, 'purchase', '450', '2024-03-03'),
    (3, 'purchase', '800', '2024-03-04'),
    (4, 'view', '0', '2024-03-01'),
    (4, 'view', '0', '2024-03-02');

SELECT
    u.user_id,
    count(u.user_id) purchase_count,
    sum(toFloat64(u.amount)) total_purchase_amount
from
    user_actions u
WHERE
    u.action = 'purchase'
GROUP BY
    u.user_id;


