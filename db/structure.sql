SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audit;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: process_auction_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_auction_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.auctions
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.auctions
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.auctions
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


--
-- Name: process_billing_profile_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_billing_profile_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.billing_profiles
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.billing_profiles
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.billing_profiles
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


--
-- Name: process_invoice_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_invoice_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.invoices
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.invoices
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.invoices
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


--
-- Name: process_offer_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_offer_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.offers
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.offers
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.offers
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


--
-- Name: process_result_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_result_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.results
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.results
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.results
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


--
-- Name: process_setting_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_setting_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.settings
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.settings
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.settings
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


--
-- Name: process_user_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_user_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.users
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.users
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.users
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auctions; Type: TABLE; Schema: audit; Owner: -; Tablespace: 
--

CREATE TABLE audit.auctions (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT auctions_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: auctions_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.auctions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auctions_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.auctions_id_seq OWNED BY audit.auctions.id;


--
-- Name: billing_profiles; Type: TABLE; Schema: audit; Owner: -; Tablespace: 
--

CREATE TABLE audit.billing_profiles (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT billing_profiles_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: billing_profiles_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.billing_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: billing_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.billing_profiles_id_seq OWNED BY audit.billing_profiles.id;


--
-- Name: invoices; Type: TABLE; Schema: audit; Owner: -; Tablespace: 
--

CREATE TABLE audit.invoices (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT invoices_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.invoices_id_seq OWNED BY audit.invoices.id;


--
-- Name: offers; Type: TABLE; Schema: audit; Owner: -; Tablespace: 
--

CREATE TABLE audit.offers (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT offers_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.offers_id_seq OWNED BY audit.offers.id;


--
-- Name: results; Type: TABLE; Schema: audit; Owner: -; Tablespace: 
--

CREATE TABLE audit.results (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT results_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: results_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: results_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.results_id_seq OWNED BY audit.results.id;


--
-- Name: settings; Type: TABLE; Schema: audit; Owner: -; Tablespace: 
--

CREATE TABLE audit.settings (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT settings_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.settings_id_seq OWNED BY audit.settings.id;


--
-- Name: users; Type: TABLE; Schema: audit; Owner: -; Tablespace: 
--

CREATE TABLE audit.users (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT users_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.users_id_seq OWNED BY audit.users.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: auctions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.auctions (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    domain_name character varying NOT NULL,
    ends_at timestamp without time zone NOT NULL,
    starts_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT starts_at_earlier_than_ends_at CHECK ((starts_at < ends_at))
);


--
-- Name: auctions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auctions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auctions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auctions_id_seq OWNED BY public.auctions.id;


--
-- Name: billing_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.billing_profiles (
    id bigint NOT NULL,
    user_id integer,
    name character varying,
    vat_code character varying,
    street character varying NOT NULL,
    city character varying NOT NULL,
    state character varying,
    postal_code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    alpha_two_country_code character varying(2) NOT NULL
);


--
-- Name: billing_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.billing_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: billing_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.billing_profiles_id_seq OWNED BY public.billing_profiles.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.delayed_jobs (
    id bigint NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delayed_jobs_id_seq OWNED BY public.delayed_jobs.id;


--
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.invoice_items (
    id bigint NOT NULL,
    invoice_id integer,
    name character varying NOT NULL,
    cents integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoice_items_id_seq OWNED BY public.invoice_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.invoices (
    id bigint NOT NULL,
    result_id integer NOT NULL,
    user_id integer,
    billing_profile_id integer,
    issue_date date NOT NULL,
    due_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cents integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    paid_at timestamp without time zone,
    CONSTRAINT invoices_cents_are_positive CHECK ((cents > 0)),
    CONSTRAINT issued_at_earlier_than_payment_at CHECK ((issue_date <= due_date)),
    CONSTRAINT paid_at_is_filled_when_status_is_paid CHECK ((NOT ((status = 2) AND (paid_at IS NULL))))
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.offers (
    id bigint NOT NULL,
    auction_id integer NOT NULL,
    user_id integer,
    cents integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    billing_profile_id integer NOT NULL,
    CONSTRAINT offers_cents_are_positive CHECK ((cents > 0))
);


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offers_id_seq OWNED BY public.offers.id;


--
-- Name: results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.results (
    id bigint NOT NULL,
    auction_id integer NOT NULL,
    user_id integer,
    offer_id integer,
    sold boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.results_id_seq OWNED BY public.results.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    code character varying NOT NULL,
    description text NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    encrypted_password character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    alpha_two_country_code character varying(2) NOT NULL,
    identity_code character varying NOT NULL,
    given_names character varying NOT NULL,
    surname character varying NOT NULL,
    mobile_phone character varying NOT NULL,
    roles character varying[] DEFAULT '{participant}'::character varying[],
    terms_and_conditions_accepted_at timestamp without time zone,
    CONSTRAINT users_roles_are_known CHECK ((roles <@ ARRAY['participant'::character varying, 'administrator'::character varying]))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.auctions ALTER COLUMN id SET DEFAULT nextval('audit.auctions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.billing_profiles ALTER COLUMN id SET DEFAULT nextval('audit.billing_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.invoices ALTER COLUMN id SET DEFAULT nextval('audit.invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.offers ALTER COLUMN id SET DEFAULT nextval('audit.offers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.results ALTER COLUMN id SET DEFAULT nextval('audit.results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.settings ALTER COLUMN id SET DEFAULT nextval('audit.settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.users ALTER COLUMN id SET DEFAULT nextval('audit.users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions ALTER COLUMN id SET DEFAULT nextval('public.auctions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_profiles ALTER COLUMN id SET DEFAULT nextval('public.billing_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items ALTER COLUMN id SET DEFAULT nextval('public.invoice_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers ALTER COLUMN id SET DEFAULT nextval('public.offers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results ALTER COLUMN id SET DEFAULT nextval('public.results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: auctions_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.auctions
    ADD CONSTRAINT auctions_pkey PRIMARY KEY (id);


--
-- Name: billing_profiles_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.billing_profiles
    ADD CONSTRAINT billing_profiles_pkey PRIMARY KEY (id);


--
-- Name: invoices_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: results_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: auctions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT auctions_pkey PRIMARY KEY (id);


--
-- Name: billing_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.billing_profiles
    ADD CONSTRAINT billing_profiles_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: unique_domain_name_per_auction_duration; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT unique_domain_name_per_auction_duration EXCLUDE USING gist (domain_name WITH =, tsrange(starts_at, ends_at, '[]'::text) WITH &&);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: auctions_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX auctions_object_id_idx ON audit.auctions USING btree (object_id);


--
-- Name: auctions_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX auctions_recorded_at_idx ON audit.auctions USING btree (recorded_at);


--
-- Name: billing_profiles_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX billing_profiles_object_id_idx ON audit.billing_profiles USING btree (object_id);


--
-- Name: billing_profiles_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX billing_profiles_recorded_at_idx ON audit.billing_profiles USING btree (recorded_at);


--
-- Name: invoices_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX invoices_object_id_idx ON audit.invoices USING btree (object_id);


--
-- Name: invoices_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX invoices_recorded_at_idx ON audit.invoices USING btree (recorded_at);


--
-- Name: offers_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX offers_object_id_idx ON audit.offers USING btree (object_id);


--
-- Name: offers_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX offers_recorded_at_idx ON audit.offers USING btree (recorded_at);


--
-- Name: results_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX results_object_id_idx ON audit.results USING btree (object_id);


--
-- Name: results_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX results_recorded_at_idx ON audit.results USING btree (recorded_at);


--
-- Name: settings_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX settings_object_id_idx ON audit.settings USING btree (object_id);


--
-- Name: settings_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX settings_recorded_at_idx ON audit.settings USING btree (recorded_at);


--
-- Name: users_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX users_object_id_idx ON audit.users USING btree (object_id);


--
-- Name: users_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX users_recorded_at_idx ON audit.users USING btree (recorded_at);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: index_auctions_on_domain_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auctions_on_domain_name ON public.auctions USING btree (domain_name);


--
-- Name: index_auctions_on_ends_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auctions_on_ends_at ON public.auctions USING btree (ends_at);


--
-- Name: index_billing_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_billing_profiles_on_user_id ON public.billing_profiles USING btree (user_id);


--
-- Name: index_billing_profiles_on_vat_code_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_billing_profiles_on_vat_code_and_user_id ON public.billing_profiles USING btree (vat_code, user_id);


--
-- Name: index_invoice_items_on_invoice_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invoice_items_on_invoice_id ON public.invoice_items USING btree (invoice_id);


--
-- Name: index_invoices_on_billing_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invoices_on_billing_profile_id ON public.invoices USING btree (billing_profile_id);


--
-- Name: index_invoices_on_result_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invoices_on_result_id ON public.invoices USING btree (result_id);


--
-- Name: index_invoices_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invoices_on_user_id ON public.invoices USING btree (user_id);


--
-- Name: index_offers_on_auction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offers_on_auction_id ON public.offers USING btree (auction_id);


--
-- Name: index_offers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_offers_on_user_id ON public.offers USING btree (user_id);


--
-- Name: index_results_on_auction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_results_on_auction_id ON public.results USING btree (auction_id);


--
-- Name: index_results_on_offer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_results_on_offer_id ON public.results USING btree (offer_id);


--
-- Name: index_results_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_results_on_user_id ON public.results USING btree (user_id);


--
-- Name: index_settings_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_settings_on_code ON public.settings USING btree (code);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: users_by_identity_code_and_country; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_by_identity_code_and_country ON public.users USING btree (alpha_two_country_code, identity_code) WHERE ((alpha_two_country_code)::text = 'EE'::text);


--
-- Name: process_auction_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_auction_audit AFTER INSERT OR DELETE OR UPDATE ON public.auctions FOR EACH ROW EXECUTE PROCEDURE public.process_auction_audit();


--
-- Name: process_billing_profile_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_billing_profile_audit AFTER INSERT OR DELETE OR UPDATE ON public.billing_profiles FOR EACH ROW EXECUTE PROCEDURE public.process_billing_profile_audit();


--
-- Name: process_invoice_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_invoice_audit AFTER INSERT OR DELETE OR UPDATE ON public.invoices FOR EACH ROW EXECUTE PROCEDURE public.process_invoice_audit();


--
-- Name: process_offer_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_offer_audit AFTER INSERT OR DELETE OR UPDATE ON public.offers FOR EACH ROW EXECUTE PROCEDURE public.process_offer_audit();


--
-- Name: process_result_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_result_audit AFTER INSERT OR DELETE OR UPDATE ON public.results FOR EACH ROW EXECUTE PROCEDURE public.process_result_audit();


--
-- Name: process_setting_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_setting_audit AFTER INSERT OR DELETE OR UPDATE ON public.settings FOR EACH ROW EXECUTE PROCEDURE public.process_setting_audit();


--
-- Name: process_user_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_user_audit AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE PROCEDURE public.process_user_audit();


--
-- Name: fk_rails_25bf3d2c5e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT fk_rails_25bf3d2c5e FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: fk_rails_3d1522a0d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_rails_3d1522a0d8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_7f0d5a2cd6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_7f0d5a2cd6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_8fda547d9d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_profiles
    ADD CONSTRAINT fk_rails_8fda547d9d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_9f5d06cf95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_9f5d06cf95 FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: fk_rails_bb5f3f4ecb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT fk_rails_bb5f3f4ecb FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: fk_rails_d44c2f8d29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_rails_d44c2f8d29 FOREIGN KEY (result_id) REFERENCES public.results(id);


--
-- Name: fk_rails_e6095d6211; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT fk_rails_e6095d6211 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_ff50c5defa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_rails_ff50c5defa FOREIGN KEY (billing_profile_id) REFERENCES public.billing_profiles(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO "schema_migrations" (version) VALUES
('20180829130641'),
('20180907083511'),
('20180919104523'),
('20180921084531'),
('20180928060715'),
('20181001094917'),
('20181008124201'),
('20181008133152'),
('20181009104026'),
('20181011080931'),
('20181011082830'),
('20181016124017'),
('20181017114957'),
('20181017122905'),
('20181018064054'),
('20181022095409'),
('20181023103316'),
('20181023121607'),
('20181023125230'),
('20181029121254'),
('20181030075851'),
('20181102080251'),
('20181102132927'),
('20181106075840'),
('20181107084751'),
('20181107113525'),
('20181114142500'),
('20181115083934'),
('20181115122806'),
('20181119091242'),
('20181119114425'),
('20181120093105'),
('20181120120117'),
('20181120121027'),
('20181121091758'),
('20181121120238'),
('20181122134301'),
('20181122135839'),
('20181129113446'),
('20181204094329'),
('20181204114134'),
('20181205134446'),
('20181206134245'),
('20181211081031'),
('20181211081329');


