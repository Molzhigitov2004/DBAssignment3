--
-- PostgreSQL database dump
--

\restrict ybp4C2NxFRqTIc2mjoyyE8GwyyQLFcSDLBxiqhCezkAoyz4aiZaIeYWzi3VWD7E

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: USER; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."USER" (
    user_id integer NOT NULL,
    email character varying(100) NOT NULL,
    given_name character varying(50),
    surname character varying(50),
    city character varying(50),
    phone_number character varying(20),
    profile_description text,
    password character varying(100)
);


ALTER TABLE public."USER" OWNER TO postgres;

--
-- Name: USER_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."USER_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."USER_user_id_seq" OWNER TO postgres;

--
-- Name: USER_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."USER_user_id_seq" OWNED BY public."USER".user_id;


--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    member_user_id bigint NOT NULL,
    house_number character varying(20),
    street character varying(100),
    town character varying(50)
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    appointment_id integer NOT NULL,
    caregiver_user_id bigint,
    member_user_id bigint,
    appointment_date date,
    appointment_time time without time zone,
    work_hours integer,
    status character varying(20)
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointment_appointment_id_seq OWNER TO postgres;

--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_appointment_id_seq OWNED BY public.appointment.appointment_id;


--
-- Name: caregiver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caregiver (
    caregiver_user_id bigint NOT NULL,
    photo bytea,
    gender character varying(10),
    caregiving_type character varying(50),
    hourly_rate numeric(10,2)
);


ALTER TABLE public.caregiver OWNER TO postgres;

--
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job (
    job_id integer NOT NULL,
    member_user_id bigint,
    required_caregiving_type character varying(50),
    other_requirements text,
    date_posted date
);


ALTER TABLE public.job OWNER TO postgres;

--
-- Name: job_application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_application (
    caregiver_user_id bigint NOT NULL,
    job_id bigint NOT NULL,
    date_applied date
);


ALTER TABLE public.job_application OWNER TO postgres;

--
-- Name: job_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_job_id_seq OWNER TO postgres;

--
-- Name: job_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_job_id_seq OWNED BY public.job.job_id;


--
-- Name: member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member (
    member_user_id bigint NOT NULL,
    house_rules text,
    dependent_description text
);


ALTER TABLE public.member OWNER TO postgres;

--
-- Name: USER user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER" ALTER COLUMN user_id SET DEFAULT nextval('public."USER_user_id_seq"'::regclass);


--
-- Name: appointment appointment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointment_appointment_id_seq'::regclass);


--
-- Name: job job_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job ALTER COLUMN job_id SET DEFAULT nextval('public.job_job_id_seq'::regclass);


--
-- Data for Name: USER; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."USER" (user_id, email, given_name, surname, city, phone_number, profile_description, password) FROM stdin;
3	charlie@example.com	Charlie	Brown	Astana	+77013333333	Loves pets and kids.	pass3
4	diana@example.com	Diana	Prince	Shymkent	+77014444444	Energetic and fun.	pass4
5	evan@example.com	Evan	Wright	Astana	+77015555555	Special needs experience.	pass5
6	fiona@example.com	Fiona	Green	Almaty	+77016666666	Patient and kind.	pass6
7	george@example.com	George	Hall	Astana	+77017777777	Strong and capable.	pass7
8	hannah@example.com	Hannah	Lee	Karaganda	+77018888888	Music tutor and sitter.	pass8
9	ian@example.com	Ian	Clark	Astana	+77019999999	Sports coach.	pass9
10	julia@example.com	Julia	Roberts	Almaty	+77010000000	Drama teacher.	pass10
11	arman@example.com	Arman	Armanov	Astana	+77771111111	Looking for help.	pass11
12	amina@example.com	Amina	Aminova	Almaty	+77772222222	Busy mother.	pass12
13	kyle@example.com	Kyle	Reese	Astana	+77773333333	Need elderly care.	pass13
14	lara@example.com	Lara	Croft	Shymkent	+77774444444	Travels often.	pass14
15	mike@example.com	Mike	Tyson	Astana	+77775555555	Strict schedule.	pass15
16	nina@example.com	Nina	Simone	Almaty	+77776666666	Musician family.	pass16
17	oscar@example.com	Oscar	Wilde	Karaganda	+77777777777	Quiet home.	pass17
18	paul@example.com	Paul	Rudd	Astana	+77778888888	Funny family.	pass18
19	quinn@example.com	Quinn	Fabray	Astana	+77779999999	Newborn baby.	pass19
20	rachel@example.com	Rachel	Green	Almaty	+77770000000	Fashion career.	pass20
21	user@example.com	string	string	string	string	string	string
22	useruser@example.com	string	string	string	string	string	string
\.


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (member_user_id, house_number, street, town) FROM stdin;
11	101	Mangilik El	Astana
12	55	Kabanbay Batyr street	Almaty
13	12	Dostyk	Astana
14	7	Tauke Khan	Shymkent
15	88	Kabanbay Batyr street	Astana
16	45	Abay	Almaty
17	99	Bukharnogo	Karaganda
18	22	Turan	Astana
19	33	Syganak	Astana
20	11	Gogol	Almaty
22	string	string	string
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment (appointment_id, caregiver_user_id, member_user_id, appointment_date, appointment_time, work_hours, status) FROM stdin;
3	5	13	2025-11-03	10:00:00	5	Declined
4	4	14	2025-11-04	18:00:00	2	Accepted
5	6	15	2025-11-05	08:00:00	8	Pending
6	8	16	2025-11-06	12:00:00	4	Accepted
8	3	18	2025-11-08	15:00:00	3	Accepted
9	7	19	2025-11-09	10:00:00	6	Declined
10	10	20	2025-11-10	11:00:00	5	Accepted
\.


--
-- Data for Name: caregiver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caregiver (caregiver_user_id, photo, gender, caregiving_type, hourly_rate) FROM stdin;
3	\N	Male	playmate for children	8.00
4	\N	Female	babysitter	12.50
5	\N	Male	caregiver for elderly	20.00
6	\N	Female	babysitter	9.00
7	\N	Male	playmate for children	11.00
8	\N	Female	babysitter	14.00
9	\N	Male	playmate for children	10.00
10	\N	Female	caregiver for elderly	18.00
22	\N	string	string	0.00
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job (job_id, member_user_id, required_caregiving_type, other_requirements, date_posted) FROM stdin;
1	12	caregiver for elderly	Must be patient.	2025-10-01
2	12	babysitter	Must be soft-spoken.	2025-10-05
3	11	babysitter	Active person needed.	2025-10-02
4	13	caregiver for elderly	Medical training preferred.	2025-10-03
5	14	playmate for children	Knows card games.	2025-10-04
6	15	babysitter	Must be soft-spoken and kind.	2025-10-06
7	16	playmate for children	Knows piano.	2025-10-07
8	17	babysitter	Night shifts.	2025-10-08
9	18	playmate for children	Good with dogs.	2025-10-09
10	19	caregiver for elderly	Lives nearby.	2025-10-10
\.


--
-- Data for Name: job_application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_application (caregiver_user_id, job_id, date_applied) FROM stdin;
4	2	2025-10-07
5	4	2025-10-05
3	5	2025-10-06
6	6	2025-10-08
7	7	2025-10-09
8	8	2025-10-10
9	9	2025-10-11
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member (member_user_id, house_rules, dependent_description) FROM stdin;
11	No smoking.	Two energetic boys.
12	Clean up after yourself.	Elderly father.
13	No pets. No smoking.	Grandmother with dementia.
14	Be on time.	Twin girls.
15	No pets.	Son with autism.
16	Love music.	Daughter learning piano.
17	Quiet after 9pm.	Newborn.
18	Have fun.	Three dogs and a kid.
19	Shoes off.	Baby girl.
20	No visitors.	Elderly aunt.
22	string	string
\.


--
-- Name: USER_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."USER_user_id_seq"', 23, true);


--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_appointment_id_seq', 1, true);


--
-- Name: job_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_job_id_seq', 11, true);


--
-- Name: USER USER_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_email_key" UNIQUE (email);


--
-- Name: USER USER_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_pkey" PRIMARY KEY (user_id);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (member_user_id);


--
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (appointment_id);


--
-- Name: caregiver caregiver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver
    ADD CONSTRAINT caregiver_pkey PRIMARY KEY (caregiver_user_id);


--
-- Name: job_application job_application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_pkey PRIMARY KEY (caregiver_user_id, job_id);


--
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (member_user_id);


--
-- Name: address address_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- Name: appointment appointment_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregiver(caregiver_user_id) ON DELETE CASCADE;


--
-- Name: appointment appointment_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- Name: caregiver caregiver_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver
    ADD CONSTRAINT caregiver_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public."USER"(user_id) ON DELETE CASCADE;


--
-- Name: job_application job_application_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregiver(caregiver_user_id) ON DELETE CASCADE;


--
-- Name: job_application job_application_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.job(job_id) ON DELETE CASCADE;


--
-- Name: job job_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- Name: member member_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public."USER"(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ybp4C2NxFRqTIc2mjoyyE8GwyyQLFcSDLBxiqhCezkAoyz4aiZaIeYWzi3VWD7E

