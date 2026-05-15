/*
2. Нам нужно отобрать учеников, которые поедут на олимпиаду по математике. Критерии для участников:
    a. отличник по математике: смотрим на средний балл - достаточно, чтобы при округлении до целого было 5,
    b. нет двоек по математике,
    c. хорошист по всем предметам в целом: смотрим на средний балл - не ниже 4.
таблицы: school.Journal
*/
WITH math_cool_person AS (
    SELECT j.last_name
    FROM school.Journal j
    WHERE j.subject = 'Математика'
    GROUP BY j.last_name
    HAVING ROUND(avg(j.score)) = 5
        and min(j.score) != 2
)
SELECT j.last_name
FROM school.Journal j
GROUP BY j.last_name
HAVING avg(j.score) >= 4
    and j.last_name in (
        SELECT last_name
        from math_cool_person
    );

