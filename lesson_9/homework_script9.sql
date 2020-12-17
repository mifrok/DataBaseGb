-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
-- Используйте транзакции.
start transaction;
delete from users where id = 1;
insert into users
select * from shop.users where shop.users.id = 1;
commit;

-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
create view proc as
select p.name 'Product name', c.name 'Catalog name' from products p join catalogs c on c.id = p.catalog_id;
select * from proc;

-- Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.
create user shop_read;
create user shop;
grant select on shop.* to 'shop_read';
grant all on shop.* to 'shop';

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
delimiter //
drop function if exists hello//
create function hello()
returns varchar(20) deterministic
begin
	declare x, s varchar(20);
	set x = DATE_FORMAT(now(), '%H%i');
	if x between 600 and 1200 then set s = 'Good morning!';
	elseif x between 1201 and 1800 then set @ = 'Good afternoon!';
	elseif x > 1800 then set s = 'Good evening!';
	else set s = 'Good night!';
	end if;
	return s;
end//
delimiter ;
select hello();

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, 
-- чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
delimiter //
drop trigger if exists check_description//
create trigger check_description before insert on products 
for each ROW 
BEGIN 
	if (NEW.name is NULL and NEW.description is NULL) then SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'insert canceled';
	elseif NEW.name is NULL then set NEW.name = COALESCE (NEW.name, 'No name');
	elseif NEW.description is NULL then set NEW.description = COALESCE (NEW.description, 'No description');
	end if;
END//
delimiter ;
INSERT into products (name, description, price, catalog_id) Values ('test', NULL, 500, 2);
INSERT into products (name, description, price, catalog_id) Values (NULL, 'TEST', 500, 2);
INSERT into products (name, description, price, catalog_id) Values (NULL, NULL, 500, 2);
-- Добавил в обработку, чтобы были не пустые строки, а информация об отсутствии описания или имени :)



-- Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' 
-- и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном 
-- таблице и 0, если она отсутствует.

drop table if exists august;
create table august(
	date varchar(10)
);
delimiter //
drop procedure if exists add_dates_august//
create procedure add_dates_august ()
begin
	declare x INT default 1;
	while x < 32 do
	insert into august values (Date(concat('2018-08-', x)));
	set x = x + 1;
	end while;
end//
delimiter ;
call add_dates_august();

drop table if exists august_search_date;
create table august_search_date(
	date varchar(10)
);
insert into august_search_date values ('2018-08-01'), ('2016-08-04'), ('2018-08-16'), ('2018-08-17');

select
a.`date`,
(if((a.`date` = asd.`date`), 1, 0)) as `check`
from august a 
left join august_search_date asd 
on a.`date` = asd.`date`;


-- Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
-- создадим подзапрос для условия
select created_at from products p
order by p.created_at desc
limit 5, 1;


delimiter //
drop procedure if exists delete_rows//
create procedure delete_rows ()
begin
	set @x = (select created_at from products p order by p.created_at desc limit 5, 1);
	set @y = (select COUNT(id) from products);
	while @y > 5 do
	delete from products where created_at <= @x limit 1;
	set @y = @y - 1;
	end while;
end//
delimiter ;
call delete_rows();

-- очень хотел дописать по фибоначи, но до сдачи дз осталось 20 минут :) допишу факультативно, функции через рекурсию работают в SQL? :)



















