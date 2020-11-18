-- task 1
select AVG(FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25)) as average_age from users;

-- task 2
select COUNT(*) birthday_count, 
	CASE 
		WHEN DAYOFWEEK(Date(CONCAT('2020-', SUBSTRING(birthday_at, 6, 5)))) = 1 THEN 'Monday'
		WHEN DAYOFWEEK(Date(CONCAT('2020-', SUBSTRING(birthday_at, 6, 5)))) = 2 THEN 'Tuesday'
		WHEN DAYOFWEEK(Date(CONCAT('2020-', SUBSTRING(birthday_at, 6, 5)))) = 3 THEN 'Wednesday'
		WHEN DAYOFWEEK(Date(CONCAT('2020-', SUBSTRING(birthday_at, 6, 5)))) = 4 THEN 'Thursday'
		WHEN DAYOFWEEK(Date(CONCAT('2020-', SUBSTRING(birthday_at, 6, 5)))) = 5 THEN 'Friday'
		WHEN DAYOFWEEK(Date(CONCAT('2020-', SUBSTRING(birthday_at, 6, 5)))) = 6 THEN 'Saturday'
		WHEN DAYOFWEEK(Date(CONCAT('2020-', SUBSTRING(birthday_at, 6, 5)))) = 7 THEN 'Sunday'
	end as weeks
from users group by weeks