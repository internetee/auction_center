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
-- Name: billing_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.billing_profiles (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    name character varying,
    vat_code character varying,
    legal_entity boolean DEFAULT false,
    street character varying NOT NULL,
    city character varying NOT NULL,
    state character varying,
    postal_code character varying NOT NULL,
    country character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


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
    roles character varying[] DEFAULT '{participant}'::character varying[]
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

ALTER TABLE ONLY audit.billing_profiles ALTER COLUMN id SET DEFAULT nextval('audit.billing_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.users ALTER COLUMN id SET DEFAULT nextval('audit.users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_profiles ALTER COLUMN id SET DEFAULT nextval('public.billing_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: billing_profiles_pkey; Type: CONSTRAINT; Schema: audit; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit.billing_profiles
    ADD CONSTRAINT billing_profiles_pkey PRIMARY KEY (id);


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
-- Name: billing_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.billing_profiles
    ADD CONSTRAINT billing_profiles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: billing_profiles_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX billing_profiles_object_id_idx ON audit.billing_profiles USING btree (object_id);


--
-- Name: billing_profiles_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX billing_profiles_recorded_at_idx ON audit.billing_profiles USING btree (recorded_at);


--
-- Name: users_object_id_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX users_object_id_idx ON audit.users USING btree (object_id);


--
-- Name: users_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -; Tablespace: 
--

CREATE INDEX users_recorded_at_idx ON audit.users USING btree (recorded_at);


--
-- Name: index_billing_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_billing_profiles_on_user_id ON public.billing_profiles USING btree (user_id);


--
-- Name: index_billing_profiles_on_vat_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_billing_profiles_on_vat_code ON public.billing_profiles USING btree (vat_code);


--
-- Name: index_users_on_alpha_two_country_code_and_identity_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_alpha_two_country_code_and_identity_code ON public.users USING btree (alpha_two_country_code, identity_code);


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
-- Name: process_billing_profile_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_billing_profile_audit AFTER INSERT OR DELETE OR UPDATE ON public.billing_profiles FOR EACH ROW EXECUTE PROCEDURE public.process_billing_profile_audit();


--
-- Name: process_user_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_user_audit AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE PROCEDURE public.process_user_audit();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO "schema_migrations" (version) VALUES
('20180829130641'),
('20180907083511'),
('20180919104523'),
('20180921084531'),
('20181001094917'),
('20181009104026');


