-- создаем таблицу сотрудников
CREATE TABLE employers (
    id             int  NOT NULL GENERATED ALWAYS AS IDENTITY  PRIMARY KEY, -- ИД сотрудника
    fio             varchar(250), --ФИО
    birthday        date, -- день рождения
    first_day       date, -- дата начала работы
    position        varchar(100), -- должность
    level           int, -- уровень сотрудника 1- jun, 2-middle, 3- senior, 4- lead
    salary          real, -- зарплата
    department_id   int, -- идентификатор отдела
    drive_lic       boolean -- наличие водительских прав 
);

--создаем таблицу отделов
CREATE TABLE departments (
    id             int NOT NULL GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,  -- ИД отдела
    name           varchar(250), -- название отдела
    FIO            varchar(250), -- ФИО руководителя
    emp_count      int --количество сотрудников
)
-- таблица оценок сотрудников
CREATE TABLE marks (
    emloyer_id             int,  -- ИД сотрудника
    year           int, -- год
    quarter        int CHECK (quarter>0 and quarter<5), -- номер квартала
    mark           int CHECK(mark>0 and mark<6)  --оценка
)
-- добавляем отделы
INSERT INTO public.departments
("name", fio, emp_count)
VALUES('Деревообработка', 'Молчалин Е.П.', 3);
INSERT INTO public.departments
("name", fio, emp_count)
VALUES('Металл', 'Хлестаков В.Ф.', 2);

--добавляем начальников отделов в список сотрудников
INSERT INTO public.employers
( fio, birthday, first_day, "position", "level", salary, department_id, drive_lic)
VALUES( 'Молчалин Е.П.', '2000-01-05','2020-05-05', 'Начальник отдела Деревообработки',  4, 150000, 1, true),
( 'Хлестаков В.Ф.', '2000-01-05','2020-05-05', 'Начальник отдела Металл',  4, 150000, 2, true)
;
-- добавляем сотрудников
INSERT INTO public.employers
( fio, birthday, first_day, "position", "level", salary, department_id, drive_lic)
VALUES( 'Иванов И.И.', '2000-01-05','2020-05-05', 'Столяр',  1, 50000, 1, false);
INSERT INTO public.employers
( fio, birthday, first_day, "position", "level", salary, department_id, drive_lic)
VALUES ('Петров И.И.', '2001-02-06','2020-05-05', 'Плотник',  2, 60000, 1, True);
INSERT INTO public.employers
( fio, birthday, first_day, "position", "level", salary, department_id, drive_lic)
VALUES ('Сидоров С.С.', '2001-03-07','2020-06-06', 'Плотник',  3, 70000, 1, False);
INSERT INTO public.employers
( fio, birthday, first_day, "position", "level", salary, department_id, drive_lic)
VALUES ('Васечкин П.М.', '2001-04-07','2020-07-07', 'Главный слесарь',  4, 160000, 2, True);
INSERT INTO public.employers
( fio, birthday, first_day, "position", "level", salary, department_id, drive_lic)
VALUES ('Иночкин П.И.', '2001-05-08','2020-08-08', 'Слесарь',  1, 40000, 2, True);
--добавляем оценки
INSERT INTO public.marks
(emloyer_id, "year", quarter, mark)
VALUES(1, 2020, 1, 1),
(1, 2020, 2, 2),
(1, 2020, 3, 2),
(1, 2020, 4, 3),
(2, 2020, 1, 5),
(2, 2020, 2, 5),
(2, 2020, 3, 5),
(2, 2020, 4, 5),
(3, 2020, 1, 4),
(3, 2020, 2, 5),
(3, 2020, 3, 4),
(3, 2020, 4, 4),
(4, 2020, 1, 3),
(4, 2020, 2, 3),
(4, 2020, 3, 4),
(4, 2020, 4, 3),
(5, 2020, 1, 2),
(5, 2020, 2, 4),
(5, 2020, 3, 5),
(5, 2020, 4, 3);

--добавляем новый отдел
INSERT INTO public.departments
("name", fio, emp_count)
VALUES('отдел Интеллектуального анализа данных', 'Галицкий Д.А.', 2);
--добавляем начальника отдела и новых сотрудников
INSERT INTO public.employers
( fio, birthday, first_day, "position", "level", salary, department_id, drive_lic)
VALUES ('Галицкий Д.А.', '1978-05-09','2022-11-01', 'Начальник отдела',  4, 150000, 3, True),
('Егоров В.В.', '2001-05-08','2022-11-01', 'Аналитик',  2, 100000, 3, True),
('Егоров Ф.В.', '2001-05-08','2022-11-01', 'Аналитик',  1, 100000, 3, True);

--Уникальный номер сотрудника, его ФИО и стаж работы – для всех сотрудников компании
SELECT id, fio, DATE_PART('year', now()) -DATE_PART('year',first_day) as year_stage
FROM public.employers;
--Уникальный номер сотрудника, его ФИО и стаж работы – только первых 3-х сотрудников
SELECT  id, fio, DATE_PART('year', now()) -DATE_PART('year',first_day) as year_stage
FROM public.employers
limit 3;

--Уникальный номер сотрудников - водителей
SELECT  id
FROM public.employers
where drive_lic=true;

-- Выведите номера сотрудников, которые хотя бы за 1 квартал получили оценку D или E
SELECT  id
FROM public.employers
where id in (SELECT emloyer_id
FROM public.marks where mark=4 or mark=5);

--Выведите самую высокую зарплату в компании
SELECT  max(salary)
FROM public.employers;


--Выведите название самого крупного отдела
select d.name from public.departments d
join (select department_id, count (id) as cn
FROM public.employers
group by department_id
order by cn desc
limit 1) s on d.id=s.department_id;

--Выведите номера сотрудников от самых опытных до вновь прибывших
SELECT  id
FROM public.employers
order by first_day asc;

-- Рассчитайте среднюю зарплату для каждого уровня сотрудников
SELECT  avg(salary ), "level" 
FROM public.employers
group by "level" ;
