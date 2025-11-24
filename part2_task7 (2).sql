SELECT u2.user_id AS caregiver_id, u2.given_name AS caregiver_name, u2.surname AS caregiver_surname,
       u1.user_id AS member_id, u1.given_name AS member_name, u1.surname AS member_surname,
       c.hourly_rate, a.work_hours, (c.hourly_rate * a.work_hours) AS total_cost_to_pay
FROM "USER" AS u1, "USER" AS u2, APPOINTMENT AS a, CAREGIVER AS c
WHERE a.member_user_id = u1.user_id AND a.caregiver_user_id = u2.user_id
    AND a.caregiver_user_id = c.caregiver_user_id AND a.status = 'Accepted'
ORDER BY caregiver_name, caregiver_surname, member_name, member_surname;