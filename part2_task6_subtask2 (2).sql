SELECT u.given_name, u.surname, SUM(a.work_hours) AS total_work_hours
FROM "USER" AS u, APPOINTMENT AS a
WHERE a.status = 'Accepted' AND a.caregiver_user_id = u.user_id
GROUP BY u.user_id, u.given_name, u.surname
ORDER BY u.given_name, u.surname;