-- Active: 1763627793850@@127.0.0.1@5432@assignmentDB
SELECT 
    cgiver.given_name AS caregiver_name, 
    cgiver.surname AS caregiver_surname,
    muser.given_name AS member_name, 
    muser.surname AS member_surname
FROM APPOINTMENT A
JOIN "USER" cgiver ON A.caregiver_user_id = cgiver.user_id
JOIN "USER" muser ON A.member_user_id = muser.user_id
WHERE A.status = 'Accepted'; 


SELECT job_id 
FROM JOB 
WHERE other_requirements LIKE '%soft-spoken%';

SELECT A.work_hours 
FROM APPOINTMENT A
JOIN CAREGIVER C ON A.caregiver_user_id = C.caregiver_user_id
WHERE C.caregiving_type = 'babysitter';


SELECT U.given_name, U.surname
FROM MEMBER M
JOIN "USER" U ON M.member_user_id = U.user_id
JOIN JOB J ON M.member_user_id = J.member_user_id
WHERE U.city = 'Astana'
  AND M.house_rules LIKE '%No pets%'
  AND J.required_caregiving_type = 'caregiver for elderly';
