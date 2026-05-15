-- Создание схемы и таблиц для задачи
DROP SCHEMA IF EXISTS hh CASCADE;
CREATE SCHEMA hh;

-- Таблица работодателей
CREATE TABLE hh.employer (
    employer_id bigint PRIMARY KEY,
    name varchar
);

-- Таблица вакансий
CREATE TABLE hh.vacancy (
    vacancy_id bigint PRIMARY KEY,
    active boolean,
    employer_id bigint REFERENCES hh.employer(employer_id)
);

-- Наполнение тестовыми данными
INSERT INTO hh.employer (employer_id, name) VALUES
(1, 'Рога и копыта'),
(2, 'Суперфирма'),
(3, 'Мегакорп'),
(4, 'ООО "Тест"'),
(5, 'ИП Петров'),
(6, 'Яндекс'),
(7, 'Гугл'),
(8, 'Озон'),
(9, 'Тинькофф'),
(10, 'Сбер');

INSERT INTO hh.vacancy (vacancy_id, active, employer_id) VALUES
-- Рога и копыта: 2 активные, 1 неактивная
(1, true, 1),
(2, true, 1),
(3, false, 1),
-- Суперфирма: 5 активных
(4, true, 2),
(5, true, 2),
(6, true, 2),
(7, true, 2),
(8, true, 2),
(9, false, 2),
-- Мегакорп: 6 активных
(10, true, 3),
(11, true, 3),
(12, true, 3),
(13, true, 3),
(14, true, 3),
(15, true, 3),
(16, false, 3),
-- ООО "Тест": 0 активных
(17, false, 4),
(18, false, 4),
-- ИП Петров: 3 активных
(19, true, 5),
(20, true, 5),
(21, true, 5),
(22, false, 5),
-- Яндекс: 1 активная
(23, true, 6),
-- Гугл: 4 активных
(24, true, 7),
(25, true, 7),
(26, true, 7),
(27, true, 7),
(28, false, 7),
-- Озон: 2 активных
(29, true, 8),
(30, true, 8),
(31, false, 8),
-- Тинькофф: 5 активных
(32, true, 9),
(33, true, 9),
(34, true, 9),
(35, true, 9),
(36, true, 9),
(37, false, 9),
-- Сбер: 6 активных
(38, true, 10),
(39, true, 10),
(40, true, 10),
(41, true, 10),
(42, true, 10),
(43, true, 10),
(44, false, 10);

-- Запрос для получения имён работодателей с не более чем 5 активными вакансиями
SELECT e.name
FROM hh.employer e
LEFT JOIN hh.vacancy v ON e.employer_id = v.employer_id AND v.active = true
GROUP BY e.employer_id, e.name
HAVING COUNT(v.vacancy_id) <= 5;