SELECT u.username, ur.role, COUNT(ua.activity_type_id) as activity_count 
FROM users u
INNER JOIN user_roles ur
	on u.id = ur.user_id
INNER JOIN user_activity ua
	on u.id = ua.user_id
	and ua.activity_date >= '2024-10-01'
	and ua.activity_date < '2024-11-01'
GROUP BY u.username, ur.role
ORDER BY activity_count DESC;