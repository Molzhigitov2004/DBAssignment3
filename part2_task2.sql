-- Active: 1763627793850@@127.0.0.1@5432@assignmentDB
-- ==========================================
-- 1. INSERT USERS (20 Users: 10 Caregivers, 10 Members)
--Ids 1-10 will be Caregivers, 11-20 will be Members
-- ==========================================

INSERT INTO "USER" (user_id, email, given_name, surname, city, phone_number, profile_description, password) VALUES
-- Potential Caregivers
(1, 'alice@example.com', 'Alice', 'Smith', 'Astana', '+77011111111', 'Experienced with kids.', 'pass1'),
(2, 'bob@example.com', 'Bob', 'Jones', 'Almaty', '+77012222222', 'Certified nurse.', 'pass2'),
(3, 'charlie@example.com', 'Charlie', 'Brown', 'Astana', '+77013333333', 'Loves pets and kids.', 'pass3'),
(4, 'diana@example.com', 'Diana', 'Prince', 'Shymkent', '+77014444444', 'Energetic and fun.', 'pass4'),
(5, 'evan@example.com', 'Evan', 'Wright', 'Astana', '+77015555555', 'Special needs experience.', 'pass5'),
(6, 'fiona@example.com', 'Fiona', 'Green', 'Almaty', '+77016666666', 'Patient and kind.', 'pass6'),
(7, 'george@example.com', 'George', 'Hall', 'Astana', '+77017777777', 'Strong and capable.', 'pass7'),
(8, 'hannah@example.com', 'Hannah', 'Lee', 'Karaganda', '+77018888888', 'Music tutor and sitter.', 'pass8'),
(9, 'ian@example.com', 'Ian', 'Clark', 'Astana', '+77019999999', 'Sports coach.', 'pass9'),
(10, 'julia@example.com', 'Julia', 'Roberts', 'Almaty', '+77010000000', 'Drama teacher.', 'pass10'),
(11, 'arman@example.com', 'Arman', 'Armanov', 'Astana', '+77771111111', 'Looking for help.', 'pass11'),
(12, 'amina@example.com', 'Amina', 'Aminova', 'Almaty', '+77772222222', 'Busy mother.', 'pass12'),
(13, 'kyle@example.com', 'Kyle', 'Reese', 'Astana', '+77773333333', 'Need elderly care.', 'pass13'),
(14, 'lara@example.com', 'Lara', 'Croft', 'Shymkent', '+77774444444', 'Travels often.', 'pass14'),
(15, 'mike@example.com', 'Mike', 'Tyson', 'Astana', '+77775555555', 'Strict schedule.', 'pass15'),
(16, 'nina@example.com', 'Nina', 'Simone', 'Almaty', '+77776666666', 'Musician family.', 'pass16'),
(17, 'oscar@example.com', 'Oscar', 'Wilde', 'Karaganda', '+77777777777', 'Quiet home.', 'pass17'),
(18, 'paul@example.com', 'Paul', 'Rudd', 'Astana', '+77778888888', 'Funny family.', 'pass18'),
(19, 'quinn@example.com', 'Quinn', 'Fabray', 'Astana', '+77779999999', 'Newborn baby.', 'pass19'),
(20, 'rachel@example.com', 'Rachel', 'Green', 'Almaty', '+77770000000', 'Fashion career.', 'pass20');

-- ==========================================
-- 2. INSERT CAREGIVERS (10 Instances)
-- References Users 1-10
-- Needed for Update 3.2: Some rates < 10, some > 10
-- ==========================================

INSERT INTO CAREGIVER (caregiver_user_id, photo, gender, caregiving_type, hourly_rate) VALUES
(1, NULL, 'Female', 'babysitter', 9.50),  -- Rate < 10
(2, NULL, 'Male', 'caregiver for elderly', 15.00), -- Rate > 10
(3, NULL, 'Male', 'playmate for children', 8.00), -- Rate < 10
(4, NULL, 'Female', 'babysitter', 12.50),
(5, NULL, 'Male', 'caregiver for elderly', 20.00),
(6, NULL, 'Female', 'babysitter', 9.00),
(7, NULL, 'Male', 'playmate for children', 11.00),
(8, NULL, 'Female', 'babysitter', 14.00),
(9, NULL, 'Male', 'playmate for children', 10.00),
(10, NULL, 'Female', 'caregiver for elderly', 18.00);

-- ==========================================
-- 3. INSERT MEMBERS (10 Instances)
-- References Users 11-20
-- Needed for Query 5.4: "No pets." rule
-- ==========================================

INSERT INTO MEMBER (member_user_id, house_rules, dependent_description) VALUES
(11, 'No smoking.', 'Two energetic boys.'), -- Arman
(12, 'Clean up after yourself.', 'Elderly father.'), -- Amina
(13, 'No pets. No smoking.', 'Grandmother with dementia.'), -- Meets "No pets" criteria
(14, 'Be on time.', 'Twin girls.'),
(15, 'No pets.', 'Son with autism.'), -- Meets "No pets" criteria
(16, 'Love music.', 'Daughter learning piano.'),
(17, 'Quiet after 9pm.', 'Newborn.'),
(18, 'Have fun.', 'Three dogs and a kid.'),
(19, 'Shoes off.', 'Baby girl.'),
(20, 'No visitors.', 'Elderly aunt.');

-- ==========================================
-- 4. INSERT ADDRESSES (10 Instances)
-- References Users 11-20
-- Needed for Delete 4.2: "Kabanbay Batyr street"
-- ==========================================

INSERT INTO ADDRESS (member_user_id, house_number, street, town) VALUES
(11, '101', 'Mangilik El', 'Astana'),
(12, '55', 'Kabanbay Batyr street', 'Almaty'), -- Amina lives here (or someone else)
(13, '12', 'Dostyk', 'Astana'),
(14, '7', 'Tauke Khan', 'Shymkent'),
(15, '88', 'Kabanbay Batyr street', 'Astana'), -- Target for delete 4.2
(16, '45', 'Abay', 'Almaty'),
(17, '99', 'Bukharnogo', 'Karaganda'),
(18, '22', 'Turan', 'Astana'),
(19, '33', 'Syganak', 'Astana'),
(20, '11', 'Gogol', 'Almaty');

-- ==========================================
-- 5. INSERT JOBS (10 Instances)
-- References Members (11-20)
-- Needed for Delete 4.1: Jobs by Amina (ID 12)
-- Needed for Query 5.2: 'soft-spoken' in other_requirements
-- Needed for Query 5.3: 'babysitter' positions
-- ==========================================

INSERT INTO JOB (job_id, member_user_id, required_caregiving_type, other_requirements, date_posted) VALUES
(1, 12, 'caregiver for elderly', 'Must be patient.', '2025-10-01'), -- Amina's Job
(2, 12, 'babysitter', 'Must be soft-spoken.', '2025-10-05'), -- Amina's Job + 'soft-spoken'
(3, 11, 'babysitter', 'Active person needed.', '2025-10-02'),
(4, 13, 'caregiver for elderly', 'Medical training preferred.', '2025-10-03'),
(5, 14, 'playmate for children', 'Knows card games.', '2025-10-04'),
(6, 15, 'babysitter', 'Must be soft-spoken and kind.', '2025-10-06'), -- 'soft-spoken'
(7, 16, 'playmate for children', 'Knows piano.', '2025-10-07'),
(8, 17, 'babysitter', 'Night shifts.', '2025-10-08'),
(9, 18, 'playmate for children', 'Good with dogs.', '2025-10-09'),
(10, 19, 'caregiver for elderly', 'Lives nearby.', '2025-10-10');

-- ==========================================
-- 6. INSERT JOB APPLICATIONS (10 Instances)
-- Links Caregivers (1-10) to Jobs (1-10)
-- ==========================================

INSERT INTO JOB_APPLICATION (caregiver_user_id, job_id, date_applied) VALUES
(2, 1, '2025-10-02'),
(1, 2, '2025-10-06'),
(4, 2, '2025-10-07'),
(1, 3, '2025-10-03'),
(5, 4, '2025-10-05'),
(3, 5, '2025-10-06'),
(6, 6, '2025-10-08'),
(7, 7, '2025-10-09'),
(8, 8, '2025-10-10'),
(9, 9, '2025-10-11');

-- ==========================================
-- 7. INSERT APPOINTMENTS (10 Instances)
-- Links Caregivers (1-10) and Members (11-20)
-- Needed for Query 5.1, 6.2, 6.3, 7: Status 'Accepted'
-- ==========================================

INSERT INTO APPOINTMENT (appointment_id, caregiver_user_id, member_user_id, appointment_date, appointment_time, work_hours, status) VALUES
(1, 2, 12, '2025-11-01', '09:00:00', 4, 'Accepted'),
(2, 1, 11, '2025-11-02', '14:00:00', 3, 'Accepted'),
(3, 5, 13, '2025-11-03', '10:00:00', 5, 'Declined'),
(4, 4, 14, '2025-11-04', '18:00:00', 2, 'Accepted'),
(5, 6, 15, '2025-11-05', '08:00:00', 8, 'Pending'),
(6, 8, 16, '2025-11-06', '12:00:00', 4, 'Accepted'),
(7, 2, 17, '2025-11-07', '09:00:00', 2, 'Accepted'),
(8, 3, 18, '2025-11-08', '15:00:00', 3, 'Accepted'),
(9, 7, 19, '2025-11-09', '10:00:00', 6, 'Declined'),
(10, 10, 20, '2025-11-10', '11:00:00', 5, 'Accepted');