-- Active: 1763627793850@@127.0.0.1@5432@assignmentDB
DELETE FROM JOB
WHERE member_user_id IN (
    SELECT member_user_id
    FROM MEMBER
    JOIN "USER" ON MEMBER.member_user_id = "USER".user_id
    WHERE given_name = 'Amina'
      AND surname = 'Aminova'
);

DELETE FROM MEMBER
WHERE member_user_id IN (
    SELECT member_user_id
    FROM address
    WHERE street = 'Kabanbay Batyr street'
);
