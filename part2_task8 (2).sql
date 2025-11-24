SELECT given_name, surname, job_id, date_applied
FROM "USER", JOB_APPLICATION
WHERE user_id = caregiver_user_id
ORDER BY given_name, surname, job_id, date_applied;