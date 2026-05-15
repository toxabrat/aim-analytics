/*
 Мы хотим отправить рассылку всем работодателям hh, у которых не более 5 активных вакансий. 
 Нужно вывести имена таких работодателей.
 таблицы: hh.employer hh.vacancy
 */
SELECT e.name
FROM hh.employer e
    LEFT JOIN hh.vacancy v ON e.employer_id = v.employer_id
    AND v.active = true
GROUP BY e.employer_id,
    e.name
HAVING count(*) <= 5;