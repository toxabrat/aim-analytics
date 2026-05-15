
/*
    1. Имеется таблица sales (id, product, category, amount):
Для каждой продажи необходимо вывести id, общую сумму продаж (total_amount), долю этой продажи от всех (sale_percentage)

*/
SELECT s.id,
    SUM(s.amount) OVER() total_amount,
    ROUND(s.amount * 1.0 / SUM(s.amount) OVER() * 100) || '%' sale_percentage
FROM sales s;
