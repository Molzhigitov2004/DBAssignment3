-- Active: 1763627793850@@127.0.0.1@5432@assignmentDB
UPDATE "USER"
SET phone_number = '+77773414141'
WHERE given_name = 'Arman' AND surname = 'Armanov';

UPDATE caregiver
SET hourly_rate = hourly_rate * 1.10
WHERE hourly_rate >= 10;
UPDATE caregiver
SET hourly_rate = hourly_rate + 0.3
WHERE hourly_rate < 10;

