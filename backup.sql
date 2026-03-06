--
-- PostgreSQL database dump
--

\restrict p8eNNhiE2B3HmF6buxbPMDDgaAbfTbpHfc1E7BwhH86V2LYAl6v1l6A7Z0zYrOX

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg12+2)
-- Dumped by pg_dump version 18.3 (Debian 18.3-1.pgdg13+1)

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: shachiku_quest_db_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO shachiku_quest_db_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO shachiku_quest_db_user;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_attachments_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO shachiku_quest_db_user;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_blobs_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO shachiku_quest_db_user;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: app_settings; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.app_settings (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.app_settings OWNER TO shachiku_quest_db_user;

--
-- Name: app_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.app_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_settings_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: app_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.app_settings_id_seq OWNED BY public.app_settings.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO shachiku_quest_db_user;

--
-- Name: conversations; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.conversations (
    id bigint NOT NULL,
    help_request_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.conversations OWNER TO shachiku_quest_db_user;

--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversations_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- Name: help_magics; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.help_magics (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    available_time integer DEFAULT 0 NOT NULL,
    available_date date NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.help_magics OWNER TO shachiku_quest_db_user;

--
-- Name: help_magics_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.help_magics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.help_magics_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: help_magics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.help_magics_id_seq OWNED BY public.help_magics.id;


--
-- Name: help_requests; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.help_requests (
    id bigint NOT NULL,
    task_id bigint NOT NULL,
    helper_id bigint,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    required_time integer DEFAULT 0 NOT NULL,
    last_helper_id bigint,
    completed_notified_at timestamp(6) without time zone,
    completed_read_at timestamp(6) without time zone,
    request_message text,
    helper_message text,
    virtue_points integer DEFAULT 10 NOT NULL,
    matched_on date,
    matched_notified_at timestamp(6) without time zone
);


ALTER TABLE public.help_requests OWNER TO shachiku_quest_db_user;

--
-- Name: help_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.help_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.help_requests_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: help_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.help_requests_id_seq OWNED BY public.help_requests.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    sender_id bigint,
    body text NOT NULL,
    read_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    message_type integer DEFAULT 0 NOT NULL,
    event_type integer
);


ALTER TABLE public.messages OWNER TO shachiku_quest_db_user;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.notifications (
    id bigint CONSTRAINT help_request_messages_id_not_null NOT NULL,
    help_request_id bigint CONSTRAINT help_request_messages_help_request_id_not_null NOT NULL,
    sender_id bigint,
    recipient_id bigint CONSTRAINT help_request_messages_recipient_id_not_null NOT NULL,
    message_type integer CONSTRAINT help_request_messages_message_type_not_null NOT NULL,
    body text CONSTRAINT help_request_messages_body_not_null NOT NULL,
    read_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone CONSTRAINT help_request_messages_created_at_not_null NOT NULL,
    updated_at timestamp(6) without time zone CONSTRAINT help_request_messages_updated_at_not_null NOT NULL
);


ALTER TABLE public.notifications OWNER TO shachiku_quest_db_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: personality_tags; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.personality_tags (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.personality_tags OWNER TO shachiku_quest_db_user;

--
-- Name: personality_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.personality_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personality_tags_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: personality_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.personality_tags_id_seq OWNED BY public.personality_tags.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO shachiku_quest_db_user;

--
-- Name: statuses; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.statuses (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    status_type integer DEFAULT 0 NOT NULL,
    status_date date NOT NULL,
    memo text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.statuses OWNER TO shachiku_quest_db_user;

--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.statuses_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.tasks OWNER TO shachiku_quest_db_user;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: user_personality_tags; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.user_personality_tags (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    personality_tag_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.user_personality_tags OWNER TO shachiku_quest_db_user;

--
-- Name: user_personality_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.user_personality_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_personality_tags_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: user_personality_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.user_personality_tags_id_seq OWNED BY public.user_personality_tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    department character varying,
    email character varying NOT NULL,
    crypted_password character varying,
    salt character varying,
    level integer DEFAULT 1 NOT NULL,
    total_virtue_points integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    unconfirmed_email character varying,
    email_change_token character varying,
    email_change_token_expires_at timestamp(6) without time zone,
    role integer DEFAULT 0 NOT NULL,
    nickname character varying,
    hobbies character varying,
    introduction text,
    total_virtue_points_notified_at timestamp(6) without time zone,
    total_virtue_points_read_at timestamp(6) without time zone,
    total_virtue_points_last_added integer,
    last_name_kana character varying NOT NULL,
    first_name_kana character varying NOT NULL,
    reset_password_token character varying,
    reset_password_token_expires_at timestamp(6) without time zone,
    reset_password_email_sent_at timestamp(6) without time zone,
    provider character varying,
    uid character varying
);


ALTER TABLE public.users OWNER TO shachiku_quest_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: shachiku_quest_db_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO shachiku_quest_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shachiku_quest_db_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: app_settings id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.app_settings ALTER COLUMN id SET DEFAULT nextval('public.app_settings_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- Name: help_magics id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.help_magics ALTER COLUMN id SET DEFAULT nextval('public.help_magics_id_seq'::regclass);


--
-- Name: help_requests id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.help_requests ALTER COLUMN id SET DEFAULT nextval('public.help_requests_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: personality_tags id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.personality_tags ALTER COLUMN id SET DEFAULT nextval('public.personality_tags_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: user_personality_tags id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.user_personality_tags ALTER COLUMN id SET DEFAULT nextval('public.user_personality_tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
3	avatar	User	12	3	2026-03-04 01:08:54.986835
4	image	ActiveStorage::VariantRecord	2	4	2026-03-04 01:09:00.085894
5	avatar	User	1	5	2026-03-04 09:44:13.164035
6	image	ActiveStorage::VariantRecord	3	6	2026-03-04 09:44:19.256474
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
3	e37o2yi17huct6c7xdn9u9h8qapt	33213346_s.jpg	image/jpeg	{"identified":true,"width":640,"height":480,"analyzed":true}	local	206445	LGMb0gXV/oEvrn9s9Q8FwQ==	2026-03-04 01:08:54.981851
4	uwp6um2t0vaxya54kxmy7imm98by	33213346_s.jpg	image/jpeg	{"identified":true,"width":48,"height":48,"analyzed":true}	local	1521	OyfnHJ9x2i7YWANwe+ND7A==	2026-03-04 01:09:00.083669
5	qp85qsvue8389nxivk0cpkbweakk	orange.png	image/png	{"identified":true,"width":1138,"height":958,"analyzed":true}	cloudinary	612871	WbveX7Nz0XlNGnvUP7+LaQ==	2026-03-04 09:44:13.154381
6	6icg8dbjjparr3i4w2bck93rq6fw	orange.png	image/png	{"identified":true,"width":48,"height":48,"analyzed":true}	cloudinary	6003	ZaFPdbZ+HzEEREpeWSU/sg==	2026-03-04 09:44:19.191685
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
2	3	EHCfWBA4Ulm0qPBU5kp7oAAzt/0=
3	5	IBRgQzX0JREzE1/XHLAmD+fJ004=
\.


--
-- Data for Name: app_settings; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.app_settings (id, key, value, created_at, updated_at) FROM stdin;
1	last_daily_reset_on	2026-03-05	2026-02-12 08:05:30.783035	2026-03-05 01:57:07.834183
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2026-02-09 15:30:50.073147	2026-02-09 15:30:50.07315
schema_sha1	e0a0ae2be0795ab13c07ecb31ff583474e2e0db6	2026-02-09 15:30:50.079585	2026-02-09 15:30:50.079587
\.


--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.conversations (id, help_request_id, created_at, updated_at) FROM stdin;
2	2	2026-02-25 09:45:52.935896	2026-02-25 09:45:52.935896
3	1	2026-02-25 16:08:46.555517	2026-02-25 16:08:46.555517
\.


--
-- Data for Name: help_magics; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.help_magics (id, user_id, available_time, available_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: help_requests; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.help_requests (id, task_id, helper_id, status, created_at, updated_at, required_time, last_helper_id, completed_notified_at, completed_read_at, request_message, helper_message, virtue_points, matched_on, matched_notified_at) FROM stdin;
3	12	\N	0	2026-02-25 07:59:15.505186	2026-02-25 07:59:15.505186	1	\N	\N	\N	助けてください！	\N	10	\N	\N
2	4	\N	0	2026-02-19 06:47:11.840094	2026-02-25 15:18:43.27611	0	5	\N	\N		\N	10	\N	\N
1	3	7	2	2026-02-19 06:45:45.135876	2026-02-25 16:08:46.344896	0	2	2026-02-25 07:59:53.802267	2026-02-25 16:07:55.446842	ちょっとコツがいります。	終わりました！	10	2026-02-25	2026-02-25 07:57:08.678204
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.messages (id, conversation_id, sender_id, body, read_at, created_at, updated_at, message_type, event_type) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.notifications (id, help_request_id, sender_id, recipient_id, message_type, body, read_at, created_at, updated_at) FROM stdin;
2	1	\N	2	0	マッチが成立しました。アプリ内で連絡してください。	2026-02-19 06:47:22.27084	2026-02-19 06:47:19.160367	2026-02-19 06:47:22.271331
1	1	\N	1	0	マッチが成立しました。アプリ内で連絡してください。	2026-02-21 16:15:00.782823	2026-02-19 06:47:19.152249	2026-02-21 16:15:00.783413
4	1	\N	7	0	マッチが成立しました。アプリ内で連絡してください。	2026-02-25 07:57:22.293282	2026-02-25 07:57:08.713038	2026-02-25 07:57:22.293736
6	2	\N	2	0	マッチが成立しました。アプリ内で連絡してください。	\N	2026-02-25 09:45:45.750196	2026-02-25 09:45:45.750196
7	2	\N	5	0	マッチが成立しました。アプリ内で連絡してください。	2026-02-25 09:46:16.598986	2026-02-25 09:45:45.762632	2026-02-25 09:46:16.599388
5	1	7	1	1	終わりました！	2026-02-25 16:07:42.935241	2026-02-25 07:59:53.81768	2026-02-25 16:07:42.935794
3	1	\N	1	0	マッチが成立しました。アプリ内で連絡してください。	2026-02-25 16:07:54.211893	2026-02-25 07:57:08.708295	2026-02-25 16:07:54.212318
8	1	1	7	2	ありがとうございました！徳ポイントを付与しました。	\N	2026-02-25 16:08:46.390492	2026-02-25 16:08:46.390492
\.


--
-- Data for Name: personality_tags; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.personality_tags (id, name, created_at, updated_at) FROM stdin;
1	生真面目	2026-02-09 15:30:50.231851	2026-02-09 15:30:50.231851
2	明るい	2026-02-09 15:30:50.239098	2026-02-09 15:30:50.239098
3	大ざっぱ	2026-02-09 15:30:50.254953	2026-02-09 15:30:50.254953
4	楽観的	2026-02-09 15:30:50.261737	2026-02-09 15:30:50.261737
5	物静か	2026-02-09 15:30:50.330711	2026-02-09 15:30:50.330711
6	几帳面	2026-02-09 15:30:50.346043	2026-02-09 15:30:50.346043
7	好奇心旺盛	2026-02-09 15:30:50.351164	2026-02-09 15:30:50.351164
8	人見知り	2026-02-09 15:30:50.363625	2026-02-09 15:30:50.363625
9	おしゃべり	2026-02-09 15:30:50.368387	2026-02-09 15:30:50.368387
10	聞き上手	2026-02-09 15:30:50.429303	2026-02-09 15:30:50.429303
11	マイペース	2026-02-09 15:30:50.436147	2026-02-09 15:30:50.436147
12	負けず嫌い	2026-02-09 15:30:50.443508	2026-02-09 15:30:50.443508
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.schema_migrations (version) FROM stdin;
20260208160044
20260204045422
20260203044034
20260201145219
20260131144950
20260131140949
20260130045847
20260130044031
20260128053023
20260128052402
20260128052332
20260128052322
20260127045409
20260127045122
20260126114825
20260126091028
20260126082713
20260126053721
20260123071437
20260121094854
20260121064522
20260118084220
20260115020142
20260114052534
20260113091247
20260113084803
20260113073825
20260113041927
20260111062231
20260109063455
20260109062837
20260105142854
20260102140131
20260210035719
20260210035843
20260211154112
20260214160702
20260218043052
20260218084554
20260218084602
20260218085158
20260218153128
20260219025809
20260225061036
20260304040827
\.


--
-- Data for Name: statuses; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.statuses (id, user_id, status_type, status_date, memo, created_at, updated_at) FROM stdin;
1	1	0	2026-02-12		2026-02-12 08:05:33.804828	2026-02-12 08:05:33.804828
2	1	0	2026-02-13		2026-02-12 17:05:06.67135	2026-02-12 17:05:06.67135
3	1	0	2026-02-14		2026-02-13 15:22:41.975009	2026-02-13 15:22:41.975009
4	1	0	2026-02-15		2026-02-14 15:33:05.705951	2026-02-14 15:33:05.705951
5	1	0	2026-02-16		2026-02-15 15:38:20.441015	2026-02-15 15:38:20.441015
6	1	0	2026-02-17		2026-02-16 15:04:01.480359	2026-02-16 15:04:01.480359
7	2	0	2026-02-17		2026-02-17 08:56:16.678521	2026-02-17 08:56:16.678521
8	1	0	2026-02-18		2026-02-18 04:26:14.910918	2026-02-18 04:26:14.910918
9	1	0	2026-02-19		2026-02-19 06:33:23.87497	2026-02-19 06:33:23.87497
10	2	0	2026-02-19		2026-02-19 06:46:01.727169	2026-02-19 06:46:01.727169
11	1	0	2026-02-22		2026-02-21 16:14:57.561643	2026-02-21 16:14:57.561643
12	3	1	2026-02-22		2026-02-21 16:20:06.806851	2026-02-21 16:20:06.806851
13	4	2	2026-02-22		2026-02-21 16:22:04.117837	2026-02-21 16:22:04.117837
14	2	1	2026-02-22		2026-02-21 16:23:34.146822	2026-02-21 16:23:34.146822
15	2	0	2026-02-23		2026-02-23 07:07:16.681011	2026-02-23 07:07:16.681011
16	1	0	2026-02-23		2026-02-23 07:07:56.893686	2026-02-23 07:07:56.893686
17	5	1	2026-02-23		2026-02-23 09:16:20.738928	2026-02-23 11:33:11.398786
18	1	0	2026-02-24		2026-02-23 15:57:48.868052	2026-02-23 15:57:48.868052
19	6	4	2026-02-24		2026-02-24 03:02:25.089711	2026-02-24 03:02:25.089711
20	2	0	2026-02-24		2026-02-24 06:23:06.060603	2026-02-24 06:23:06.060603
21	1	0	2026-02-25		2026-02-25 01:58:58.851986	2026-02-25 01:58:58.851986
22	2	0	2026-02-25		2026-02-25 02:01:50.4413	2026-02-25 02:01:50.4413
24	5	1	2026-02-25		2026-02-25 07:51:59.319765	2026-02-25 07:51:59.319765
25	7	0	2026-02-25		2026-02-25 07:56:01.308561	2026-02-25 07:56:01.308561
26	8	5	2026-02-26	東京帰りで疲労がやばいので、、、、	2026-02-25 15:19:08.090776	2026-02-25 15:19:08.090776
27	1	0	2026-02-26		2026-02-25 16:07:24.653768	2026-02-25 16:07:24.653768
28	3	1	2026-02-26		2026-02-25 16:10:17.544695	2026-02-25 16:10:17.544695
29	4	0	2026-02-26		2026-02-25 16:11:40.57266	2026-02-25 16:11:40.57266
30	9	5	2026-02-26		2026-02-26 07:39:41.28569	2026-02-26 07:39:41.28569
31	1	0	2026-02-27		2026-02-26 15:46:11.728875	2026-02-26 15:46:11.728875
32	5	1	2026-02-27		2026-02-27 02:34:24.150196	2026-02-27 02:34:24.150196
34	2	4	2026-02-27		2026-02-27 06:22:22.938053	2026-02-27 06:22:22.938053
35	1	0	2026-03-01		2026-03-01 09:32:27.357578	2026-03-01 09:32:27.357578
36	1	0	2026-03-02		2026-03-01 15:01:55.125857	2026-03-01 15:01:55.125857
37	1	0	2026-03-03		2026-03-02 15:26:46.429924	2026-03-02 15:26:46.429924
38	2	0	2026-03-03		2026-03-03 01:18:56.819961	2026-03-03 01:18:56.819961
39	10	0	2026-03-03		2026-03-03 09:01:02.636307	2026-03-03 09:01:02.636307
40	1	0	2026-03-04		2026-03-04 01:05:16.036613	2026-03-04 01:05:16.036613
42	12	0	2026-03-04		2026-03-04 01:08:57.734601	2026-03-04 01:08:57.734601
43	13	0	2026-03-04		2026-03-04 06:31:48.449142	2026-03-04 06:31:48.449142
44	1	0	2026-03-05		2026-03-05 02:13:45.392163	2026-03-05 02:13:45.392163
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.tasks (id, user_id, title, description, created_at, updated_at, status) FROM stdin;
1	2	会議に出席	芸能部報告会議に出席	2026-02-17 08:56:42.466756	2026-02-17 08:56:42.466756	0
2	1	会議に出席	3時から	2026-02-19 06:45:16.170182	2026-02-19 06:45:16.170182	0
3	1	馬の世話	ご飯と体拭き	2026-02-19 06:45:16.174337	2026-02-19 06:45:45.133012	1
4	2	資料作成	エクセルとパワポで作成	2026-02-19 06:47:11.775106	2026-02-19 06:47:11.775106	1
5	2	経費精算	1ヶ月分	2026-02-19 06:47:11.859282	2026-02-19 06:47:11.859282	0
6	3	馬の世話	馬の体拭き、爪切り	2026-02-21 16:20:25.541942	2026-02-21 16:20:25.541942	0
7	4	台詞おぼえ	次のドラマのセリフを覚える	2026-02-21 16:23:05.622682	2026-02-21 16:23:05.622682	0
8	4	日本テレビさんと打ち合わせ	喫茶ボンジュールで打ち合わせ	2026-02-21 16:23:05.62614	2026-02-21 16:23:05.62614	0
9	2	歌のレッスン	新曲の音合わせ	2026-02-21 16:23:55.988817	2026-02-21 16:23:55.988817	0
10	6	入金確認	あ	2026-02-24 03:02:45.716011	2026-02-24 03:02:45.716011	0
11	7	打合せ		2026-02-25 07:56:18.791089	2026-02-25 07:56:18.791089	0
12	7	打合せ2		2026-02-25 07:59:15.502166	2026-02-25 07:59:15.502166	1
13	8	卒制に向けた行動	いままでのまとめ	2026-02-25 15:19:34.635524	2026-02-25 15:19:34.635524	0
14	9	面談資料作成	志望動機	2026-02-26 07:39:57.447604	2026-02-26 07:39:57.447604	0
15	10	調査	ニーズ調査	2026-03-03 09:01:29.190343	2026-03-03 09:01:29.190343	0
16	13	テストの採点	中間試験の採点業務	2026-03-04 06:32:09.971126	2026-03-04 06:32:09.971126	0
\.


--
-- Data for Name: user_personality_tags; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.user_personality_tags (id, user_id, personality_tag_id, created_at, updated_at) FROM stdin;
1	1	9	2026-02-23 15:58:09.958305	2026-02-23 15:58:09.958305
2	1	11	2026-02-23 15:58:09.961271	2026-02-23 15:58:09.961271
3	2	11	2026-02-24 06:24:15.531822	2026-02-24 06:24:15.531822
4	2	7	2026-02-24 06:24:15.564351	2026-02-24 06:24:15.564351
5	3	8	2026-02-25 16:11:12.032009	2026-02-25 16:11:12.032009
6	3	5	2026-02-25 16:11:12.065344	2026-02-25 16:11:12.065344
7	3	12	2026-02-25 16:11:12.06855	2026-02-25 16:11:12.06855
8	4	9	2026-02-25 16:12:34.468234	2026-02-25 16:12:34.468234
9	4	3	2026-02-25 16:12:34.47164	2026-02-25 16:12:34.47164
10	4	7	2026-02-25 16:12:34.474652	2026-02-25 16:12:34.474652
11	4	2	2026-02-25 16:12:34.47779	2026-02-25 16:12:34.47779
12	4	4	2026-02-25 16:12:34.55648	2026-02-25 16:12:34.55648
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: shachiku_quest_db_user
--

COPY public.users (id, first_name, last_name, department, email, crypted_password, salt, level, total_virtue_points, created_at, updated_at, unconfirmed_email, email_change_token, email_change_token_expires_at, role, nickname, hobbies, introduction, total_virtue_points_notified_at, total_virtue_points_read_at, total_virtue_points_last_added, last_name_kana, first_name_kana, reset_password_token, reset_password_token_expires_at, reset_password_email_sent_at, provider, uid) FROM stdin;
5	Kaoru	R	販促企画	2@gmail.com	$2a$10$oMb8g2LZSYL47jmXhqsSquD4RwE8zDnDzun/9tZ0PvnNgty1K1GaG	Q4S8SJznCnjxuvE8VARY	1	0	2026-02-23 09:16:03.047815	2026-02-23 09:16:03.047815	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	り	かおる	\N	\N	\N	\N	\N
6	太郎	山田	経理	kafakore@via.tokyo.jp	$2a$10$d91btss9PDw9n2AwjEerpuv7QcrD0XSHmTjfiHUCJLQ1rKjMkOayi	7iKGhB4yGuFF_FG4g6d6	1	0	2026-02-24 03:01:56.163707	2026-02-24 03:01:56.163707	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	やまだ	たろう	\N	\N	\N	\N	\N
2	聖子	松田	芸能部	bbb@ccc	$2a$10$O31plL/K6GyBKtt9RxneyuNM/Bvsc2LpxpdtWLcPAJdRZ5BJRtvuO	Zso_cvm7nYXE8xGTbAom	1	0	2026-02-17 08:56:02.49011	2026-02-24 06:24:15.574245	\N	\N	\N	0	まっつん	カラオケ	歌うことが大好きです	\N	\N	\N	まつだ	せいこ	\N	\N	\N	\N	\N
8	裕輝	小笠原	ニート	paperdju2@gmail.com	$2a$10$V8ok1yuD68MXyBVdYjXwx.hqsEG.yjz0/DniGXHJJTN5vJc88.lNe	KAgozjZZnhtrDas9XTZ8	1	0	2026-02-25 15:18:42.875273	2026-02-25 15:18:42.875273	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	おがさわら	ゆうき	\N	\N	\N	\N	\N
7	賢人	山崎	俳優部	3@gmail.com	$2a$10$DObD/LxsYMxtPqAmoy90UuIS/xwH.g4ksxz3FU8Xl/Ei/y3tIYvgW	AzuLELpY5gxs9LqqUJk5	1	20	2026-02-25 07:55:57.52926	2026-02-25 16:08:46.378816	\N	\N	\N	0				2026-02-25 16:08:46.373553	\N	10	やまざき	けんと	\N	\N	\N	\N	\N
3	流星	横浜	俳優部	ddd@eee	$2a$10$rngsk6tRq9tmLcFxr1FFQe.KU1NN4T.KoqIHwt12eTXxWV2dBdxOG	6ZmuTMzz9VzCMgWY2uUZ	1	0	2026-02-21 16:19:55.859737	2026-02-25 16:11:12.072284	\N	\N	\N	0	りゅうくん	空手	顔だけじゃないです。	\N	\N	\N	よこはま	りゅうせい	\N	\N	\N	\N	\N
4	佳代	野呂	俳優部	eee@fff	$2a$10$XzgNsWiHFXvu1kxjIsEsHORSnkptQ2id5rjemhj71mHUyhMsM8T8W	NpQ_W8wzdGpzgRNW7EU9	1	0	2026-02-21 16:21:52.551652	2026-02-25 16:12:34.564692	\N	\N	\N	2	かめ	演技	女優です	\N	\N	\N	のろ	かよ	\N	\N	\N	\N	\N
9	尭宜	大平	営業部	gohira06@gmail.com	$2a$10$ak8s5pU.bzHJlODSm58POeg21zYktiHChOlQ7cEqOHM0wAiYabgdi	dZH42yrz6k86sD6FMdsL	1	0	2026-02-26 07:39:34.152801	2026-02-26 07:39:34.152801	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	おおひら	のりき	\N	\N	\N	\N	\N
10	ポリつ	B	企画部	sho.kamiguchi@gmail.com	$2a$10$A3f1eSuNu7OLdb5ROaokQ.r2V25PzqzGtEwOgJ7Q8JbCPWk6oK1L.	jz41T_VAGFcxhTFcHmSW	1	0	2026-03-03 09:00:55.78989	2026-03-03 09:00:55.78989	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	ぼりす	ぽりつ	\N	\N	\N	\N	\N
12	美幸	井森	芸能部	fff@ggg	$2a$10$yOytDpqi3Z4J2AwVN3gS2ekUDac2OWXhHkh7FUi5i2b/.wAr4xqZ6	SCxsb4sU63Fz3Vs8wTCJ	1	0	2026-03-04 01:08:54.885658	2026-03-04 01:08:55.105352	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	いもり	みゆき	\N	\N	\N	\N	\N
13	タロウ	テスト	総務部	test@example.com	$2a$10$j/M3BCP6gGou5wH6UWFs2e9l54BD8NbHBhXH/2a162XyirC99Kx8i	V6XwoYkbujSVXFzkiJxr	1	0	2026-03-04 06:31:46.088358	2026-03-04 06:31:46.088358	\N	\N	\N	0	\N	\N	\N	\N	\N	\N	てすと	たろう	\N	\N	\N	\N	\N
1	よしみ	天童	開発部	aaa@bbb	$2a$10$8fk1cYFlqjtKlEVQAVeKKezoIFPgf5wnryaELNJhgW77LluKL1UMm	uXRmt1MtbqwNDgnzzfo2	1	0	2026-02-12 08:05:18.237272	2026-03-04 09:44:18.255771	\N	\N	\N	1	てんちゃん	歌	よろしくです。	\N	\N	\N	てんどう	よしみ	\N	\N	\N	\N	\N
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 6, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 6, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 3, true);


--
-- Name: app_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.app_settings_id_seq', 1, true);


--
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.conversations_id_seq', 3, true);


--
-- Name: help_magics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.help_magics_id_seq', 10, true);


--
-- Name: help_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.help_requests_id_seq', 3, true);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.messages_id_seq', 2, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.notifications_id_seq', 8, true);


--
-- Name: personality_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.personality_tags_id_seq', 12, true);


--
-- Name: statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.statuses_id_seq', 44, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.tasks_id_seq', 16, true);


--
-- Name: user_personality_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.user_personality_tags_id_seq', 12, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shachiku_quest_db_user
--

SELECT pg_catalog.setval('public.users_id_seq', 13, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: app_settings app_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.app_settings
    ADD CONSTRAINT app_settings_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: help_magics help_magics_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.help_magics
    ADD CONSTRAINT help_magics_pkey PRIMARY KEY (id);


--
-- Name: help_requests help_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.help_requests
    ADD CONSTRAINT help_requests_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: personality_tags personality_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.personality_tags
    ADD CONSTRAINT personality_tags_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: user_personality_tags user_personality_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.user_personality_tags
    ADD CONSTRAINT user_personality_tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_app_settings_on_key; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_app_settings_on_key ON public.app_settings USING btree (key);


--
-- Name: index_conversations_on_help_request_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_conversations_on_help_request_id ON public.conversations USING btree (help_request_id);


--
-- Name: index_help_magics_on_user_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_help_magics_on_user_id ON public.help_magics USING btree (user_id);


--
-- Name: index_help_magics_on_user_id_and_available_date; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_help_magics_on_user_id_and_available_date ON public.help_magics USING btree (user_id, available_date);


--
-- Name: index_help_requests_on_helper_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_help_requests_on_helper_id ON public.help_requests USING btree (helper_id);


--
-- Name: index_help_requests_on_last_helper_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_help_requests_on_last_helper_id ON public.help_requests USING btree (last_helper_id);


--
-- Name: index_help_requests_on_status; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_help_requests_on_status ON public.help_requests USING btree (status);


--
-- Name: index_help_requests_on_task_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_help_requests_on_task_id ON public.help_requests USING btree (task_id);


--
-- Name: index_help_requests_on_task_id_and_helper_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_help_requests_on_task_id_and_helper_id ON public.help_requests USING btree (task_id, helper_id);


--
-- Name: index_messages_on_conversation_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_messages_on_conversation_id ON public.messages USING btree (conversation_id);


--
-- Name: index_messages_on_conversation_id_and_created_at; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_messages_on_conversation_id_and_created_at ON public.messages USING btree (conversation_id, created_at);


--
-- Name: index_messages_on_event_type; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_messages_on_event_type ON public.messages USING btree (event_type);


--
-- Name: index_messages_on_message_type; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_messages_on_message_type ON public.messages USING btree (message_type);


--
-- Name: index_messages_on_sender_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_messages_on_sender_id ON public.messages USING btree (sender_id);


--
-- Name: index_messages_on_sender_id_and_read_at; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_messages_on_sender_id_and_read_at ON public.messages USING btree (sender_id, read_at);


--
-- Name: index_notifications_on_help_request_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_notifications_on_help_request_id ON public.notifications USING btree (help_request_id);


--
-- Name: index_notifications_on_help_request_id_and_created_at; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_notifications_on_help_request_id_and_created_at ON public.notifications USING btree (help_request_id, created_at);


--
-- Name: index_notifications_on_recipient_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_notifications_on_recipient_id ON public.notifications USING btree (recipient_id);


--
-- Name: index_notifications_on_recipient_id_and_read_at; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_notifications_on_recipient_id_and_read_at ON public.notifications USING btree (recipient_id, read_at);


--
-- Name: index_notifications_on_sender_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_notifications_on_sender_id ON public.notifications USING btree (sender_id);


--
-- Name: index_statuses_on_user_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_statuses_on_user_id ON public.statuses USING btree (user_id);


--
-- Name: index_statuses_on_user_id_and_status_date; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_statuses_on_user_id_and_status_date ON public.statuses USING btree (user_id, status_date);


--
-- Name: index_tasks_on_user_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_tasks_on_user_id ON public.tasks USING btree (user_id);


--
-- Name: index_user_personality_tags_on_personality_tag_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_user_personality_tags_on_personality_tag_id ON public.user_personality_tags USING btree (personality_tag_id);


--
-- Name: index_user_personality_tags_on_user_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_user_personality_tags_on_user_id ON public.user_personality_tags USING btree (user_id);


--
-- Name: index_user_personality_tags_on_user_id_and_personality_tag_id; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_user_personality_tags_on_user_id_and_personality_tag_id ON public.user_personality_tags USING btree (user_id, personality_tag_id);


--
-- Name: index_users_on_email_change_token; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_users_on_email_change_token ON public.users USING btree (email_change_token);


--
-- Name: index_users_on_lower_email; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_users_on_lower_email ON public.users USING btree (lower((email)::text));


--
-- Name: index_users_on_provider_and_uid; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_users_on_provider_and_uid ON public.users USING btree (provider, uid);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unconfirmed_email; Type: INDEX; Schema: public; Owner: shachiku_quest_db_user
--

CREATE INDEX index_users_on_unconfirmed_email ON public.users USING btree (unconfirmed_email);


--
-- Name: notifications fk_rails_15399b2247; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_15399b2247 FOREIGN KEY (help_request_id) REFERENCES public.help_requests(id);


--
-- Name: conversations fk_rails_262ec4e7aa; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT fk_rails_262ec4e7aa FOREIGN KEY (help_request_id) REFERENCES public.help_requests(id);


--
-- Name: tasks fk_rails_4d2a9e4d7e; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_4d2a9e4d7e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: messages fk_rails_7f927086d2; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_7f927086d2 FOREIGN KEY (conversation_id) REFERENCES public.conversations(id);


--
-- Name: help_magics fk_rails_86a537b89c; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.help_magics
    ADD CONSTRAINT fk_rails_86a537b89c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: notifications fk_rails_873649f616; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_873649f616 FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: notifications fk_rails_9401376125; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_9401376125 FOREIGN KEY (recipient_id) REFERENCES public.users(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: statuses fk_rails_b29739edee; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT fk_rails_b29739edee FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: messages fk_rails_b8f26a382d; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_b8f26a382d FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: help_requests fk_rails_b92c0df983; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.help_requests
    ADD CONSTRAINT fk_rails_b92c0df983 FOREIGN KEY (helper_id) REFERENCES public.users(id);


--
-- Name: user_personality_tags fk_rails_c169a33fc3; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.user_personality_tags
    ADD CONSTRAINT fk_rails_c169a33fc3 FOREIGN KEY (personality_tag_id) REFERENCES public.personality_tags(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: user_personality_tags fk_rails_e8ded8f10a; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.user_personality_tags
    ADD CONSTRAINT fk_rails_e8ded8f10a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: help_requests fk_rails_ff2d17fac6; Type: FK CONSTRAINT; Schema: public; Owner: shachiku_quest_db_user
--

ALTER TABLE ONLY public.help_requests
    ADD CONSTRAINT fk_rails_ff2d17fac6 FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO shachiku_quest_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO shachiku_quest_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO shachiku_quest_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO shachiku_quest_db_user;


--
-- PostgreSQL database dump complete
--

\unrestrict p8eNNhiE2B3HmF6buxbPMDDgaAbfTbpHfc1E7BwhH86V2LYAl6v1l6A7Z0zYrOX

