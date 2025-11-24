SELECT u.given_name, u.surname, SUM(c.hourly_rate * a.work_hours) AS total_pay
FROM "USER" AS u, CAREGIVER AS c, APPOINTMENT AS a
WHERE u.user_id = c.caregiver_user_id AND a.caregiver_user_id = c.caregiver_user_id AND a.status = 'Accepted'
GROUP BY u.user_id, u.given_name, u.surname
HAVING SUM(c.hourly_rate * a.work_hours) > (
    SELECT AVG(avga.work_hours * avgc.hourly_rate)
    FROM APPOINTMENT AS avga, CAREGIVER AS avgc
    WHERE avga.caregiver_user_id = avgc.caregiver_user_id AND avga.status = 'Accepted'
)
ORDER BY u.given_name, u.surname;