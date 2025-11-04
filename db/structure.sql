SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audit;


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: invoice_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_status AS ENUM (
    'issued',
    'paid',
    'cancelled'
);


--
-- Name: payment_order_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.payment_order_status AS ENUM (
    'issued',
    'in_progress',
    'paid',
    'cancelled'
);


--
-- Name: result_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.result_status AS ENUM (
    'no_bids',
    'awaiting_payment',
    'payment_received',
    'payment_not_received',
    'domain_registered',
    'domain_not_registered'
);


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
-- Name: process_ban_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_ban_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.bans
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.bans
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.bans
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
-- Name: process_invoice_item_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_invoice_item_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.invoice_items
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.invoice_items
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.invoice_items
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


--
-- Name: process_invoice_payment_order_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_invoice_payment_order_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.invoice_payment_orders
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.invoice_payment_orders
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.invoice_payment_orders
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
-- Name: process_payment_order_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_payment_order_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.payment_orders
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.payment_orders
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.payment_orders
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


--
-- Name: process_wishlist_item_audit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.process_wishlist_item_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO audit.wishlist_items
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'UPDATE') THEN
      INSERT INTO audit.wishlist_items
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
      RETURN NEW;
    ELSEIF (TG_OP = 'DELETE') THEN
      INSERT INTO audit.wishlist_items
      (object_id, action, recorded_at, old_value, new_value)
      VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
      RETURN OLD;
    END IF;
    RETURN NULL;
  END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auctions; Type: TABLE; Schema: audit; Owner: -
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
-- Name: bans; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.bans (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT bans_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: bans_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.bans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bans_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.bans_id_seq OWNED BY audit.bans.id;


--
-- Name: billing_profiles; Type: TABLE; Schema: audit; Owner: -
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
-- Name: invoice_items; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.invoice_items (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT invoice_items_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.invoice_items_id_seq OWNED BY audit.invoice_items.id;


--
-- Name: invoice_payment_orders; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.invoice_payment_orders (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT invoice_payment_orders_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: invoice_payment_orders_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.invoice_payment_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_payment_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.invoice_payment_orders_id_seq OWNED BY audit.invoice_payment_orders.id;


--
-- Name: invoices; Type: TABLE; Schema: audit; Owner: -
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
-- Name: offers; Type: TABLE; Schema: audit; Owner: -
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
-- Name: payment_orders; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.payment_orders (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT payment_orders_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: payment_orders_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.payment_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.payment_orders_id_seq OWNED BY audit.payment_orders.id;


--
-- Name: results; Type: TABLE; Schema: audit; Owner: -
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
-- Name: settings; Type: TABLE; Schema: audit; Owner: -
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
-- Name: users; Type: TABLE; Schema: audit; Owner: -
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
-- Name: wishlist_items; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.wishlist_items (
    id integer NOT NULL,
    object_id bigint,
    action text NOT NULL,
    recorded_at timestamp without time zone,
    old_value jsonb,
    new_value jsonb,
    CONSTRAINT wishlist_items_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text])))
);


--
-- Name: wishlist_items_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.wishlist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wishlist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.wishlist_items_id_seq OWNED BY audit.wishlist_items.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: auctions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auctions (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    domain_name character varying NOT NULL,
    ends_at timestamp without time zone,
    starts_at timestamp without time zone,
    uuid uuid DEFAULT public.gen_random_uuid(),
    remote_id character varying,
    turns_count integer,
    platform integer,
    starting_price numeric,
    min_bids_step numeric(10,2),
    slipping_end integer,
    initial_ends_at timestamp without time zone,
    enable_deposit boolean DEFAULT false NOT NULL,
    requirement_deposit_in_cents integer,
    ai_score integer DEFAULT 0,
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
-- Name: autobiders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autobiders (
    id bigint NOT NULL,
    user_id bigint,
    domain_name character varying,
    cents integer,
    uuid uuid DEFAULT gen_random_uuid(),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    enable boolean DEFAULT false
);


--
-- Name: autobiders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.autobiders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: autobiders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autobiders_id_seq OWNED BY public.autobiders.id;


--
-- Name: bank_statements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_statements (
    id bigint NOT NULL,
    bank_code character varying,
    iban character varying,
    queried_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bank_statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bank_statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bank_statements_id_seq OWNED BY public.bank_statements.id;


--
-- Name: bank_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_transactions (
    id bigint NOT NULL,
    bank_statement_id bigint,
    bank_reference character varying,
    iban character varying,
    currency character varying,
    buyer_bank_code character varying,
    buyer_iban character varying,
    buyer_name character varying,
    document_no character varying,
    description character varying,
    sum numeric,
    reference_no character varying,
    paid_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bank_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bank_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bank_transactions_id_seq OWNED BY public.bank_transactions.id;


--
-- Name: bans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bans (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    valid_from timestamp without time zone DEFAULT now() NOT NULL,
    valid_until timestamp without time zone NOT NULL,
    domain_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invoice_id integer
);


--
-- Name: bans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bans_id_seq OWNED BY public.bans.id;


--
-- Name: billing_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billing_profiles (
    id bigint NOT NULL,
    user_id integer,
    name character varying,
    vat_code character varying,
    street character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    alpha_two_country_code character varying(2) NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid(),
    updated_by character varying
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
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_migrations (
    version character varying NOT NULL
);


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
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
-- Name: directo_customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.directo_customers (
    id bigint NOT NULL,
    vat_number public.citext NOT NULL,
    customer_code character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: directo_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directo_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directo_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directo_customers_id_seq OWNED BY public.directo_customers.id;


--
-- Name: domain_participate_auctions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.domain_participate_auctions (
    id bigint NOT NULL,
    user_id bigint,
    auction_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    refund_time timestamp without time zone,
    invoice_number character varying
);


--
-- Name: domain_participate_auctions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.domain_participate_auctions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domain_participate_auctions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.domain_participate_auctions_id_seq OWNED BY public.domain_participate_auctions.id;


--
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_items (
    id bigint NOT NULL,
    invoice_id integer,
    name character varying NOT NULL,
    cents integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid()
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
-- Name: invoice_payment_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_payment_orders (
    id bigint NOT NULL,
    invoice_id bigint NOT NULL,
    payment_order_id bigint NOT NULL
);


--
-- Name: invoice_payment_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoice_payment_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_payment_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoice_payment_orders_id_seq OWNED BY public.invoice_payment_orders.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
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
    paid_at timestamp without time zone,
    status public.invoice_status DEFAULT 'issued'::public.invoice_status,
    number_old integer NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid(),
    vat_rate numeric,
    paid_amount numeric DEFAULT 0.0,
    updated_by character varying,
    notes character varying,
    paid_with_payment_order_id bigint,
    recipient character varying,
    vat_code character varying,
    legal_entity boolean,
    street character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    alpha_two_country_code character varying,
    in_directo boolean DEFAULT false NOT NULL,
    payment_link character varying,
    number integer,
    billing_name character varying DEFAULT ''::character varying NOT NULL,
    billing_address character varying DEFAULT ''::character varying NOT NULL,
    billing_vat_code character varying,
    billing_alpha_two_country_code character varying DEFAULT ''::character varying NOT NULL,
    e_invoice_sent_at timestamp(6) without time zone,
    partial_payments boolean DEFAULT false,
    CONSTRAINT invoices_cents_are_non_negative CHECK ((cents >= 0)),
    CONSTRAINT invoices_due_date_is_not_before_issue_date CHECK ((issue_date <= due_date)),
    CONSTRAINT paid_at_is_filled_when_status_is_paid CHECK ((NOT ((status = 'paid'::public.invoice_status) AND (paid_at IS NULL)))),
    CONSTRAINT paid_at_is_not_filled_when_status_is_not_paid CHECK ((NOT ((status <> 'paid'::public.invoice_status) AND (paid_at IS NOT NULL))))
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
-- Name: invoices_number_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_number_seq OWNED BY public.invoices.number_old;


--
-- Name: noticed_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.noticed_events (
    id bigint NOT NULL,
    type character varying,
    record_type character varying,
    record_id bigint,
    params jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notifications_count integer
);


--
-- Name: noticed_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.noticed_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: noticed_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.noticed_events_id_seq OWNED BY public.noticed_events.id;


--
-- Name: noticed_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.noticed_notifications (
    id bigint NOT NULL,
    type character varying,
    event_id bigint NOT NULL,
    recipient_type character varying NOT NULL,
    recipient_id bigint NOT NULL,
    read_at timestamp without time zone,
    seen_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.noticed_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.noticed_notifications_id_seq OWNED BY public.noticed_notifications.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    recipient_type character varying NOT NULL,
    recipient_id bigint NOT NULL,
    type character varying NOT NULL,
    params jsonb,
    read_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offers (
    id bigint NOT NULL,
    auction_id integer NOT NULL,
    user_id integer,
    cents integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    billing_profile_id integer NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid(),
    updated_by character varying,
    username character varying,
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
-- Name: payment_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_orders (
    id bigint NOT NULL,
    type character varying NOT NULL,
    invoice_id integer,
    user_id integer,
    response jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status public.payment_order_status DEFAULT 'issued'::public.payment_order_status,
    uuid uuid DEFAULT public.gen_random_uuid()
);


--
-- Name: payment_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_orders_id_seq OWNED BY public.payment_orders.id;


--
-- Name: remote_view_partials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.remote_view_partials (
    id bigint NOT NULL,
    name character varying NOT NULL,
    locale character varying NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: remote_view_partials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.remote_view_partials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: remote_view_partials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.remote_view_partials_id_seq OWNED BY public.remote_view_partials.id;


--
-- Name: results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.results (
    id bigint NOT NULL,
    auction_id integer NOT NULL,
    user_id integer,
    offer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid(),
    status public.result_status,
    last_remote_status public.result_status,
    last_response jsonb,
    registration_code character varying,
    registration_due_date date NOT NULL,
    registration_reminder_sent_at timestamp without time zone
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    code character varying NOT NULL,
    description text NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by character varying,
    value_format character varying DEFAULT 'string'::character varying NOT NULL
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
-- Name: statistics_report_invoices; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.statistics_report_invoices AS
 SELECT invoices.id,
    invoices.issue_date,
    invoices.status
   FROM public.invoices
  WITH NO DATA;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
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
    identity_code character varying,
    given_names character varying NOT NULL,
    surname character varying NOT NULL,
    mobile_phone character varying,
    roles character varying[] DEFAULT '{participant}'::character varying[],
    terms_and_conditions_accepted_at timestamp without time zone,
    uuid uuid DEFAULT public.gen_random_uuid(),
    mobile_phone_confirmed_at timestamp without time zone,
    mobile_phone_confirmation_code character varying,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    provider character varying,
    uid character varying,
    updated_by character varying,
    daily_summary boolean DEFAULT false NOT NULL,
    jti character varying,
    reference_no character varying,
    mobile_phone_confirmed_sms_send_at timestamp(6) without time zone,
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
-- Name: webpush_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webpush_subscriptions (
    id bigint NOT NULL,
    endpoint character varying,
    p256dh character varying,
    auth character varying,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: webpush_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.webpush_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webpush_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.webpush_subscriptions_id_seq OWNED BY public.webpush_subscriptions.id;


--
-- Name: wishlist_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wishlist_items (
    id bigint NOT NULL,
    domain_name character varying NOT NULL,
    user_id integer NOT NULL,
    uuid uuid DEFAULT public.gen_random_uuid(),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cents integer,
    processed boolean DEFAULT false
);


--
-- Name: wishlist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wishlist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wishlist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wishlist_items_id_seq OWNED BY public.wishlist_items.id;


--
-- Name: auctions id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.auctions ALTER COLUMN id SET DEFAULT nextval('audit.auctions_id_seq'::regclass);


--
-- Name: bans id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.bans ALTER COLUMN id SET DEFAULT nextval('audit.bans_id_seq'::regclass);


--
-- Name: billing_profiles id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.billing_profiles ALTER COLUMN id SET DEFAULT nextval('audit.billing_profiles_id_seq'::regclass);


--
-- Name: invoice_items id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.invoice_items ALTER COLUMN id SET DEFAULT nextval('audit.invoice_items_id_seq'::regclass);


--
-- Name: invoice_payment_orders id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.invoice_payment_orders ALTER COLUMN id SET DEFAULT nextval('audit.invoice_payment_orders_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.invoices ALTER COLUMN id SET DEFAULT nextval('audit.invoices_id_seq'::regclass);


--
-- Name: offers id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.offers ALTER COLUMN id SET DEFAULT nextval('audit.offers_id_seq'::regclass);


--
-- Name: payment_orders id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.payment_orders ALTER COLUMN id SET DEFAULT nextval('audit.payment_orders_id_seq'::regclass);


--
-- Name: results id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.results ALTER COLUMN id SET DEFAULT nextval('audit.results_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.settings ALTER COLUMN id SET DEFAULT nextval('audit.settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.users ALTER COLUMN id SET DEFAULT nextval('audit.users_id_seq'::regclass);


--
-- Name: wishlist_items id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.wishlist_items ALTER COLUMN id SET DEFAULT nextval('audit.wishlist_items_id_seq'::regclass);


--
-- Name: auctions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions ALTER COLUMN id SET DEFAULT nextval('public.auctions_id_seq'::regclass);


--
-- Name: autobiders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autobiders ALTER COLUMN id SET DEFAULT nextval('public.autobiders_id_seq'::regclass);


--
-- Name: bank_statements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_statements ALTER COLUMN id SET DEFAULT nextval('public.bank_statements_id_seq'::regclass);


--
-- Name: bank_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transactions ALTER COLUMN id SET DEFAULT nextval('public.bank_transactions_id_seq'::regclass);


--
-- Name: bans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans ALTER COLUMN id SET DEFAULT nextval('public.bans_id_seq'::regclass);


--
-- Name: billing_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_profiles ALTER COLUMN id SET DEFAULT nextval('public.billing_profiles_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: directo_customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directo_customers ALTER COLUMN id SET DEFAULT nextval('public.directo_customers_id_seq'::regclass);


--
-- Name: domain_participate_auctions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_participate_auctions ALTER COLUMN id SET DEFAULT nextval('public.domain_participate_auctions_id_seq'::regclass);


--
-- Name: invoice_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items ALTER COLUMN id SET DEFAULT nextval('public.invoice_items_id_seq'::regclass);


--
-- Name: invoice_payment_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_payment_orders ALTER COLUMN id SET DEFAULT nextval('public.invoice_payment_orders_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: invoices number_old; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN number_old SET DEFAULT nextval('public.invoices_number_seq'::regclass);


--
-- Name: noticed_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.noticed_events ALTER COLUMN id SET DEFAULT nextval('public.noticed_events_id_seq'::regclass);


--
-- Name: noticed_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.noticed_notifications ALTER COLUMN id SET DEFAULT nextval('public.noticed_notifications_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers ALTER COLUMN id SET DEFAULT nextval('public.offers_id_seq'::regclass);


--
-- Name: payment_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_orders ALTER COLUMN id SET DEFAULT nextval('public.payment_orders_id_seq'::regclass);


--
-- Name: remote_view_partials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.remote_view_partials ALTER COLUMN id SET DEFAULT nextval('public.remote_view_partials_id_seq'::regclass);


--
-- Name: results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results ALTER COLUMN id SET DEFAULT nextval('public.results_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: webpush_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webpush_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.webpush_subscriptions_id_seq'::regclass);


--
-- Name: wishlist_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlist_items ALTER COLUMN id SET DEFAULT nextval('public.wishlist_items_id_seq'::regclass);


--
-- Name: auctions auctions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT auctions_pkey PRIMARY KEY (id);


--
-- Name: statistics_report_auctions; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.statistics_report_auctions AS
 SELECT auctions.id,
    auctions.domain_name,
    auctions.created_at,
    auctions.starts_at,
    auctions.ends_at,
    count(offers.*) AS offers_count,
    (EXISTS ( SELECT results.id,
            results.auction_id,
            results.user_id,
            results.offer_id,
            results.created_at,
            results.updated_at,
            results.uuid,
            results.status,
            results.last_remote_status,
            results.last_response,
            results.registration_code,
            results.registration_due_date,
            results.registration_reminder_sent_at
           FROM public.results
          WHERE (results.auction_id = auctions.id))) AS completed
   FROM (public.auctions
     LEFT JOIN public.offers ON ((auctions.id = offers.auction_id)))
  GROUP BY auctions.id
  WITH NO DATA;


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: statistics_report_results; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.statistics_report_results AS
 SELECT results.id,
    auctions.domain_name,
    results.created_at,
    auctions.ends_at AS auction_ends_at,
    results.status
   FROM (public.results
     JOIN public.auctions ON ((results.auction_id = auctions.id)))
  GROUP BY results.id, auctions.domain_name, auctions.ends_at
  WITH NO DATA;


--
-- Name: auctions auctions_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.auctions
    ADD CONSTRAINT auctions_pkey PRIMARY KEY (id);


--
-- Name: bans bans_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.bans
    ADD CONSTRAINT bans_pkey PRIMARY KEY (id);


--
-- Name: billing_profiles billing_profiles_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.billing_profiles
    ADD CONSTRAINT billing_profiles_pkey PRIMARY KEY (id);


--
-- Name: invoice_items invoice_items_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoice_payment_orders invoice_payment_orders_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.invoice_payment_orders
    ADD CONSTRAINT invoice_payment_orders_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: payment_orders payment_orders_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.payment_orders
    ADD CONSTRAINT payment_orders_pkey PRIMARY KEY (id);


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wishlist_items wishlist_items_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.wishlist_items
    ADD CONSTRAINT wishlist_items_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: autobiders autobiders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autobiders
    ADD CONSTRAINT autobiders_pkey PRIMARY KEY (id);


--
-- Name: bank_statements bank_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_statements
    ADD CONSTRAINT bank_statements_pkey PRIMARY KEY (id);


--
-- Name: bank_transactions bank_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transactions
    ADD CONSTRAINT bank_transactions_pkey PRIMARY KEY (id);


--
-- Name: bans bans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans
    ADD CONSTRAINT bans_pkey PRIMARY KEY (id);


--
-- Name: billing_profiles billing_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_profiles
    ADD CONSTRAINT billing_profiles_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (version);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: directo_customers directo_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directo_customers
    ADD CONSTRAINT directo_customers_pkey PRIMARY KEY (id);


--
-- Name: domain_participate_auctions domain_participate_auctions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_participate_auctions
    ADD CONSTRAINT domain_participate_auctions_pkey PRIMARY KEY (id);


--
-- Name: invoice_items invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoice_payment_orders invoice_payment_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_payment_orders
    ADD CONSTRAINT invoice_payment_orders_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: noticed_events noticed_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.noticed_events
    ADD CONSTRAINT noticed_events_pkey PRIMARY KEY (id);


--
-- Name: noticed_notifications noticed_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.noticed_notifications
    ADD CONSTRAINT noticed_notifications_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: payment_orders payment_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_orders
    ADD CONSTRAINT payment_orders_pkey PRIMARY KEY (id);


--
-- Name: remote_view_partials remote_view_partials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.remote_view_partials
    ADD CONSTRAINT remote_view_partials_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: auctions unique_domain_name_per_auction_duration; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT unique_domain_name_per_auction_duration EXCLUDE USING gist (domain_name WITH =, tsrange(starts_at, ends_at, '[]'::text) WITH &&);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webpush_subscriptions webpush_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webpush_subscriptions
    ADD CONSTRAINT webpush_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: wishlist_items wishlist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlist_items
    ADD CONSTRAINT wishlist_items_pkey PRIMARY KEY (id);


--
-- Name: auctions_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX auctions_object_id_idx ON audit.auctions USING btree (object_id);


--
-- Name: auctions_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX auctions_recorded_at_idx ON audit.auctions USING btree (recorded_at);


--
-- Name: bans_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX bans_object_id_idx ON audit.bans USING btree (object_id);


--
-- Name: bans_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX bans_recorded_at_idx ON audit.bans USING btree (recorded_at);


--
-- Name: billing_profiles_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX billing_profiles_object_id_idx ON audit.billing_profiles USING btree (object_id);


--
-- Name: billing_profiles_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX billing_profiles_recorded_at_idx ON audit.billing_profiles USING btree (recorded_at);


--
-- Name: invoice_items_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX invoice_items_object_id_idx ON audit.invoice_items USING btree (object_id);


--
-- Name: invoice_items_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX invoice_items_recorded_at_idx ON audit.invoice_items USING btree (recorded_at);


--
-- Name: invoice_payment_orders_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX invoice_payment_orders_object_id_idx ON audit.invoice_payment_orders USING btree (object_id);


--
-- Name: invoice_payment_orders_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX invoice_payment_orders_recorded_at_idx ON audit.invoice_payment_orders USING btree (recorded_at);


--
-- Name: invoices_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX invoices_object_id_idx ON audit.invoices USING btree (object_id);


--
-- Name: invoices_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX invoices_recorded_at_idx ON audit.invoices USING btree (recorded_at);


--
-- Name: offers_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX offers_object_id_idx ON audit.offers USING btree (object_id);


--
-- Name: offers_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX offers_recorded_at_idx ON audit.offers USING btree (recorded_at);


--
-- Name: payment_orders_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX payment_orders_object_id_idx ON audit.payment_orders USING btree (object_id);


--
-- Name: payment_orders_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX payment_orders_recorded_at_idx ON audit.payment_orders USING btree (recorded_at);


--
-- Name: results_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX results_object_id_idx ON audit.results USING btree (object_id);


--
-- Name: results_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX results_recorded_at_idx ON audit.results USING btree (recorded_at);


--
-- Name: settings_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX settings_object_id_idx ON audit.settings USING btree (object_id);


--
-- Name: settings_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX settings_recorded_at_idx ON audit.settings USING btree (recorded_at);


--
-- Name: users_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX users_object_id_idx ON audit.users USING btree (object_id);


--
-- Name: users_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX users_recorded_at_idx ON audit.users USING btree (recorded_at);


--
-- Name: wishlist_items_object_id_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX wishlist_items_object_id_idx ON audit.wishlist_items USING btree (object_id);


--
-- Name: wishlist_items_recorded_at_idx; Type: INDEX; Schema: audit; Owner: -
--

CREATE INDEX wishlist_items_recorded_at_idx ON audit.wishlist_items USING btree (recorded_at);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: index_auctions_on_domain_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auctions_on_domain_name ON public.auctions USING btree (domain_name);


--
-- Name: index_auctions_on_remote_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auctions_on_remote_id ON public.auctions USING btree (remote_id);


--
-- Name: index_auctions_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auctions_on_uuid ON public.auctions USING btree (uuid);


--
-- Name: index_autobiders_on_domain_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_autobiders_on_domain_name ON public.autobiders USING btree (domain_name);


--
-- Name: index_autobiders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_autobiders_on_user_id ON public.autobiders USING btree (user_id);


--
-- Name: index_bank_transactions_on_bank_statement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bank_transactions_on_bank_statement_id ON public.bank_transactions USING btree (bank_statement_id);


--
-- Name: index_bans_on_domain_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bans_on_domain_name ON public.bans USING btree (domain_name);


--
-- Name: index_bans_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bans_on_invoice_id ON public.bans USING btree (invoice_id);


--
-- Name: index_bans_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bans_on_user_id ON public.bans USING btree (user_id);


--
-- Name: index_billing_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_billing_profiles_on_user_id ON public.billing_profiles USING btree (user_id);


--
-- Name: index_billing_profiles_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_billing_profiles_on_uuid ON public.billing_profiles USING btree (uuid);


--
-- Name: index_billing_profiles_on_vat_code_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_billing_profiles_on_vat_code_and_user_id ON public.billing_profiles USING btree (vat_code, user_id);


--
-- Name: index_directo_customers_on_customer_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_directo_customers_on_customer_code ON public.directo_customers USING btree (customer_code);


--
-- Name: index_directo_customers_on_vat_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_directo_customers_on_vat_number ON public.directo_customers USING btree (vat_number);


--
-- Name: index_domain_participate_auctions_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_domain_participate_auctions_on_auction_id ON public.domain_participate_auctions USING btree (auction_id);


--
-- Name: index_domain_participate_auctions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_domain_participate_auctions_on_user_id ON public.domain_participate_auctions USING btree (user_id);


--
-- Name: index_invoice_items_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoice_items_on_invoice_id ON public.invoice_items USING btree (invoice_id);


--
-- Name: index_invoice_items_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invoice_items_on_uuid ON public.invoice_items USING btree (uuid);


--
-- Name: index_invoice_payment_orders_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoice_payment_orders_on_invoice_id ON public.invoice_payment_orders USING btree (invoice_id);


--
-- Name: index_invoice_payment_orders_on_payment_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoice_payment_orders_on_payment_order_id ON public.invoice_payment_orders USING btree (payment_order_id);


--
-- Name: index_invoices_on_billing_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_billing_profile_id ON public.invoices USING btree (billing_profile_id);


--
-- Name: index_invoices_on_paid_with_payment_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_paid_with_payment_order_id ON public.invoices USING btree (paid_with_payment_order_id);


--
-- Name: index_invoices_on_result_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_result_id ON public.invoices USING btree (result_id);


--
-- Name: index_invoices_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_user_id ON public.invoices USING btree (user_id);


--
-- Name: index_invoices_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invoices_on_uuid ON public.invoices USING btree (uuid);


--
-- Name: index_noticed_events_on_record; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_noticed_events_on_record ON public.noticed_events USING btree (record_type, record_id);


--
-- Name: index_noticed_notifications_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_noticed_notifications_on_event_id ON public.noticed_notifications USING btree (event_id);


--
-- Name: index_noticed_notifications_on_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_noticed_notifications_on_recipient ON public.noticed_notifications USING btree (recipient_type, recipient_id);


--
-- Name: index_notifications_on_read_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_read_at ON public.notifications USING btree (read_at);


--
-- Name: index_notifications_on_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_recipient ON public.notifications USING btree (recipient_type, recipient_id);


--
-- Name: index_offers_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_auction_id ON public.offers USING btree (auction_id);


--
-- Name: index_offers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_user_id ON public.offers USING btree (user_id);


--
-- Name: index_offers_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_offers_on_uuid ON public.offers USING btree (uuid);


--
-- Name: index_payment_orders_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_orders_on_invoice_id ON public.payment_orders USING btree (invoice_id);


--
-- Name: index_payment_orders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_orders_on_user_id ON public.payment_orders USING btree (user_id);


--
-- Name: index_payment_orders_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_payment_orders_on_uuid ON public.payment_orders USING btree (uuid);


--
-- Name: index_results_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_auction_id ON public.results USING btree (auction_id);


--
-- Name: index_results_on_last_remote_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_last_remote_status ON public.results USING btree (last_remote_status);


--
-- Name: index_results_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_offer_id ON public.results USING btree (offer_id);


--
-- Name: index_results_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_user_id ON public.results USING btree (user_id);


--
-- Name: index_results_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_results_on_uuid ON public.results USING btree (uuid);


--
-- Name: index_settings_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_settings_on_code ON public.settings USING btree (code);


--
-- Name: index_statistics_report_auctions_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistics_report_auctions_on_id ON public.statistics_report_auctions USING btree (id);


--
-- Name: index_statistics_report_invoices_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistics_report_invoices_on_id ON public.statistics_report_invoices USING btree (id);


--
-- Name: index_statistics_report_results_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistics_report_results_on_id ON public.statistics_report_results USING btree (id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_jti; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_jti ON public.users USING btree (jti);


--
-- Name: index_users_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_provider_and_uid ON public.users USING btree (provider, uid);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_uuid ON public.users USING btree (uuid);


--
-- Name: index_webpush_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_webpush_subscriptions_on_user_id ON public.webpush_subscriptions USING btree (user_id);


--
-- Name: index_wishlist_items_on_domain_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wishlist_items_on_domain_name ON public.wishlist_items USING btree (domain_name);


--
-- Name: users_by_identity_code_and_country; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_by_identity_code_and_country ON public.users USING btree (alpha_two_country_code, identity_code) WHERE (((alpha_two_country_code)::text = 'EE'::text) AND (identity_code IS NOT NULL) AND ((identity_code)::text <> ''::text));


--
-- Name: auctions process_auction_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_auction_audit AFTER INSERT OR DELETE OR UPDATE ON public.auctions FOR EACH ROW EXECUTE FUNCTION public.process_auction_audit();


--
-- Name: bans process_ban_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_ban_audit AFTER INSERT OR DELETE OR UPDATE ON public.bans FOR EACH ROW EXECUTE FUNCTION public.process_ban_audit();


--
-- Name: billing_profiles process_billing_profile_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_billing_profile_audit AFTER INSERT OR DELETE OR UPDATE ON public.billing_profiles FOR EACH ROW EXECUTE FUNCTION public.process_billing_profile_audit();


--
-- Name: invoices process_invoice_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_invoice_audit AFTER INSERT OR DELETE OR UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.process_invoice_audit();


--
-- Name: invoice_items process_invoice_item_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_invoice_item_audit AFTER INSERT OR DELETE OR UPDATE ON public.invoice_items FOR EACH ROW EXECUTE FUNCTION public.process_invoice_item_audit();


--
-- Name: invoice_payment_orders process_invoice_payment_order_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_invoice_payment_order_audit AFTER INSERT OR DELETE OR UPDATE ON public.invoice_payment_orders FOR EACH ROW EXECUTE FUNCTION public.process_invoice_payment_order_audit();


--
-- Name: offers process_offer_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_offer_audit AFTER INSERT OR DELETE OR UPDATE ON public.offers FOR EACH ROW EXECUTE FUNCTION public.process_offer_audit();


--
-- Name: payment_orders process_payment_order_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_payment_order_audit AFTER INSERT OR DELETE OR UPDATE ON public.payment_orders FOR EACH ROW EXECUTE FUNCTION public.process_payment_order_audit();


--
-- Name: results process_result_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_result_audit AFTER INSERT OR DELETE OR UPDATE ON public.results FOR EACH ROW EXECUTE FUNCTION public.process_result_audit();


--
-- Name: settings process_setting_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_setting_audit AFTER INSERT OR DELETE OR UPDATE ON public.settings FOR EACH ROW EXECUTE FUNCTION public.process_setting_audit();


--
-- Name: users process_user_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_user_audit AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.process_user_audit();


--
-- Name: wishlist_items process_wishlist_item_audit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER process_wishlist_item_audit AFTER INSERT OR DELETE OR UPDATE ON public.wishlist_items FOR EACH ROW EXECUTE FUNCTION public.process_wishlist_item_audit();


--
-- Name: bans fk_rails_070022cd76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans
    ADD CONSTRAINT fk_rails_070022cd76 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: invoice_items fk_rails_25bf3d2c5e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT fk_rails_25bf3d2c5e FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: invoices fk_rails_3d1522a0d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_rails_3d1522a0d8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: autobiders fk_rails_3d4f798ed7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autobiders
    ADD CONSTRAINT fk_rails_3d4f798ed7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: wishlist_items fk_rails_5c10acf6bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlist_items
    ADD CONSTRAINT fk_rails_5c10acf6bc FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payment_orders fk_rails_79beebc2e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_orders
    ADD CONSTRAINT fk_rails_79beebc2e9 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: results fk_rails_7f0d5a2cd6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_7f0d5a2cd6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: billing_profiles fk_rails_8fda547d9d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_profiles
    ADD CONSTRAINT fk_rails_8fda547d9d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: bans fk_rails_9c21645d6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bans
    ADD CONSTRAINT fk_rails_9c21645d6a FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: results fk_rails_9f5d06cf95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_9f5d06cf95 FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: offers fk_rails_bb5f3f4ecb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT fk_rails_bb5f3f4ecb FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: invoices fk_rails_d44c2f8d29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_rails_d44c2f8d29 FOREIGN KEY (result_id) REFERENCES public.results(id);


--
-- Name: offers fk_rails_e6095d6211; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT fk_rails_e6095d6211 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payment_orders fk_rails_f9dc5857c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_orders
    ADD CONSTRAINT fk_rails_f9dc5857c3 FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: invoices fk_rails_ff50c5defa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_rails_ff50c5defa FOREIGN KEY (billing_profile_id) REFERENCES public.billing_profiles(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20251104081848'),
('20251104081847'),
('20251003083614'),
('20240604124707'),
('20240603120701'),
('20240209111309'),
('20231222085647'),
('20231222074427'),
('20231116093310'),
('20231031122216'),
('20231031122202'),
('20231031092610'),
('20231013110924'),
('20231006095158'),
('20231002090548'),
('20230927114150'),
('20230925130405'),
('20230721102651'),
('20230705192353'),
('20230607092953'),
('20230419114412'),
('20230309094132'),
('20230227085236'),
('20230124110241'),
('20230118124747'),
('20221017133559'),
('20221007082951'),
('20221006094111'),
('20221005105336'),
('20221003065216'),
('20220617123124'),
('20220606110658'),
('20220601052131'),
('20220527064738'),
('20220426082102'),
('20220425103701'),
('20220422095751'),
('20220422094556'),
('20220422094307'),
('20220419091123'),
('20220214130432'),
('20220214124251'),
('20200212081434'),
('20200206090106'),
('20200205092158'),
('20200115145246'),
('20200110135003'),
('20191220131845'),
('20191213082941'),
('20191209085222'),
('20191209083000'),
('20191209073454'),
('20191121162323'),
('20191028092316'),
('20191025092912'),
('20191022125038'),
('20191008124157'),
('20190915171050'),
('20190831131431'),
('20190722100652'),
('20190521071232'),
('20190517073827'),
('20190517063450'),
('20190424070710'),
('20190423092327'),
('20190405111702'),
('20190405081018'),
('20190405065151'),
('20190404125619'),
('20190404082458'),
('20190329172510'),
('20190329153430'),
('20190329153135'),
('20190327085138'),
('20190320192421'),
('20190313140756'),
('20190313124938'),
('20190306112247'),
('20190228125654'),
('20190221142432'),
('20190218144713'),
('20190218144230'),
('20190213115909'),
('20190213104841'),
('20190212075230'),
('20190212071303'),
('20190211182633'),
('20190211181127'),
('20190211175323'),
('20190211174035'),
('20190211173932'),
('20190211105123'),
('20190208132025'),
('20190208130148'),
('20190204093252'),
('20190131133558'),
('20190129085543'),
('20181217134832'),
('20181217105817'),
('20181213125519'),
('20181213100947'),
('20181213100723'),
('20181212075049'),
('20181211175329'),
('20181211175012'),
('20181211085640'),
('20181211081031'),
('20181206134245'),
('20181205134446'),
('20181204114134'),
('20181204094329'),
('20181129113446'),
('20181122135839'),
('20181122134301'),
('20181121120238'),
('20181121091758'),
('20181120121027'),
('20181120120117'),
('20181120093105'),
('20181119114425'),
('20181119091242'),
('20181115122806'),
('20181115083934'),
('20181114142500'),
('20181107113525'),
('20181107084751'),
('20181106075840'),
('20181102132927'),
('20181102080251'),
('20181030075851'),
('20181029121254'),
('20181023125230'),
('20181023121607'),
('20181023103316'),
('20181022095409'),
('20181018064054'),
('20181017122905'),
('20181017114957'),
('20181016124017'),
('20181011082830'),
('20181011080931'),
('20181009104026'),
('20181008133152'),
('20181008124201'),
('20181001094917'),
('20180928060715'),
('20180921084531'),
('20180919104523'),
('20180907083511'),
('20180829130641');

