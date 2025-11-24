SELECT u.given_name, u.surname, AVG(a.work_hours * c.hourly_rate) AS average_pay
FROM APPOINTMENT AS a, CAREGIVER AS c, "USER" AS u
WHERE u.user_id = c.caregiver_user_id AND a.caregiver_user_id = c.caregiver_user_id AND a.status = 'Accepted'
GROUP BY u.user_id, u.given_name, u.surname
ORDER BY u.given_name, u.surname;