-- 1 task
UPDATE users 
SET
created_at = NOW(),
updated_at = NOW()
WHERE id BETWEEN 2 AND 3;

-- 2 task взял формат из формулировки задачи, было очень сложно сконвертировать время полностью, отбросил часы и минуты. Не понятно по конвертации...
UPDATE users 
SET
created_at = str_to_date((CONCAT(SUBSTRING(created_at, 1, 2), '/', SUBSTRING(created_at, 4, 2), '/', SUBSTRING(created_at, 7, 4))), '%d/%m/%Y'),
updated_at = str_to_date((CONCAT(SUBSTRING(updated_at, 1, 2), '/', SUBSTRING(updated_at, 4, 2), '/', SUBSTRING(updated_at, 7, 4))), '%d/%m/%Y');
ALTER TABLE users CHANGE created_at created_at DATETIME;
ALTER TABLE users CHANGE updated_at updated_at DATETIME;

-- 3 задача
SELECT value from storehouses_products order by value DESC 
