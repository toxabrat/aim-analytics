-- test
select *
from opliuta.users;
/*
 Данные:
 Дана таблица users c id пользователя (user_id) и его городом (city). 
 1 пользователю соответствует только 1 город. 
 Нет пустых значений user_id и city и нет дублей.
 Дана таблице regs с user_id и его датой регистрации (reg_date). 
 В этой таблице также нет пропусков и дублей.
 Дана таблица payments с user_id, суммой (amount) и датой и временем платежа (payment_dt). 
 Нет повторных платежей у одного юзера в один и тот же момент времени.
 */
--1. Нужно посчитать, в каком городе какой процент пользователей живет (в ответе таблица вида Москва 20%, СПб 40% и т.д).
SELECT city,
    ROUND(
        count(*) * 100.0 / (
            select count(*)
            from opliuta.users
        )
    ) || '%' as "procent"
from opliuta.users
group by city;
--2. Нужно вывести список городов, где средний чек (average order value) превышает 250, и количество платящих пользователей в этих городах.
-- joinim 1 и 3 табличку берем тех у кого 
with avg_user as (
    select u.city,
        count(DISTINCT p.user_id) as count_
    from opliuta.users u
        JOIN opliuta.payments p on u.user_id = p.user_id
    GROUP BY u.city
    HAVING avg(amount) > 250
)
SELECT DISTINCT u.city,
    (
        select a.count_
        from avg_user a
        where a.city = u.city
    ) as payment_users_count
from opliuta.users u
where u.city in (
        select city
        from avg_user
    );
--3. Нужно посчитать средний чек первого заказа в каждом городе.
with first_trade as (
    select DISTINCT on (u.user_id) *
    from opliuta.users u
        JOIN opliuta.payments p on u.user_id = p.user_id
    order by u.user_id,
        p.payment_dt
)
SELECT f.city,
    avg(f.amount) as avg_receipt
from first_trade f
group by city
order by avg_receipt desc;
--4. Нужно посчитать общую выручку (сумму всех платежей) в каждом городе. Вывести только те города, общая выручка которых превышает среднюю выручку по всем городам.
with total_city as (
    select u.city,
        sum(p.amount) total_amount
    from opliuta.users u
        JOIN opliuta.payments p on u.user_id = p.user_id
    group by u.city
)
select distinct u.city,
    (
        select t.total_amount
        from total_city t
        where t.city = u.city
    )
from opliuta.users u
where (
        select t.total_amount
        from total_city t
        where t.city = u.city
    ) > (
        select avg(t.total_amount)
        from total_city t
    );
/*
 5. Нужно посчитать 2 метрики:
 - ARPU пользователей за январь 2026,
 - ARPU новых пользователей за январь 2026.
 Новым пользователем за определенный период считается пользователь, у которого дата регистрации совпадает с этим периодом.
 В январе 2026 у нас точно есть новые пользователи.
 */
-- arpu средний доход за привлеченного пользователя за какую то дату
select *
from opliuta.payments p
where p.payment_dt > date '2026-01-01'
    and p.payment_dt < date '2026-02-01';
with sum_person_jan as (
    with first_trade_jan as (
        with sort_rank as (
            select p.user_id,
                p.payment_dt,
                count(*) over (
                    PARTITION BY p.user_id
                    ORDER BY p.payment_dt
                ) as count_
            from opliuta.payments p
        )
        select user_id
        from sort_rank s
        where s.count_ = 1
            and s.payment_dt >= date '2026-01-01'
            and s.payment_dt < date '2026-02-01'
    )
    select sum(p.amount) as arpu,
        sum(p.amount) FILTER (
            WHERE p.user_id in (
                    select *
                    from first_trade_jan
                )
        ) as arpu_new_users
    from opliuta.payments p
    where p.payment_dt >= date '2026-01-01'
        and p.payment_dt < date '2026-02-01'
    group by p.user_id
)
select sum(su.arpu) * 1.0 / count(su.arpu) as arpu,
    sum(su.arpu_new_users) / count(su.arpu_new_users)
from sum_person_jan su;

/*
 --6*. Нужно для каждого города посчитать конверсию из регистрации в первый платёж 
 в течение первых 7 дней после регистрации. Вывести только те города, где такая конверсия 
 превышает 50%. Упорядочить по убыванию конверсии.
 */
with sort_rank as (
    select p.user_id,
        p.payment_dt,
        count(*) over (
            PARTITION BY p.user_id
            ORDER BY p.payment_dt
        ) as count_
    from opliuta.payments p
),
converse_user as (
    select r.user_id
    from opliuta.regs r
        join sort_rank s on r.user_id = s.user_id
    where s.count_ = 1
        and s.payment_dt <= r.reg_date + INTERVAL '7' day
)
select u.city,
    count(*) * 1.0 / (
        select count(*)
        from opliuta.users ou
        where ou.city = u.city
    )
from converse_user c
    join opliuta.users u on c.user_id = u.user_id
group by u.city;

