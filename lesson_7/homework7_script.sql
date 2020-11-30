-- вопрос по теме
-- в 7 уроке рассказывается про сравнение нескольких значений и дается следующий пример
select id, name, catalog_id from products
where (catalog_id, 5060.00) in (select id, price from catalogs)
-- в таблице продукты есть столбец прайс, а в таблице каталогс такой столбец ОТСУТСТВУЕТ,  каким образом команда select id, price from catalogs выполняется в данном примере?
-- я пробовал на тестовых данных, данный кусок кода не выдает ошибки в таком формате, но если запустить отдельно команду select id, price from catalogs - будет ошибка.
-- не могу понять как это работает.



-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
drop table if exists orders;
create table orders(
	id SERIAL primary key,
	user_id bigint,
	created_at DATETIME DEFAULT NOW()
	);
ALTER table homework7.orders add foreign key (user_id) references users (id);
-- case 1
select
u.name
from
orders o
join users u 
on o.user_id = u.id
group by u.name;
-- case 2
select name from users
where id in (select user_id from orders);

-- Выведите список товаров products и разделов catalogs, который соответствует товару.
select c.name as 'Catalog', p.name as 'Product' from products p join catalogs c on p.catalog_id = c.id;

-- Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
drop table if exists flights;
CREATE table flights(
	id SERIAL,
	_from varchar(50),
	_to varchar(50)
	)
drop table if exists cities;
CREATE table cities(
	label varchar(50),
	name varchar(50)
	)
insert into flights (_from, _to) values ('moscow', 'omsk'), ('novgorod', 'kazan'), ('irkutsk', 'moscow'), ('omsk', 'irkutsk'), ('moscow', 'kazan');
insert into cities (label, name) values ('moscow', 'Москва'),('omsk', 'Омск'),('novgorod', 'Новгород'),('kazan', 'Казань'),('irkutsk', 'Иркутск');

select
f.id,
c.name ,
c2.name 
from flights f join cities c on f.`_from` = c.label join cities c2 on f.`_to` = c2.label
order by f.id ;




	
	
	