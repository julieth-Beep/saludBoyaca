--
-- PostgreSQL database dump
--

\restrict X23Pjn2z0cSTVS4b6jG7wEpMeQbomsCV6AHWaxk4aMNn75SsMpv7BGToTsEir2U

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

-- Started on 2026-05-05 17:22:22

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
-- TOC entry 226 (class 1259 OID 24625)
-- Name: citas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citas (
    id integer NOT NULL,
    id_paciente integer NOT NULL,
    id_medico integer NOT NULL,
    id_especialidad integer NOT NULL,
    fecha_cita date NOT NULL,
    hora_cita time without time zone NOT NULL,
    motivo character varying(300),
    estado character varying(20) DEFAULT 'PROGRAMADA'::character varying,
    observaciones character varying(500),
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_registrado_por integer,
    CONSTRAINT citas_estado_check CHECK (((estado)::text = ANY ((ARRAY['PROGRAMADA'::character varying, 'CONFIRMADA'::character varying, 'ATENDIDA'::character varying, 'CANCELADA'::character varying])::text[])))
);


ALTER TABLE public.citas OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24624)
-- Name: citas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.citas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.citas_id_seq OWNER TO postgres;

--
-- TOC entry 4880 (class 0 OID 0)
-- Dependencies: 225
-- Name: citas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.citas_id_seq OWNED BY public.citas.id;


--
-- TOC entry 222 (class 1259 OID 24605)
-- Name: especialidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidades (
    id integer NOT NULL,
    nombre character varying(80) NOT NULL,
    descripcion character varying(200)
);


ALTER TABLE public.especialidades OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24604)
-- Name: especialidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.especialidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.especialidades_id_seq OWNER TO postgres;

--
-- TOC entry 4881 (class 0 OID 0)
-- Dependencies: 221
-- Name: especialidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.especialidades_id_seq OWNED BY public.especialidades.id;


--
-- TOC entry 224 (class 1259 OID 24612)
-- Name: horarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horarios (
    id integer NOT NULL,
    id_medico integer NOT NULL,
    dia_semana smallint NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fin time without time zone NOT NULL,
    max_citas integer DEFAULT 10
);


ALTER TABLE public.horarios OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24611)
-- Name: horarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.horarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.horarios_id_seq OWNER TO postgres;

--
-- TOC entry 4882 (class 0 OID 0)
-- Dependencies: 223
-- Name: horarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.horarios_id_seq OWNED BY public.horarios.id;


--
-- TOC entry 230 (class 1259 OID 24666)
-- Name: log_accesos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_accesos (
    id integer NOT NULL,
    id_usuario integer,
    username character varying(50),
    accion character varying(50) NOT NULL,
    ip character varying(45),
    resultado character varying(10) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT log_accesos_resultado_check CHECK (((resultado)::text = ANY ((ARRAY['EXITO'::character varying, 'FALLO'::character varying])::text[])))
);


ALTER TABLE public.log_accesos OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24665)
-- Name: log_accesos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_accesos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.log_accesos_id_seq OWNER TO postgres;

--
-- TOC entry 4883 (class 0 OID 0)
-- Dependencies: 229
-- Name: log_accesos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_accesos_id_seq OWNED BY public.log_accesos.id;


--
-- TOC entry 228 (class 1259 OID 24652)
-- Name: otp_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_tokens (
    id integer NOT NULL,
    id_usuario integer NOT NULL,
    codigo character varying(6) NOT NULL,
    fecha_gen timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expira_en timestamp without time zone NOT NULL,
    usado smallint DEFAULT 0
);


ALTER TABLE public.otp_tokens OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24651)
-- Name: otp_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.otp_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 4884 (class 0 OID 0)
-- Dependencies: 227
-- Name: otp_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_tokens_id_seq OWNED BY public.otp_tokens.id;


--
-- TOC entry 220 (class 1259 OID 24596)
-- Name: pacientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pacientes (
    id integer NOT NULL,
    nombres character varying(80) NOT NULL,
    apellidos character varying(80) NOT NULL,
    documento character varying(20) NOT NULL,
    fecha_nacimiento date NOT NULL,
    telefono character varying(20),
    email character varying(100),
    eps character varying(80) NOT NULL,
    vereda_barrio character varying(80)
);


ALTER TABLE public.pacientes OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24595)
-- Name: pacientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pacientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pacientes_id_seq OWNER TO postgres;

--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 219
-- Name: pacientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pacientes_id_seq OWNED BY public.pacientes.id;


--
-- TOC entry 218 (class 1259 OID 24578)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombres character varying(80) NOT NULL,
    apellidos character varying(80) NOT NULL,
    documento character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    rol character varying(20) NOT NULL,
    especialidad character varying(80),
    lang_preferido character varying(5) DEFAULT 'es'::character varying,
    activo smallint DEFAULT 1,
    CONSTRAINT usuarios_rol_check CHECK (((rol)::text = ANY ((ARRAY['MEDICO'::character varying, 'RECEPCIONISTA'::character varying, 'ENFERMERO'::character varying])::text[])))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24577)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4678 (class 2604 OID 24628)
-- Name: citas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas ALTER COLUMN id SET DEFAULT nextval('public.citas_id_seq'::regclass);


--
-- TOC entry 4675 (class 2604 OID 24608)
-- Name: especialidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidades ALTER COLUMN id SET DEFAULT nextval('public.especialidades_id_seq'::regclass);


--
-- TOC entry 4676 (class 2604 OID 24615)
-- Name: horarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios ALTER COLUMN id SET DEFAULT nextval('public.horarios_id_seq'::regclass);


--
-- TOC entry 4684 (class 2604 OID 24669)
-- Name: log_accesos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_accesos ALTER COLUMN id SET DEFAULT nextval('public.log_accesos_id_seq'::regclass);


--
-- TOC entry 4681 (class 2604 OID 24655)
-- Name: otp_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_tokens ALTER COLUMN id SET DEFAULT nextval('public.otp_tokens_id_seq'::regclass);


--
-- TOC entry 4674 (class 2604 OID 24599)
-- Name: pacientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes ALTER COLUMN id SET DEFAULT nextval('public.pacientes_id_seq'::regclass);


--
-- TOC entry 4671 (class 2604 OID 24581)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 4870 (class 0 OID 24625)
-- Dependencies: 226
-- Data for Name: citas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citas (id, id_paciente, id_medico, id_especialidad, fecha_cita, hora_cita, motivo, estado, observaciones, fecha_registro, id_registrado_por) FROM stdin;
1	1	1	1	2026-05-04	08:00:00	Control tensión arterial	PROGRAMADA	\N	2026-05-03 12:18:19.406554	3
2	2	1	1	2026-05-05	09:00:00	Dolor de cabeza frecuente	PROGRAMADA	\N	2026-05-03 12:18:19.406554	3
4	4	1	4	2026-05-08	11:00:00	Consulta ginecológica de control	PROGRAMADA	\N	2026-05-03 12:18:19.406554	3
5	5	1	2	2026-05-10	14:00:00	Dolor molar derecho inferior	PROGRAMADA	\N	2026-05-03 12:18:19.406554	3
6	1	1	5	2026-05-04	15:00:00	Revisión de agudeza visual	CONFIRMADA	\N	2026-05-03 12:18:19.406554	3
7	3	1	1	2026-05-07	08:30:00	Fiebre persistente 3 días	CONFIRMADA	\N	2026-05-03 12:18:19.406554	3
8	2	1	1	2026-04-30	08:00:00	Gripa y tos seca	ATENDIDA	\N	2026-05-03 12:18:19.406554	3
9	4	1	4	2026-04-28	09:30:00	Citología de control	ATENDIDA	\N	2026-05-03 12:18:19.406554	3
10	5	1	2	2026-04-26	10:00:00	Extracción diente de leche	ATENDIDA	\N	2026-05-03 12:18:19.406554	3
11	1	1	1	2026-04-23	11:00:00	Dolor abdominal leve	ATENDIDA	\N	2026-05-03 12:18:19.406554	3
12	3	1	3	2026-05-01	14:00:00	Vacunación BCG	CANCELADA	\N	2026-05-03 12:18:19.406554	3
13	2	1	5	2026-05-02	15:30:00	Examen de vista	CANCELADA	\N	2026-05-03 12:18:19.406554	3
3	3	1	3	2026-05-06	10:00:00	Revisión pediátrica rutina	CANCELADA	\N	2026-05-03 12:18:19.406554	3
15	2	1	1	2026-05-07	16:00:00	Dolor de cabeza seguido	PROGRAMADA	\N	2026-05-05 16:59:40.479573	1
\.


--
-- TOC entry 4866 (class 0 OID 24605)
-- Dependencies: 222
-- Data for Name: especialidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialidades (id, nombre, descripcion) FROM stdin;
1	Medicina General	Atención médica general
2	Odontología	Salud oral y dental
3	Pediatría	Atención a menores de edad
4	Ginecología	Salud femenina
5	Optometría	Salud visual
\.


--
-- TOC entry 4868 (class 0 OID 24612)
-- Dependencies: 224
-- Data for Name: horarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.horarios (id, id_medico, dia_semana, hora_inicio, hora_fin, max_citas) FROM stdin;
1	1	1	07:00:00	12:00:00	10
2	1	1	14:00:00	17:00:00	8
3	1	2	07:00:00	12:00:00	10
4	1	2	14:00:00	17:00:00	8
5	1	3	07:00:00	12:00:00	10
6	1	3	14:00:00	17:00:00	8
7	1	4	07:00:00	12:00:00	10
8	1	4	14:00:00	17:00:00	8
9	1	5	07:00:00	12:00:00	8
10	1	5	14:00:00	16:00:00	5
11	2	1	07:00:00	18:00:00	0
12	2	2	07:00:00	18:00:00	0
13	2	3	07:00:00	18:00:00	0
14	2	4	07:00:00	18:00:00	0
15	2	5	07:00:00	18:00:00	0
16	3	1	06:00:00	18:00:00	0
17	3	2	06:00:00	18:00:00	0
18	3	3	06:00:00	18:00:00	0
19	3	4	06:00:00	18:00:00	0
20	3	5	06:00:00	18:00:00	0
21	3	6	07:00:00	14:00:00	0
\.


--
-- TOC entry 4874 (class 0 OID 24666)
-- Dependencies: 230
-- Data for Name: log_accesos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_accesos (id, id_usuario, username, accion, ip, resultado, fecha) FROM stdin;
\.


--
-- TOC entry 4872 (class 0 OID 24652)
-- Dependencies: 228
-- Data for Name: otp_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_tokens (id, id_usuario, codigo, fecha_gen, expira_en, usado) FROM stdin;
1	1	053474	2026-05-01 13:14:12.361802	2026-05-01 13:19:11.839006	0
2	1	601661	2026-05-01 13:16:15.34266	2026-05-01 13:21:15.186627	0
3	1	836435	2026-05-01 13:17:58.451747	2026-05-01 13:22:58.363711	1
4	1	393883	2026-05-01 14:17:11.385806	2026-05-01 14:22:11.270063	1
5	1	338714	2026-05-01 15:42:54.031356	2026-05-01 15:47:53.852057	1
6	1	923430	2026-05-01 16:31:01.396581	2026-05-01 16:36:01.311034	1
7	1	965420	2026-05-01 16:31:44.607368	2026-05-01 16:36:44.488548	1
8	1	911974	2026-05-01 16:38:40.398688	2026-05-01 16:43:40.202804	1
9	1	366836	2026-05-01 16:42:30.039599	2026-05-01 16:47:29.865586	1
10	1	299690	2026-05-01 16:51:39.434736	2026-05-01 16:56:39.301475	1
11	1	488632	2026-05-01 17:28:51.247852	2026-05-01 17:33:50.90136	1
12	1	958654	2026-05-01 17:50:47.275887	2026-05-01 17:55:47.123113	1
13	1	398307	2026-05-01 21:12:27.234705	2026-05-01 21:17:27.038627	1
14	1	280009	2026-05-03 11:47:34.665222	2026-05-03 11:52:32.450405	0
15	1	806627	2026-05-03 11:53:04.603938	2026-05-03 11:58:04.151895	1
16	1	488846	2026-05-03 12:13:37.746712	2026-05-03 12:18:37.290745	1
17	3	438986	2026-05-03 13:12:16.501652	2026-05-03 13:17:16.358747	1
18	1	276166	2026-05-03 13:28:31.154695	2026-05-03 13:33:30.982933	0
19	1	389772	2026-05-03 13:29:14.51824	2026-05-03 13:34:14.132324	1
20	1	423455	2026-05-03 16:18:45.57061	2026-05-03 16:23:45.062663	1
21	3	734827	2026-05-03 17:03:40.490105	2026-05-03 17:08:40.378487	1
22	1	560607	2026-05-03 18:12:37.981516	2026-05-03 18:17:37.306857	1
23	2	225757	2026-05-03 18:29:58.122564	2026-05-03 18:34:58.005504	0
24	2	855646	2026-05-03 18:42:31.37633	2026-05-03 18:47:31.282748	1
25	1	201138	2026-05-03 18:51:53.69785	2026-05-03 18:56:53.47756	1
26	3	853149	2026-05-03 19:05:51.754262	2026-05-03 19:10:51.671492	1
27	2	584764	2026-05-03 19:06:58.158839	2026-05-03 19:11:58.077881	1
28	1	896298	2026-05-03 20:28:15.031074	2026-05-03 20:33:14.860277	1
29	1	241679	2026-05-03 23:02:04.548267	2026-05-03 23:07:03.68345	1
30	1	264300	2026-05-03 23:17:23.297761	2026-05-03 23:22:23.049259	1
31	1	600009	2026-05-05 16:46:24.430026	2026-05-05 16:51:24.226284	1
32	1	385232	2026-05-05 16:57:51.075298	2026-05-05 17:02:50.889609	1
\.


--
-- TOC entry 4864 (class 0 OID 24596)
-- Dependencies: 220
-- Data for Name: pacientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pacientes (id, nombres, apellidos, documento, fecha_nacimiento, telefono, email, eps, vereda_barrio) FROM stdin;
1	Luis Antonio	Mora Fonseca	1052111001	1990-03-15	3101234567	\N	Sanitas	Barrio Centro
2	Rosa Elena	Cárdenas Pinto	1052111002	1985-07-22	3209876543	\N	Compensar	Vereda El Salitre
3	Andrés Felipe	Vargas Ospina	1052111003	2000-11-10	3157654321	\N	Nueva EPS	Barrio Bolívar
4	Carmen Inés	Téllez Rojas	1052111004	1978-05-30	3184561234	\N	Coosalud	Vereda Palermo
5	Diego Alejandro	Pineda Castro	1052111005	1995-09-18	3012345678	\N	Famisanar	Barrio La Esperanza
6	Julieth	Barrera	1053585191	2007-09-06	3125084171	julii@gmail.com	Salud Total	Chameza Mayor
\.


--
-- TOC entry 4862 (class 0 OID 24578)
-- Dependencies: 218
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombres, apellidos, documento, email, username, password, rol, especialidad, lang_preferido, activo) FROM stdin;
1	Carlos Ernesto	Pedraza Rondón	1052345678	pjulieth836@gmail.com	cpedraza	admin123	MEDICO	Medicina General	es	1
3	Jorge Hernando	Báez Morales	1052345680	juliethpe836@gmail.com	jbaez	recep123	RECEPCIONISTA	\N	es	1
2	María Eugenia	Suárez Cely	1052345679	marlybarrera62@gmail.com	msuarez	enfermero1	ENFERMERO	\N	es	1
\.


--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 225
-- Name: citas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citas_id_seq', 15, true);


--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 221
-- Name: especialidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especialidades_id_seq', 5, true);


--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 223
-- Name: horarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.horarios_id_seq', 21, true);


--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 229
-- Name: log_accesos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_accesos_id_seq', 1, false);


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 227
-- Name: otp_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_tokens_id_seq', 32, true);


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 219
-- Name: pacientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pacientes_id_seq', 6, true);


--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 3, true);


--
-- TOC entry 4706 (class 2606 OID 24635)
-- Name: citas citas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_pkey PRIMARY KEY (id);


--
-- TOC entry 4702 (class 2606 OID 24610)
-- Name: especialidades especialidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidades
    ADD CONSTRAINT especialidades_pkey PRIMARY KEY (id);


--
-- TOC entry 4704 (class 2606 OID 24618)
-- Name: horarios horarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios
    ADD CONSTRAINT horarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4710 (class 2606 OID 24673)
-- Name: log_accesos log_accesos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_accesos
    ADD CONSTRAINT log_accesos_pkey PRIMARY KEY (id);


--
-- TOC entry 4708 (class 2606 OID 24659)
-- Name: otp_tokens otp_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_tokens
    ADD CONSTRAINT otp_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4698 (class 2606 OID 24603)
-- Name: pacientes pacientes_documento_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_documento_key UNIQUE (documento);


--
-- TOC entry 4700 (class 2606 OID 24601)
-- Name: pacientes pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4690 (class 2606 OID 24590)
-- Name: usuarios usuarios_documento_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_documento_key UNIQUE (documento);


--
-- TOC entry 4692 (class 2606 OID 24592)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 4694 (class 2606 OID 24588)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4696 (class 2606 OID 24594)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4712 (class 2606 OID 24646)
-- Name: citas citas_id_especialidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_id_especialidad_fkey FOREIGN KEY (id_especialidad) REFERENCES public.especialidades(id);


--
-- TOC entry 4713 (class 2606 OID 24641)
-- Name: citas citas_id_medico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES public.usuarios(id);


--
-- TOC entry 4714 (class 2606 OID 24636)
-- Name: citas citas_id_paciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES public.pacientes(id);


--
-- TOC entry 4711 (class 2606 OID 24619)
-- Name: horarios horarios_id_medico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios
    ADD CONSTRAINT horarios_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES public.usuarios(id);


--
-- TOC entry 4715 (class 2606 OID 24660)
-- Name: otp_tokens otp_tokens_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_tokens
    ADD CONSTRAINT otp_tokens_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


-- Completed on 2026-05-05 17:22:23

--
-- PostgreSQL database dump complete
--

\unrestrict X23Pjn2z0cSTVS4b6jG7wEpMeQbomsCV6AHWaxk4aMNn75SsMpv7BGToTsEir2U

