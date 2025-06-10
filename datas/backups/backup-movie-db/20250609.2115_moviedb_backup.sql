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
-- Name: movies; Type: TABLE; Schema: public; Owner: fastapi_user
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    name character varying(50),
    plot character varying(250),
    genres character varying[],
    casts_id integer[]
);


ALTER TABLE public.movies OWNER TO fastapi_user;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: fastapi_user
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movies_id_seq OWNER TO fastapi_user;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fastapi_user
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: fastapi_user
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: fastapi_user
--

COPY public.movies (id, name, plot, genres, casts_id) FROM stdin;
2	Star Wars: Episode VI - Return of the Jedi	The evil Galactic Empire is building a new Death Star space station to permanently destroy the Rebel Alliance, its main opposition.	{Action,Adventure,Fantasy}	{3,4,5}
3	Star Wars: Episode V - The Empire Strikes Back	Set three years after the events of Star Wars, the film recounts the battle between the malevolent Galactic Empire, 	{Action,Adventure,Fantasy}	{3,4,5}
\.


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fastapi_user
--

SELECT pg_catalog.setval('public.movies_id_seq', 1, false);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: fastapi_user
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

