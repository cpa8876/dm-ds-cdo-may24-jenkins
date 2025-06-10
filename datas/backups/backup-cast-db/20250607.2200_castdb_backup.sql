--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

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
-- Name: casts; Type: TABLE; Schema: public; Owner: fastapi_user
--

CREATE TABLE public.casts (
    id integer NOT NULL,
    name character varying(50),
    nationality character varying(20)
);


ALTER TABLE public.casts OWNER TO fastapi_user;

--
-- Name: casts_id_seq; Type: SEQUENCE; Schema: public; Owner: fastapi_user
--

CREATE SEQUENCE public.casts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.casts_id_seq OWNER TO fastapi_user;

--
-- Name: casts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fastapi_user
--

ALTER SEQUENCE public.casts_id_seq OWNED BY public.casts.id;


--
-- Name: casts id; Type: DEFAULT; Schema: public; Owner: fastapi_user
--

ALTER TABLE ONLY public.casts ALTER COLUMN id SET DEFAULT nextval('public.casts_id_seq'::regclass);


--
-- Data for Name: casts; Type: TABLE DATA; Schema: public; Owner: fastapi_user
--

COPY public.casts (id, name, nationality) FROM stdin;
2	Adam Driver	USA
3	Daisy Ridley	USA
4	Carrie FISHER	USA
5	Mark HAMILL	USA
6	Mark HAMILL	USA
7	Carrie FISHER	USA
8	Mark HAMILL	USA
9	Mark HAMILL	USA
10	Harisson FORD	USA
\.


--
-- Name: casts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fastapi_user
--

SELECT pg_catalog.setval('public.casts_id_seq', 10, true);


--
-- Name: casts casts_pkey; Type: CONSTRAINT; Schema: public; Owner: fastapi_user
--

ALTER TABLE ONLY public.casts
    ADD CONSTRAINT casts_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

