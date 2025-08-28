/*select c.client_id, c.name, c.age,
(select count(*) from accounts a where a.client_id = c.client_id) as total_accounts,

(select sum(a.balance) from accounts a where a.client_id = c.client_id) as total_balance,

(select count(*) from transactions t join accounts a on t.account_id = a.account_id where a.client_id = c.client_id and t.transaction_type = 'deposit') as total_deposits,

(select count(*) from transactions t join accounts a on t.account_id = a.account_id where a.client_id = c.client_id and t.transaction_type = 'withdrawal') as total_withdrawals

from clients c where c.registration_date >= '2020-01-01' order by total_balance desc;

Данный запрос будет выполнятся долго на больших данных, здесь привидены 3 коррелированных подзапроса, каждый из них будет повторно сканировать таблицы accounts и transactions
Моя оптимизация заключается в том чтобы вынести агрегирование в отдельные подзапросы и присоединить их по client_id

*/


SELECT
	c.client_id,
	c.name,
	c.age,
	COUNT(DISTINCT a.account_id) AS total_accounts, -- считаем количество акков, distinct использовал чтобы join на 26 строке не размножал строки
	COALESCE(SUM(a.balance), 0) AS total_balance, -- общий баланс клиента со всех акков
	SUM(CASE WHEN t.transaction_type = 'deposit' THEN 1 ELSE 0 END) AS total_deposits, -- количество депозитов
	SUM(CASE WHEN t.transaction_type = 'withdrawal' THEN 1 ELSE 0 END) AS total_withdrawals -- количество выводов
FROM clients c
LEFT JOIN accounts a ON a.client_id = c.client_id -- подтягиваем счета клиентов по client_id
LEFT JOIN transactions t ON t.account_id = a.account_id -- подтягиваем транзацкии по счетам клиентов
WHERE c.registration_date >= '2020-01-01' 
GROUP BY c.client_id, c.name, c.age -- Группируем по клиенту, чтобы функции работали по каждому клиенту отдельно
ORDER BY total_balance DESC;



























