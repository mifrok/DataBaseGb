-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- За "больше всех общался" берем исходящие сообщения, прочитанные другими пользователями

-- 1) выбираем список друзей - это будет вложенный запрос
select *
from
((select fr.target_user_id friends from friend_requests fr where fr.initiator_user_id = 50 and fr.status = 'approved')
UNION
(select fr.initiator_user_id from friend_requests fr where fr.target_user_id = 50 and fr.status = 'approved')) as friend_list;

-- 2) Выбираем пользователей с наибольшим кол-вом сообщений и выводим одного в результат
SELECT 
count(*) as sent_msg_count,
u.firstname,
u.lastname 
from 
	((select fr.target_user_id friends from friend_requests fr where fr.initiator_user_id = 50 and fr.status = 'approved')
	UNION
	(select fr.initiator_user_id from friend_requests fr where fr.target_user_id = 50 and fr.status = 'approved')) as friend_list
		join users u
		on friend_list.friends = u.id
		join messages m
		on m.is_read = 1 and m.from_user_id = 50 and m.to_user_id = friend_list.friends
GROUP by m.to_user_id 
order by sent_msg_count DESC -- сортируем по убыванию, чтобы на первом месте был нужный человек
limit 1; -- выводим одного человека как по условию задачи


-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- таблица лайков была пустой, вместо генерации сбросил несколько лайков в таблицу
-- Считаем лайки на посты
-- 1) Определим 10 самых молодых пользователей (id)
select
u.id,
u.firstname,
u.lastname 
FROM users u
order by u.birthday desc
limit 10;
-- 2) Получаем посты пользователей и лайки к ним, затем считаем общее количество
SELECT
	count(*) as like_count
from 
	(select
	u.id,
	u.firstname,
	u.lastname 
	FROM users u
	order by u.birthday desc
	limit 10) as youngest
		join posts p 
		on youngest.id = p.user_id -- получаем посты и их ид
		join likes_posts lp 
		on lp.post_id = p.id -- получаем посты, на которых имеются лайки
; 

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

select
case 
	when u.gender = 'f' then 'Женщины'
	when u.gender = 'm' then 'Мужчины'
end as 'Поставили максимальное количество лайков'
from 
likes_posts lp
join users u 
on u.id = lp.user_id
group by u.gender
order by count(u.gender) desc
limit 1;

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- Возьмем пользователей с минимальным количеством сообщений,постов, так как таблица лайков и комментов не наполнена (наполню в другой раз :) )
select 
	count(*) as activity,
	u.firstname,
	u.lastname,
	u.id 
from -- через юнион выбираем активные действия пользователей
	(select from_user_id as activity from messages
	union all
	select user_id from posts
	union all
	select user_id from comments) as all_count
		join users u -- добавляем имена фамилии
		on u.id = all_count.activity
group by activity -- группируем активность по пользователям
order by activity
limit 10;

























