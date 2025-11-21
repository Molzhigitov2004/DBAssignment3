-- Active: 1763627793850@@127.0.0.1@5432@assignmentDB
CREATE TABLE "USER" (
	user_id SERIAL PRIMARY KEY, -- Changed to SERIAL for auto-increment
	email VARCHAR(100) UNIQUE NOT NULL,
	given_name VARCHAR(50),
	surname VARCHAR(50),
	city VARCHAR(50),
	phone_number VARCHAR(20),
	profile_description TEXT,
	password VARCHAR(100)
);

CREATE TABLE CAREGIVER (
	caregiver_user_id BIGINT PRIMARY KEY,
	photo BYTEA,
	gender VARCHAR(10),
	caregiving_type VARCHAR(50),
	hourly_rate DECIMAL(10, 2),
	FOREIGN KEY (caregiver_user_id) REFERENCES "USER"(user_id) ON DELETE CASCADE
);

CREATE TABLE MEMBER (
	member_user_id BIGINT PRIMARY KEY,
	house_rules TEXT,
	dependent_description TEXT,
	FOREIGN KEY (member_user_id) REFERENCES "USER"(user_id) ON DELETE CASCADE
);

CREATE TABLE ADDRESS (
	member_user_id BIGINT PRIMARY KEY,
	house_number VARCHAR(20),
	street VARCHAR(100),
	town VARCHAR(50),
	FOREIGN KEY (member_user_id) REFERENCES MEMBER(member_user_id) ON DELETE CASCADE
);

CREATE TABLE JOB (
	job_id SERIAL PRIMARY KEY, -- Changed to SERIAL
	member_user_id BIGINT,
	required_caregiving_type VARCHAR(50),
	other_requirements TEXT,
	date_posted DATE,
	FOREIGN KEY(member_user_id) REFERENCES MEMBER(member_user_id) ON DELETE CASCADE
);

CREATE TABLE JOB_APPLICATION (
	caregiver_user_id BIGINT,
	job_id BIGINT,
	date_applied DATE,
	PRIMARY KEY(caregiver_user_id, job_id),
	FOREIGN KEY (caregiver_user_id) REFERENCES CAREGIVER(caregiver_user_id) ON DELETE CASCADE,
	FOREIGN KEY(job_id) REFERENCES JOB(job_id) ON DELETE CASCADE
);

CREATE TABLE APPOINTMENT (
	appointment_id SERIAL PRIMARY KEY, -- Changed to SERIAL
	caregiver_user_id BIGINT,
	member_user_id BIGINT,
	appointment_date DATE,
	appointment_time TIME, -- Changed to TIME
	work_hours INT,
	status VARCHAR(20),
	FOREIGN KEY (caregiver_user_id) REFERENCES CAREGIVER(caregiver_user_id) ON DELETE CASCADE,
	FOREIGN KEY (member_user_id) REFERENCES MEMBER(member_user_id) ON DELETE CASCADE
);