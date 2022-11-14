--   Попробуйте вывести не просто самую высокую зарплату во всей команде, а вывести именно фамилию сотрудника с самой высокой зарплатой.
select fio, salary
from employers
order by salary DESC
limit 1;


--Попробуйте вывести фамилии сотрудников в алфавитном порядке
select fio
from employers
order by fio asc;

-- Рассчитайте средний стаж для каждого уровня сотрудников
select avg( DATE_PART('year', now()) -DATE_PART('year',first_day)) as year_stage, "level"
from employers
group by "level";

--  Выведите фамилию сотрудника и название отдела, в котором он работает
select employers.fio, departments.name
from employers
join departments on departments.id = employers.department_id;

-- Выведите название отдела и фамилию сотрудника с самой высокой зарплатой в данном отделе и саму зарплату также.
select  departments.name, employers.fio,employers.salary
from employers
join departments on departments.id = employers.department_id
order by salary DESC
limit 1;

-- Выведите название отдела, сотрудники которого получат наибольшую премию по итогам года. 
-- Как рассчитать премию можно узнать в последнем задании предыдущей домашней работы

--(marks.mark-3.0)/10.0 - это расчет коэффициента премии за квартал
-- умножаем коэффициент на ЗП - получаем премию
select departments.name,sum(employers.salary*(marks.mark-3.0)/10.0) as premia--,marks.mark,(marks.mark-3.0)/10.0
from employers
join marks on marks.emloyer_id=employers.id
join departments on departments.id = employers.department_id
group by departments.name
order by premia desc
limit 1;

--Проиндексируйте зарплаты сотрудников с учетом коэффициента премии. 
--Для сотрудников с коэффициентом премии больше 1.2 – размер индексации составит 20%, 
--для сотрудников с коэффициентом премии от 1 до 1.2 размер индексации составит 10%. 
--Для всех остальных сотрудников индексация не предусмотрена.

-- делаем индексацию на 20%
update employers
set salary=salary*1.2
where id in 
(select emloyer_id from 
   (select  emloyer_id  , sum((marks.mark-3.0)/10.0) as s
     from marks
     group by emloyer_id
     having sum((marks.mark-3.0)/10.0) >0.2) p1);

update employers
set salary=salary*1.1
where id in 
(select emloyer_id from 
   (select  emloyer_id  , sum((marks.mark-3.0)/10.0) as s
    from marks
    group by emloyer_id
    having sum((marks.mark-3.0)/10.0) <0.2
       and sum((marks.mark-3.0)/10.0) >=0.0 ) p1);
