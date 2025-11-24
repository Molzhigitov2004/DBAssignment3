SELECT j.job_id, u.given_name AS member_name, u.surname AS member_surname,
    COUNT(ja.caregiver_user_id) AS applicants_number
FROM JOB AS j, JOB_APPLICATION AS ja, "USER" AS u
WHERE j.job_id = ja.job_id AND j.member_user_id = u.user_id
GROUP BY j.job_id, member_name, member_surname
ORDER BY j.job_id;