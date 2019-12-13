/* pgmigrate-encoding: utf-8 */

create user shop with password 'shop';
create user web with password 'web';
create user module with password 'module';

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 11.4

--
-- Name: admin; Type: SCHEMA; Schema: -; Owner: shop
--

CREATE SCHEMA admin;


ALTER SCHEMA admin OWNER TO shop;

--
-- Name: api; Type: SCHEMA; Schema: -; Owner: shop
--

CREATE SCHEMA api;


ALTER SCHEMA api OWNER TO shop;

--
-- Name: core; Type: SCHEMA; Schema: -; Owner: migrator
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO migrator;

--
-- Name: i18n; Type: SCHEMA; Schema: -; Owner: shop
--

CREATE SCHEMA i18n;


ALTER SCHEMA i18n OWNER TO shop;

--
-- Name: module; Type: SCHEMA; Schema: -; Owner: shop
--

CREATE SCHEMA module;


ALTER SCHEMA module OWNER TO shop;

--
-- Name: shop; Type: SCHEMA; Schema: -; Owner: shop
--

CREATE SCHEMA shop;


ALTER SCHEMA shop OWNER TO shop;

--
-- Name: stat; Type: SCHEMA; Schema: -; Owner: shop
--

CREATE SCHEMA stat;


ALTER SCHEMA stat OWNER TO shop;

--
-- Name: web; Type: SCHEMA; Schema: -; Owner: shop
--

CREATE SCHEMA web;


ALTER SCHEMA web OWNER TO shop;

--
-- Name: plpythonu; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: migrator
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpythonu;


ALTER PROCEDURAL LANGUAGE plpythonu OWNER TO migrator;

--
-- Name: t_currency; Type: TYPE; Schema: shop; Owner: shop
--

CREATE TYPE shop.t_currency AS ENUM (
    'rub',
    'usd',
    'eur'
);


ALTER TYPE shop.t_currency OWNER TO shop;

--
-- Name: t_order_status; Type: TYPE; Schema: shop; Owner: shop
--

CREATE TYPE shop.t_order_status AS ENUM (
    'new',
    'confirmed',
    'paid',
    'closed',
    'cancelled'
);


ALTER TYPE shop.t_order_status OWNER TO shop;

--
-- Name: t_payment_status; Type: TYPE; Schema: shop; Owner: shop
--

CREATE TYPE shop.t_payment_status AS ENUM (
    'new',
    'success',
    'error'
);


ALTER TYPE shop.t_payment_status OWNER TO shop;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: banner; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.banner (
    id integer NOT NULL,
    image_url character varying(255) NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_visible boolean DEFAULT true NOT NULL,
    href character varying(255),
    title character varying(255)
);


ALTER TABLE shop.banner OWNER TO shop;

--
-- Name: COLUMN banner.title; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.banner.title IS 'Caption for banner';

--
-- Name: banner_image_seq; Type: SEQUENCE; Schema: admin; Owner: migrator
--

CREATE SEQUENCE admin.banner_image_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin.banner_image_seq OWNER TO migrator;

--
-- Name: menu; Type: TABLE; Schema: admin; Owner: shop
--

CREATE TABLE admin.menu (
    id integer NOT NULL,
    title character varying(126),
    url character varying(126) NOT NULL,
    parent_id integer,
    priority integer DEFAULT 0 NOT NULL
);


ALTER TABLE admin.menu OWNER TO shop;

--
-- Name: menu_id_seq; Type: SEQUENCE; Schema: admin; Owner: shop
--

CREATE SEQUENCE admin.menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin.menu_id_seq OWNER TO shop;

--
-- Name: menu_id_seq; Type: SEQUENCE OWNED BY; Schema: admin; Owner: shop
--



--
-- Name: token; Type: TABLE; Schema: api; Owner: shop
--

CREATE TABLE api.token (
    id integer NOT NULL,
    token character(32) NOT NULL,
    dt_created timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_expire timestamp(0) with time zone DEFAULT (now() + '1 year'::interval) NOT NULL
);


ALTER TABLE api.token OWNER TO shop;

--
-- Name: token_id_seq; Type: SEQUENCE; Schema: api; Owner: shop
--

CREATE SEQUENCE api.token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE api.token_id_seq OWNER TO shop;

--
-- Name: token_id_seq; Type: SEQUENCE OWNED BY; Schema: api; Owner: shop
--



--
-- Name: translation; Type: TABLE; Schema: i18n; Owner: shop
--

CREATE TABLE i18n.translation (
    id integer NOT NULL,
    original text NOT NULL,
    translation text,
    translator character varying(126),
    dt_added timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_translated timestamp(0) with time zone
);


ALTER TABLE i18n.translation OWNER TO shop;

--
-- Name: translation_column; Type: TABLE; Schema: i18n; Owner: shop
--

CREATE TABLE i18n.translation_column (
    id integer NOT NULL,
    table_name character varying(126),
    original_column character varying(126),
    translated_column character varying(126)
);


ALTER TABLE i18n.translation_column OWNER TO shop;

--
-- Name: TABLE translation_column; Type: COMMENT; Schema: i18n; Owner: shop
--

COMMENT ON TABLE i18n.translation_column IS 'Columns for translation';


--
-- Name: translation_column_id_seq; Type: SEQUENCE; Schema: i18n; Owner: shop
--

CREATE SEQUENCE i18n.translation_column_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE i18n.translation_column_id_seq OWNER TO shop;

--
-- Name: translation_column_id_seq; Type: SEQUENCE OWNED BY; Schema: i18n; Owner: shop
--



--
-- Name: translation_id_seq; Type: SEQUENCE; Schema: i18n; Owner: shop
--

CREATE SEQUENCE i18n.translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE i18n.translation_id_seq OWNER TO shop;

--
-- Name: translation_id_seq; Type: SEQUENCE OWNED BY; Schema: i18n; Owner: shop
--



--
-- Name: translation_manual; Type: TABLE; Schema: i18n; Owner: shop
--

CREATE TABLE i18n.translation_manual (
    id integer DEFAULT nextval('i18n.translation_id_seq'::regclass) NOT NULL,
    original text NOT NULL,
    translation text,
    translator character varying(126),
    dt_added timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_translated timestamp(0) with time zone
);


ALTER TABLE i18n.translation_manual OWNER TO shop;

--
-- Name: config; Type: TABLE; Schema: module; Owner: shop
--

CREATE TABLE module.config (
    id integer NOT NULL,
    module character varying(126) NOT NULL,
    config json,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE module.config OWNER TO shop;

--
-- Name: COLUMN config.is_enabled; Type: COMMENT; Schema: module; Owner: shop
--

COMMENT ON COLUMN module.config.is_enabled IS 'Is module enabled';


--
-- Name: config_id_seq; Type: SEQUENCE; Schema: module; Owner: shop
--

CREATE SEQUENCE module.config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module.config_id_seq OWNER TO shop;

--
-- Name: config_id_seq; Type: SEQUENCE OWNED BY; Schema: module; Owner: shop
--



--
-- Name: module_category; Type: TABLE; Schema: module; Owner: shop
--

CREATE TABLE module.module_category (
    id integer NOT NULL,
    module character varying NOT NULL,
    category_id integer NOT NULL,
    is_exported boolean DEFAULT true NOT NULL
);


ALTER TABLE module.module_category OWNER TO shop;

--
-- Name: TABLE module_category; Type: COMMENT; Schema: module; Owner: shop
--

COMMENT ON TABLE module.module_category IS 'Category export settings for export modules';


--
-- Name: module_category_id_seq; Type: SEQUENCE; Schema: module; Owner: shop
--

CREATE SEQUENCE module.module_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module.module_category_id_seq OWNER TO shop;

--
-- Name: module_category_id_seq; Type: SEQUENCE OWNED BY; Schema: module; Owner: shop
--



--
-- Name: module_product; Type: TABLE; Schema: module; Owner: shop
--

CREATE TABLE module.module_product (
    id integer NOT NULL,
    module character varying NOT NULL,
    product_id integer NOT NULL,
    is_exported boolean DEFAULT true NOT NULL
);


ALTER TABLE module.module_product OWNER TO shop;

--
-- Name: TABLE module_product; Type: COMMENT; Schema: module; Owner: shop
--

COMMENT ON TABLE module.module_product IS 'Product export settings for export modules';


--
-- Name: module_product_id_seq; Type: SEQUENCE; Schema: module; Owner: shop
--

CREATE SEQUENCE module.module_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module.module_product_id_seq OWNER TO shop;

--
-- Name: module_product_id_seq; Type: SEQUENCE OWNED BY; Schema: module; Owner: shop
--



--
-- Name: attribute; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.attribute (
    id integer NOT NULL,
    attribute_category_id integer,
    in_product_card boolean DEFAULT false NOT NULL,
    name text,
    description text,
    priority integer DEFAULT 0 NOT NULL
);


ALTER TABLE shop.attribute OWNER TO shop;

--
-- Name: attribute_category; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.attribute_category (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    priority integer DEFAULT 0 NOT NULL
);


ALTER TABLE shop.attribute_category OWNER TO shop;

--
-- Name: attribute_category_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.attribute_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.attribute_category_id_seq OWNER TO shop;

--
-- Name: attribute_category_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: attribute_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.attribute_id_seq OWNER TO shop;

--
-- Name: attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: attribute_value; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.attribute_value (
    id integer NOT NULL,
    product_id integer NOT NULL,
    attribute_id integer NOT NULL,
    value text
);


ALTER TABLE shop.attribute_value OWNER TO shop;

--
-- Name: attribute_value_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.attribute_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.attribute_value_id_seq OWNER TO shop;

--
-- Name: attribute_value_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: banner_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.banner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.banner_id_seq OWNER TO shop;

--
-- Name: banner_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: black_list; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.black_list (
    id integer NOT NULL,
    dt_added timestamp(0) without time zone DEFAULT now() NOT NULL,
    ip inet NOT NULL,
    is_auto boolean DEFAULT false NOT NULL
);


ALTER TABLE shop.black_list OWNER TO shop;

--
-- Name: TABLE black_list; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON TABLE shop.black_list IS 'Blask list, customers cannot make orders from these ips';


--
-- Name: black_list_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.black_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.black_list_id_seq OWNER TO shop;

--
-- Name: black_list_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: cart; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.cart (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    dt_added timestamp(0) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE shop.cart OWNER TO shop;

--
-- Name: TABLE cart; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON TABLE shop.cart IS 'Корзина';


--
-- Name: cart_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.cart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.cart_id_seq OWNER TO shop;

--
-- Name: cart_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: category_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.category_id_seq OWNER TO shop;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: config; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.config (
    parameter character varying(126) NOT NULL,
    value text
);


ALTER TABLE shop.config OWNER TO shop;

--
-- Name: generate_customer_secret(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.generate_customer_secret() RETURNS character
    LANGUAGE sql
    AS $$
    select array_to_string(array(select substr('0123456789abcdef', trunc(random() * 16)::integer + 1, 1) from generate_series(1, 32)), '');
$$;


ALTER FUNCTION web.generate_customer_secret() OWNER TO shop;

--
-- Name: customer; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.customer (
    id integer NOT NULL,
    secret character(32) DEFAULT web.generate_customer_secret() NOT NULL,
    dt_created timestamp(0) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE shop.customer OWNER TO shop;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.customer_id_seq OWNER TO shop;

--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: customer_order; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.customer_order (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    dt_create timestamp(0) with time zone DEFAULT now() NOT NULL,
    amount numeric(8,2),
    status shop.t_order_status DEFAULT 'new'::shop.t_order_status NOT NULL,
    token character(32) DEFAULT web.generate_customer_secret() NOT NULL,
    email character varying(126) NOT NULL,
    phone character varying(20) NOT NULL,
    name character varying(126),
    city character varying(126) NOT NULL,
    address character varying(1000) NOT NULL,
    ip inet NOT NULL,
    user_agent character varying(1000),
    delivery_cost numeric(8,2) DEFAULT 0 NOT NULL,
    delivery_code character varying(126),
    delivery_name character varying(255),
    last_name character varying(126),
    patronymic_name character varying(126),
    payment_method_id integer
);


ALTER TABLE shop.customer_order OWNER TO shop;

--
-- Name: COLUMN customer_order.delivery_code; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.customer_order.delivery_code IS 'Unique code of delivery service';


--
-- Name: COLUMN customer_order.delivery_name; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.customer_order.delivery_name IS 'Full name of delivery service';


--
-- Name: COLUMN customer_order.last_name; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.customer_order.last_name IS 'Patronymic name';


--
-- Name: customer_order_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.customer_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.customer_order_id_seq OWNER TO shop;

--
-- Name: customer_order_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: feedback; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.feedback (
    id integer NOT NULL,
    name character varying(126),
    dt_added timestamp(0) with time zone DEFAULT now() NOT NULL,
    rate smallint DEFAULT 5 NOT NULL,
    message text,
    ip inet,
    is_published boolean DEFAULT false NOT NULL
);


ALTER TABLE shop.feedback OWNER TO shop;

--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.feedback_id_seq OWNER TO shop;

--
-- Name: feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: filter; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.filter (
    id integer NOT NULL,
    attribute_id integer NOT NULL,
    name text NOT NULL,
    operator character varying(126),
    is_enabled boolean DEFAULT true NOT NULL,
    distinct_values text[],
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE shop.filter OWNER TO shop;

--
-- Name: filter_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.filter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.filter_id_seq OWNER TO shop;

--
-- Name: filter_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: filter_value; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.filter_value (
    id integer NOT NULL,
    filter_id integer NOT NULL,
    distinct_value text,
    expression text
);


ALTER TABLE shop.filter_value OWNER TO shop;

--
-- Name: filter_value_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.filter_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.filter_value_id_seq OWNER TO shop;

--
-- Name: filter_value_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: infopage; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.infopage (
    id integer NOT NULL,
    url character varying(126),
    views integer DEFAULT 0 NOT NULL,
    code text
);


ALTER TABLE shop.infopage OWNER TO shop;

--
-- Name: infopage_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.infopage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.infopage_id_seq OWNER TO shop;

--
-- Name: infopage_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: manufacturer; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.manufacturer (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE shop.manufacturer OWNER TO shop;

--
-- Name: manufacturer_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.manufacturer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.manufacturer_id_seq OWNER TO shop;

--
-- Name: manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: menu; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.menu (
    id integer NOT NULL,
    title character varying(126) NOT NULL,
    url character varying(126) NOT NULL,
    parent_id integer,
    "position" character varying(126),
    priority integer DEFAULT 0 NOT NULL
);


ALTER TABLE shop.menu OWNER TO shop;

--
-- Name: menu_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.menu_id_seq OWNER TO shop;

--
-- Name: menu_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: order_item; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.order_item (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    price numeric(8,2) NOT NULL,
    quantity integer NOT NULL,
    amount numeric(8,2) NOT NULL
);


ALTER TABLE shop.order_item OWNER TO shop;

--
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.order_item_id_seq OWNER TO shop;

--
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: payment; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.payment (
    id integer NOT NULL,
    dt_added timestamp(0) with time zone DEFAULT now() NOT NULL,
    dt_processed timestamp(0) with time zone,
    status shop.t_payment_status DEFAULT 'new'::shop.t_payment_status NOT NULL,
    service character varying(126) NOT NULL,
    order_id integer NOT NULL,
    ip inet NOT NULL,
    currency shop.t_currency NOT NULL,
    amount numeric(8,2),
    external_id character varying(255)
);


ALTER TABLE shop.payment OWNER TO shop;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.payment_id_seq OWNER TO shop;

--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: payment_method; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.payment_method (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE shop.payment_method OWNER TO shop;

--
-- Name: payment_method_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.payment_method_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.payment_method_id_seq OWNER TO shop;

--
-- Name: payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--

--
-- Name: get_current_user(); Type: FUNCTION; Schema: core; Owner: shop
--

CREATE FUNCTION core.get_current_user() RETURNS integer
    LANGUAGE plpythonu STABLE SECURITY DEFINER
    AS $$
    return GD.get('user_id')
$$;


ALTER FUNCTION core.get_current_user() OWNER TO shop;


--
-- Name: product; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product (
    id integer NOT NULL,
    sku text,
    name text NOT NULL,
    url text,
    manufacturer_id integer,
    price numeric(8,2),
    available integer DEFAULT 0 NOT NULL,
    is_visible boolean DEFAULT false NOT NULL,
    viewed integer DEFAULT 0 NOT NULL,
    dt_added timestamp(0) without time zone DEFAULT now() NOT NULL,
    sef_name character varying(126),
    previous_price numeric,
    create_user_id integer DEFAULT core.get_current_user(),
    update_user_id integer DEFAULT core.get_current_user(),
    path integer[],
    dt_deleted timestamp(0) without time zone,
    gtin character varying(255),
    is_exported boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL
);


ALTER TABLE shop.product OWNER TO shop;

--
-- Name: COLUMN product.available; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.available IS 'Product units available';


--
-- Name: COLUMN product.is_visible; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.is_visible IS 'Toggle product visibility';


--
-- Name: COLUMN product.viewed; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.viewed IS 'Product view count';


--
-- Name: COLUMN product.previous_price; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.previous_price IS 'Previous product price';


--
-- Name: COLUMN product.create_user_id; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.create_user_id IS 'User who created a product';


--
-- Name: COLUMN product.update_user_id; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.update_user_id IS 'User who was last who updated a product';


--
-- Name: COLUMN product.path; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.path IS 'Category path for product';


--
-- Name: COLUMN product.dt_deleted; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.dt_deleted IS 'Product deletion date and time';


--
-- Name: COLUMN product.gtin; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.gtin IS 'Global Table Item Number: EAN, UPC, ISBN, etc.';


--
-- Name: COLUMN product.is_exported; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.is_exported IS 'If false, product will not be exported by export module despite of the other settings';


--
-- Name: COLUMN product.sort_order; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.product.sort_order IS 'Sort order';


--
-- Name: product_category; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product_category (
    id integer NOT NULL,
    product_id integer NOT NULL,
    category_id integer NOT NULL,
    date_time timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE shop.product_category OWNER TO shop;

--
-- Name: product_category_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_category_id_seq OWNER TO shop;

--
-- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_description; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product_description (
    id integer NOT NULL,
    product_id integer NOT NULL,
    description text NOT NULL
);


ALTER TABLE shop.product_description OWNER TO shop;

--
-- Name: product_description_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_description_id_seq OWNER TO shop;

--
-- Name: product_description_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_diagram; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product_diagram (
    id integer NOT NULL,
    product_id integer NOT NULL,
    diagram character varying(126),
    lookup_no smallint
);


ALTER TABLE shop.product_diagram OWNER TO shop;

--
-- Name: product_diagram_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_diagram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_diagram_id_seq OWNER TO shop;

--
-- Name: product_diagram_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_group; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product_group (
    id integer NOT NULL,
    mnemonic character varying(126) NOT NULL,
    name character varying(126)
);


ALTER TABLE shop.product_group OWNER TO shop;

--
-- Name: product_group_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_group_id_seq OWNER TO shop;

--
-- Name: product_group_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_id_seq OWNER TO shop;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_image; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product_image (
    id integer NOT NULL,
    product_id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    url text NOT NULL,
    dt_added timestamp(0) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE shop.product_image OWNER TO shop;

--
-- Name: product_image_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_image_id_seq OWNER TO shop;

--
-- Name: product_image_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_option; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product_option (
    id integer NOT NULL,
    product_id integer NOT NULL,
    value text NOT NULL
);


ALTER TABLE shop.product_option OWNER TO shop;

--
-- Name: product_option_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_option_id_seq OWNER TO shop;

--
-- Name: product_option_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_relation; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.product_relation (
    id integer NOT NULL,
    parent_id integer NOT NULL,
    child_id integer NOT NULL,
    relation_id integer NOT NULL
);


ALTER TABLE shop.product_relation OWNER TO shop;

--
-- Name: TABLE product_relation; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON TABLE shop.product_relation IS 'Relations between products';


--
-- Name: product_relation_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.product_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.product_relation_id_seq OWNER TO shop;

--
-- Name: product_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: products_in_group; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.products_in_group (
    id integer NOT NULL,
    product_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE shop.products_in_group OWNER TO shop;

--
-- Name: products_in_group_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.products_in_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.products_in_group_id_seq OWNER TO shop;

--
-- Name: products_in_group_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: relation; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.relation (
    id integer NOT NULL,
    mnemonic character varying(126) NOT NULL,
    name character varying(126) NOT NULL,
    description text
);


ALTER TABLE shop.relation OWNER TO shop;

--
-- Name: COLUMN relation.mnemonic; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.relation.mnemonic IS 'Mnemonic name for relation, in english. All functions should refer to this unique value instead of if';


--
-- Name: relation_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.relation_id_seq OWNER TO shop;

--
-- Name: relation_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: snippet_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.snippet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.snippet_id_seq OWNER TO shop;

--
-- Name: snippet_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: system_user; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.system_user (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    password character(32) NOT NULL,
    create_date timestamp(0) with time zone DEFAULT now() NOT NULL,
    name character varying(126),
    is_admin boolean DEFAULT false NOT NULL,
    email character varying(255),
    user_role character varying(100)
);


ALTER TABLE shop.system_user OWNER TO shop;

--
-- Name: system_user_id_seq; Type: SEQUENCE; Schema: shop; Owner: shop
--

CREATE SEQUENCE shop.system_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shop.system_user_id_seq OWNER TO shop;

--
-- Name: system_user_id_seq; Type: SEQUENCE OWNED BY; Schema: shop; Owner: shop
--



--
-- Name: product_available_history; Type: TABLE; Schema: stat; Owner: shop
--

CREATE TABLE stat.product_available_history (
    id integer NOT NULL,
    product_id integer NOT NULL,
    dt_from timestamp(0) with time zone DEFAULT now() NOT NULL,
    available integer,
    user_id integer DEFAULT core.get_current_user()
);


ALTER TABLE stat.product_available_history OWNER TO shop;

--
-- Name: TABLE product_available_history; Type: COMMENT; Schema: stat; Owner: shop
--

COMMENT ON TABLE stat.product_available_history IS 'Product available history';


--
-- Name: COLUMN product_available_history.user_id; Type: COMMENT; Schema: stat; Owner: shop
--

COMMENT ON COLUMN stat.product_available_history.user_id IS 'User ID';


--
-- Name: product_available_history_id_seq; Type: SEQUENCE; Schema: stat; Owner: shop
--

CREATE SEQUENCE stat.product_available_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stat.product_available_history_id_seq OWNER TO shop;

--
-- Name: product_available_history_id_seq; Type: SEQUENCE OWNED BY; Schema: stat; Owner: shop
--



--
-- Name: product_price_history; Type: TABLE; Schema: stat; Owner: shop
--

CREATE TABLE stat.product_price_history (
    id integer NOT NULL,
    product_id integer NOT NULL,
    dt_from timestamp(0) with time zone DEFAULT now() NOT NULL,
    price numeric(8,2),
    user_id integer DEFAULT core.get_current_user()
);


ALTER TABLE stat.product_price_history OWNER TO shop;

--
-- Name: TABLE product_price_history; Type: COMMENT; Schema: stat; Owner: shop
--

COMMENT ON TABLE stat.product_price_history IS 'Product price history';


--
-- Name: COLUMN product_price_history.user_id; Type: COMMENT; Schema: stat; Owner: shop
--

COMMENT ON COLUMN stat.product_price_history.user_id IS 'User ID';


--
-- Name: product_price_history_id_seq; Type: SEQUENCE; Schema: stat; Owner: shop
--

CREATE SEQUENCE stat.product_price_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stat.product_price_history_id_seq OWNER TO shop;

--
-- Name: product_price_history_id_seq; Type: SEQUENCE OWNED BY; Schema: stat; Owner: shop
--



--
-- Name: product_stat; Type: TABLE; Schema: stat; Owner: shop
--

CREATE TABLE stat.product_stat (
    id integer NOT NULL,
    dt date DEFAULT ('now'::text)::date NOT NULL,
    product_id integer NOT NULL,
    viewed integer DEFAULT 0 NOT NULL,
    added_to_cart integer DEFAULT 0 NOT NULL,
    ordered integer DEFAULT 0 NOT NULL
);


ALTER TABLE stat.product_stat OWNER TO shop;

--
-- Name: product_stat_id_seq; Type: SEQUENCE; Schema: stat; Owner: shop
--

CREATE SEQUENCE stat.product_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stat.product_stat_id_seq OWNER TO shop;

--
-- Name: product_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: stat; Owner: shop
--



--
-- Name: menu id; Type: DEFAULT; Schema: admin; Owner: shop
--



--
-- Name: token id; Type: DEFAULT; Schema: api; Owner: shop
--



--
-- Name: translation id; Type: DEFAULT; Schema: i18n; Owner: shop
--



--
-- Name: translation_column id; Type: DEFAULT; Schema: i18n; Owner: shop
--



--
-- Name: config id; Type: DEFAULT; Schema: module; Owner: shop
--



--
-- Name: module_category id; Type: DEFAULT; Schema: module; Owner: shop
--



--
-- Name: module_product id; Type: DEFAULT; Schema: module; Owner: shop
--



--
-- Name: attribute id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: attribute_category id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: attribute_value id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: banner id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: black_list id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: cart id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: category id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: customer id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: customer_order id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: feedback id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: filter id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: filter_value id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: infopage id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: manufacturer id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: menu id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: order_item id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: payment id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: payment_method id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_category id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_description id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_diagram id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_group id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_image id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_option id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_relation id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: products_in_group id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: relation id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: snippet id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: system_user id; Type: DEFAULT; Schema: shop; Owner: shop
--



--
-- Name: product_available_history id; Type: DEFAULT; Schema: stat; Owner: shop
--



--
-- Name: product_price_history id; Type: DEFAULT; Schema: stat; Owner: shop
--



--
-- Name: product_stat id; Type: DEFAULT; Schema: stat; Owner: shop
--



--
-- Data for Name: menu; Type: TABLE DATA; Schema: admin; Owner: shop
--

INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (1, 'Заказы', '/admin/orders', NULL, 0);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (2, 'Товары', '/admin/products', NULL, 1);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (3, 'Переводы', '/admin/translation', NULL, 2);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (4, 'Категории', '/admin/categories', NULL, 3);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (5, 'Страницы', '/admin/infopages', NULL, 4);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (6, 'Добавить товар', '/admin/product', NULL, 10);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (7, 'Отправить статистику', '/admin/stat', NULL, 100);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (8, 'Баннеры', '/admin/banners', NULL, 1000);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (9, 'Виджеты', '/admin/snippets', NULL, 2000);
INSERT INTO admin.menu (id, title, url, parent_id, priority) VALUES (10, 'История цен', '/admin/price_history', NULL, 3000);


--
-- Data for Name: token; Type: TABLE DATA; Schema: api; Owner: shop
--

INSERT INTO api.token (id, token, dt_created, dt_expire) VALUES (1, '8c44548132aa16adfd953504e9b92db8', '2019-12-13 10:48:11+00', '2020-12-13 10:48:11+00');


--
-- Data for Name: translation; Type: TABLE DATA; Schema: i18n; Owner: shop
--



--
-- Data for Name: translation_column; Type: TABLE DATA; Schema: i18n; Owner: shop
--



--
-- Data for Name: translation_manual; Type: TABLE DATA; Schema: i18n; Owner: shop
--



--
-- Data for Name: config; Type: TABLE DATA; Schema: module; Owner: shop
--

INSERT INTO module.config (id, module, config, is_enabled) VALUES (1, 'ExportPriceRu', '{"token": ""}', true);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (2, 'ExportAportRu', '{"token": ""}', true);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (4, 'MailGun', '{"url": "https://api.mailgun.net/v3/***", "key": "key-***"}', true);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (5, 'ExportNadaviNet', '{"token": ""}', true);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (6, 'ExportMobiGuruRu', '{"token": ""}', true);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (7, 'DeliveryFixedPrice', '{"costs": [{"code": "ems", "cost": 960, "title": "Посылка EMS наложенным платежом", "priority": 0}, {"code": "post", "cost": "790", "title": "Посылка 1 класса наложенным платежом", "priority": 1}]}', true);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (3, 'RussianPost', '{"sender_post_code": "000000", "object_code": "47030", "pack": "40", "margin": 200}', false);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (8, 'ExportAvitoRu', '{"token": "", "contact_phone": ""}', true);
INSERT INTO module.config (id, module, config, is_enabled) VALUES (9, 'ExportPriceOkRu', '{"token": ""}', true);

--
-- Data for Name: config; Type: TABLE DATA; Schema: shop; Owner: shop
--

INSERT INTO shop.config (parameter, value) VALUES ('Address', 'Test address');
INSERT INTO shop.config (parameter, value) VALUES ('ThemeCSS', 'ml.css');


--
-- Data for Name: menu; Type: TABLE DATA; Schema: shop; Owner: shop
--

INSERT INTO shop.menu (id, title, url, parent_id, "position", priority) VALUES (11, 'О нас', '/about', NULL, 'top', 0);
INSERT INTO shop.menu (id, title, url, parent_id, "position", priority) VALUES (12, 'Гарантия', '/warranty', NULL, 'top', 1);
INSERT INTO shop.menu (id, title, url, parent_id, "position", priority) VALUES (13, 'Доставка', '/service', NULL, 'top', 3);


--
-- Data for Name: product_group; Type: TABLE DATA; Schema: shop; Owner: shop
--

INSERT INTO shop.product_group (id, mnemonic, name) VALUES (1, 'popular', 'Полулярные товары');


--
-- Data for Name: relation; Type: TABLE DATA; Schema: shop; Owner: shop
--

INSERT INTO shop.relation (id, mnemonic, name, description) VALUES (1, 'accessory', 'Аксессуар', 'Товар 2 является аксессуаром для товара 1');


--
-- Name: banner_image_seq; Type: SEQUENCE SET; Schema: admin; Owner: migrator
--

SELECT pg_catalog.setval('admin.banner_image_seq', 1, false);


--
-- Name: menu_id_seq; Type: SEQUENCE SET; Schema: admin; Owner: shop
--

SELECT pg_catalog.setval('admin.menu_id_seq', 10, true);


--
-- Name: token_id_seq; Type: SEQUENCE SET; Schema: api; Owner: shop
--

SELECT pg_catalog.setval('api.token_id_seq', 1, true);


--
-- Name: translation_column_id_seq; Type: SEQUENCE SET; Schema: i18n; Owner: shop
--

SELECT pg_catalog.setval('i18n.translation_column_id_seq', 1, false);


--
-- Name: translation_id_seq; Type: SEQUENCE SET; Schema: i18n; Owner: shop
--

SELECT pg_catalog.setval('i18n.translation_id_seq', 1, false);


--
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: module; Owner: shop
--

SELECT pg_catalog.setval('module.config_id_seq', 9, true);


--
-- Name: module_category_id_seq; Type: SEQUENCE SET; Schema: module; Owner: shop
--

SELECT pg_catalog.setval('module.module_category_id_seq', 1, false);


--
-- Name: module_product_id_seq; Type: SEQUENCE SET; Schema: module; Owner: shop
--

SELECT pg_catalog.setval('module.module_product_id_seq', 1, false);


--
-- Name: attribute_category_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.attribute_category_id_seq', 1, false);


--
-- Name: attribute_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.attribute_id_seq', 1, false);


--
-- Name: attribute_value_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.attribute_value_id_seq', 1, false);


--
-- Name: banner_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.banner_id_seq', 7, true);


--
-- Name: black_list_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.black_list_id_seq', 1, false);


--
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.cart_id_seq', 1, false);


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.category_id_seq', 1, false);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.customer_id_seq', 1, false);


--
-- Name: customer_order_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.customer_order_id_seq', 1, false);


--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.feedback_id_seq', 1, false);


--
-- Name: filter_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.filter_id_seq', 1, false);


--
-- Name: filter_value_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.filter_value_id_seq', 1, false);


--
-- Name: infopage_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.infopage_id_seq', 1, false);


--
-- Name: manufacturer_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.manufacturer_id_seq', 1, false);


--
-- Name: menu_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.menu_id_seq', 13, true);


--
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.order_item_id_seq', 1, false);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.payment_id_seq', 1, false);


--
-- Name: payment_method_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.payment_method_id_seq', 1, false);


--
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_category_id_seq', 1, false);


--
-- Name: product_description_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_description_id_seq', 1, false);


--
-- Name: product_diagram_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_diagram_id_seq', 1, false);


--
-- Name: product_group_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_group_id_seq', 1, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_id_seq', 1, false);


--
-- Name: product_image_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_image_id_seq', 1, false);


--
-- Name: product_option_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_option_id_seq', 1, false);


--
-- Name: product_relation_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.product_relation_id_seq', 1, false);


--
-- Name: products_in_group_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.products_in_group_id_seq', 1, false);


--
-- Name: relation_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.relation_id_seq', 1, true);


--
-- Name: snippet_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.snippet_id_seq', 1, false);


--
-- Name: system_user_id_seq; Type: SEQUENCE SET; Schema: shop; Owner: shop
--

SELECT pg_catalog.setval('shop.system_user_id_seq', 1, false);


--
-- Name: product_available_history_id_seq; Type: SEQUENCE SET; Schema: stat; Owner: shop
--

SELECT pg_catalog.setval('stat.product_available_history_id_seq', 1, false);


--
-- Name: product_price_history_id_seq; Type: SEQUENCE SET; Schema: stat; Owner: shop
--

SELECT pg_catalog.setval('stat.product_price_history_id_seq', 1, false);


--
-- Name: product_stat_id_seq; Type: SEQUENCE SET; Schema: stat; Owner: shop
--

SELECT pg_catalog.setval('stat.product_stat_id_seq', 1, false);


--
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: admin; Owner: shop
--



--
-- Name: token token_pkey; Type: CONSTRAINT; Schema: api; Owner: shop
--



--
-- Name: token token_token_key; Type: CONSTRAINT; Schema: api; Owner: shop
--



--
-- Name: translation_column translation_column_pkey; Type: CONSTRAINT; Schema: i18n; Owner: shop
--



--
-- Name: translation_manual translation_manual_pkey; Type: CONSTRAINT; Schema: i18n; Owner: shop
--



--
-- Name: translation translation_pkey; Type: CONSTRAINT; Schema: i18n; Owner: shop
--



--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: module; Owner: shop
--



--
-- Name: module_category module_category_pkey; Type: CONSTRAINT; Schema: module; Owner: shop
--



--
-- Name: module_product module_product_pkey; Type: CONSTRAINT; Schema: module; Owner: shop
--



--
-- Name: attribute_category attribute_category_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: attribute attribute_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: attribute_value attribute_value_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: banner banner_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: black_list black_list_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: customer_order customer_order_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: customer customer_secret_key; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: filter filter_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: filter_value filter_value_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: infopage infopage_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: manufacturer manufacturer_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: payment_method payment_method_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_description product_description_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_diagram product_diagram_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_group product_group_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_image product_image_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_relation product_relation_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: products_in_group products_in_group_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: relation relation_mnemonic_key; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: relation relation_name_key; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: relation relation_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: snippet snippet_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: system_user system_user_pkey; Type: CONSTRAINT; Schema: shop; Owner: shop
--



--
-- Name: product_available_history product_available_history_pkey; Type: CONSTRAINT; Schema: stat; Owner: shop
--



--
-- Name: product_price_history product_price_history_pkey; Type: CONSTRAINT; Schema: stat; Owner: shop
--



--
-- Name: product_stat product_stat_pkey; Type: CONSTRAINT; Schema: stat; Owner: shop
--



--
-- Name: translation_column_table_name_original_column_idx; Type: INDEX; Schema: i18n; Owner: shop
--



--
-- Name: category tau_category; Type: TRIGGER; Schema: shop; Owner: shop
--


--
-- Name: SCHEMA admin; Type: ACL; Schema: -; Owner: shop
--

GRANT USAGE ON SCHEMA admin TO web;


--
-- Name: SCHEMA api; Type: ACL; Schema: -; Owner: shop
--

GRANT USAGE ON SCHEMA api TO web;


--
-- Name: SCHEMA core; Type: ACL; Schema: -; Owner: migrator
--

GRANT USAGE ON SCHEMA core TO shop;
GRANT USAGE ON SCHEMA core TO web;


--
-- Name: SCHEMA i18n; Type: ACL; Schema: -; Owner: shop
--

GRANT USAGE ON SCHEMA i18n TO web;


--
-- Name: SCHEMA module; Type: ACL; Schema: -; Owner: shop
--

GRANT USAGE ON SCHEMA module TO module;


--
-- Name: SCHEMA stat; Type: ACL; Schema: -; Owner: shop
--

GRANT USAGE ON SCHEMA stat TO web;


--
-- Name: SCHEMA web; Type: ACL; Schema: -; Owner: shop
--

GRANT USAGE ON SCHEMA web TO web;


--
-- Name: SEQUENCE banner_image_seq; Type: ACL; Schema: admin; Owner: migrator
--

GRANT SELECT,USAGE ON SEQUENCE admin.banner_image_seq TO shop;

--
-- Name: banner_get(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.banner_get(aid integer) RETURNS shop.banner
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select * from shop.banner where id = aid;
$$;


ALTER FUNCTION admin.banner_get(aid integer) OWNER TO shop;

--
-- Name: banner_set(integer, character varying, integer, boolean, character varying, character varying); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.banner_set(aid integer, aimage_url character varying, apriority integer, ais_visible boolean, ahref character varying, atitle character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if aid is null then
        insert into shop.banner (image_url, priority, is_visible, href, title)
        values (aimage_url, apriority, ais_visible, ahref, atitle)
        returning id into vid;
    else
        update shop.banner
           set image_url = aimage_url,
               priority = apriority,
               is_visible = ais_visible,
               href = ahref,
               title = atitle
         where id = aid
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.banner_set(aid integer, aimage_url character varying, apriority integer, ais_visible boolean, ahref character varying, atitle character varying) OWNER TO shop;

--
-- Name: banners_get(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.banners_get() RETURNS SETOF shop.banner
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select * from shop.banner order by priority, id;
$$;


ALTER FUNCTION admin.banners_get() OWNER TO shop;

--
-- Name: category; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.category (
    id integer NOT NULL,
    name_en text,
    name text,
    parent_id integer,
    sort_order integer DEFAULT 0 NOT NULL,
    image character varying(126),
    sef_name character varying(126),
    is_exported boolean DEFAULT false NOT NULL,
    is_visible boolean DEFAULT true NOT NULL
);


ALTER TABLE shop.category OWNER TO shop;

--
-- Name: COLUMN category.is_exported; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.category.is_exported IS 'DEPRECATED';


--
-- Name: categories_get(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.categories_get(aparent_id integer) RETURNS SETOF shop.category
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select *
      from shop.category c
    order by c.sort_order;
$$;


ALTER FUNCTION admin.categories_get(aparent_id integer) OWNER TO shop;

--
-- Name: FUNCTION categories_get(aparent_id integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.categories_get(aparent_id integer) IS 'Returns a category list';


--
-- Name: category_del(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.category_del(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    delete from shop.category where id = aid returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.category_del(aid integer) OWNER TO shop;

--
-- Name: category_set(integer, character varying, integer, boolean, integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.category_set(aid integer, aname character varying, aparent_id integer, ais_exported boolean, asort_order integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if aid is null then
        insert into shop.category(name, parent_id, is_exported, sort_order)
        values (aname, aparent_id, ais_exported, asort_order)
        returning id into vid;
    else
        update shop.category
           set name = aname,
               parent_id = aparent_id,
               is_exported = ais_exported,
               sort_order = asort_order
         where id = aid
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.category_set(aid integer, aname character varying, aparent_id integer, ais_exported boolean, asort_order integer) OWNER TO shop;

--
-- Name: FUNCTION category_set(aid integer, aname character varying, aparent_id integer, ais_exported boolean, asort_order integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.category_set(aid integer, aname character varying, aparent_id integer, ais_exported boolean, asort_order integer) IS 'Creates or updates a category';


--
-- Name: confirm_order(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.confirm_order(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.customer_order
       set status = 'confirmed'
     where id = aid
       and status = 'new'
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.confirm_order(aid integer) OWNER TO shop;

--
-- Name: FUNCTION confirm_order(aid integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.confirm_order(aid integer) IS 'Order confirmation. Order needs to be in status "new"';


--
-- Name: feedback_publish(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.feedback_publish(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.feedback
       set is_published = true
     where id = aid
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.feedback_publish(aid integer) OWNER TO shop;

--
-- Name: feedback_reject(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.feedback_reject(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    delete from shop.feedback where id = aid
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.feedback_reject(aid integer) OWNER TO shop;

--
-- Name: feedback_set_dt_added(integer, timestamp with time zone); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.feedback_set_dt_added(aid integer, adt_added timestamp with time zone) RETURNS timestamp with time zone
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult timestamptz;
begin
    update shop.feedback
       set dt_added = adt_added
     where id = aid
    returning dt_added into vresult;

    return vresult;
end;
$$;


ALTER FUNCTION admin.feedback_set_dt_added(aid integer, adt_added timestamp with time zone) OWNER TO shop;

--
-- Name: FUNCTION feedback_set_dt_added(aid integer, adt_added timestamp with time zone); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.feedback_set_dt_added(aid integer, adt_added timestamp with time zone) IS 'Updated feedback publish date (moderation function)';


--
-- Name: feedbacks_get(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.feedbacks_get() RETURNS TABLE(id integer, is_published boolean, dt_added timestamp with time zone, name character varying, message character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select f.id, f.is_published, f.dt_added, f.name, f.message
      from shop.feedback f
     order by f.dt_added desc;
$$;


ALTER FUNCTION admin.feedbacks_get() OWNER TO shop;

--
-- Name: get_all_images(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.get_all_images() RETURNS TABLE(id integer, product_id integer, url character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select id, product_id, url from shop.product_image order by 1;
$$;


ALTER FUNCTION admin.get_all_images() OWNER TO shop;

--
-- Name: FUNCTION get_all_images(); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.get_all_images() IS 'Returns all images for all products: for debug or develop purposes';


--
-- Name: get_max_image_index(integer); Type: FUNCTION; Schema: admin; Owner: migrator
--

CREATE FUNCTION admin.get_max_image_index(aproduct_id integer) RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select coalesce(max(p.priority), 0)
      from shop.product_image p
     where p.product_id = aproduct_id;
$$;


ALTER FUNCTION admin.get_max_image_index(aproduct_id integer) OWNER TO migrator;

--
-- Name: get_menu(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.get_menu() RETURNS TABLE(id integer, title character varying, url character varying, parent_id integer)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select m.id, m.title, m.url, m.parent_id
      from admin.menu m
     order by m.priority;
end;
$$;


ALTER FUNCTION admin.get_menu() OWNER TO shop;

--
-- Name: FUNCTION get_menu(); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.get_menu() IS 'Returns menu for admin panel';


--
-- Name: get_next_banner_id(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.get_next_banner_id() RETURNS integer
    LANGUAGE sql SECURITY DEFINER
    AS $$
    select nextval('admin.banner_image_seq')::integer;
$$;


ALTER FUNCTION admin.get_next_banner_id() OWNER TO shop;

--
-- Name: get_order(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.get_order(aid integer) RETURNS TABLE(id integer, customer_id integer, dt_create timestamp with time zone, amount numeric, status shop.t_order_status, status_name character varying, email character varying, phone character varying, name character varying, ip inet, city character varying, address character varying, delivery_cost numeric, subtotal numeric, total numeric, delivery_code character varying, delivery_name character varying, last_name character varying, patronymic_name character varying)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select o.id, o.customer_id, o.dt_create, o.amount, o.status, web.get_status_name(o.status),
           o.email, o.phone, o.name, o.ip, o.city, o.address, o.delivery_cost,
           o.amount, o.amount + o.delivery_cost, o.delivery_code, o.delivery_name,
           o.last_name, o.patronymic_name
      from shop.customer_order o
     where o.id = aid;
end;
$$;


ALTER FUNCTION admin.get_order(aid integer) OWNER TO shop;

--
-- Name: get_order_items(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.get_order_items(aorder_id integer) RETURNS TABLE(id integer, product_id integer, product_sku character varying, quantity integer, price numeric, amount numeric, name character varying)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select i.id, i.product_id, p.sku::varchar, i.quantity, i.price, i.amount, p.name::varchar
      from shop.order_item i
      join shop.product p on p.id = i.product_id
     where i.order_id = aorder_id
     order by i.id;
end;
$$;


ALTER FUNCTION admin.get_order_items(aorder_id integer) OWNER TO shop;

--
-- Name: infopage_del(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.infopage_del(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    delete from shop.infopage where id = aid
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.infopage_del(aid integer) OWNER TO shop;

--
-- Name: infopage_get(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.infopage_get(aid integer) RETURNS TABLE(id integer, url character varying, views integer, code text)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.id, p.url, p.views, p.code
      from shop.infopage p
     where p.id = aid;
$$;


ALTER FUNCTION admin.infopage_get(aid integer) OWNER TO shop;

--
-- Name: infopage_set(integer, character varying, text); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.infopage_set(aid integer, aurl character varying, acode text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if aid is null then
        insert into shop.infopage (url, code)
        values (aurl, acode)
        returning id into vid;
    else
        update shop.infopage
           set code = acode,
               url = aurl
         where id = aid
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.infopage_set(aid integer, aurl character varying, acode text) OWNER TO shop;

--
-- Name: infopages_get(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.infopages_get() RETURNS TABLE(id integer, url character varying, views integer)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.id, p.url, p.views
      from shop.infopage p
     order by p.id;
$$;


ALTER FUNCTION admin.infopages_get() OWNER TO shop;

--
-- Name: is_image_url_used(character varying); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.is_image_url_used(aurl character varying) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select exists (select * from shop.product_image ip where ip.url = aurl);
$$;


ALTER FUNCTION admin.is_image_url_used(aurl character varying) OWNER TO shop;

--
-- Name: FUNCTION is_image_url_used(aurl character varying); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.is_image_url_used(aurl character varying) IS 'Returns true if image URL is used in any product, call this function before deleting an image to ensure that file will not be lost';


--
-- Name: manufacturers_get(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.manufacturers_get() RETURNS TABLE(id integer, name character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select m.id, m.name from shop.manufacturer m order by m.name;
$$;


ALTER FUNCTION admin.manufacturers_get() OWNER TO shop;

--
-- Name: module_category_get(character varying, integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.module_category_get(amodule character varying, acategory_id integer) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select not exists (
        select *
          from module.module_category mc
         where mc.module = amodule
           and mc.category_id = acategory_id
           and mc.is_exported = false
    )
$$;


ALTER FUNCTION admin.module_category_get(amodule character varying, acategory_id integer) OWNER TO shop;

--
-- Name: module_category_set(character varying, integer, boolean); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.module_category_set(amodule character varying, acategory_id integer, ais_exported boolean) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update module.module_category
       set is_exported = ais_exported
     where module = amodule
       and category_id = acategory_id
    returning id into vid;

    if not found then
        insert into module.module_category (module, category_id, is_exported)
        values (amodule, acategory_id, ais_exported)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.module_category_set(amodule character varying, acategory_id integer, ais_exported boolean) OWNER TO shop;

--
-- Name: move_picture(integer, integer, character varying); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.move_picture(aproduct_id integer, aid integer, adirection character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vsecond_id integer;
    vfirst_priority integer; vsecond_priority integer;
begin
    if adirection not in ('up', 'down') then
        return -1;
    end if;

    with cte as (
    select id first_id,
           case when adirection = 'down' then
                lead(id) over (partition by product_id order by priority)
           else
                lag(id)  over (partition by product_id order by priority)
           end second_id
      from product_image pi
     where pi.product_id = aproduct_id
     order by pi.priority
     ) select second_id into vsecond_id from cte where first_id = aid;

    if vsecond_id is null then
        return -1;
    end if;

    select priority into vfirst_priority from product_image where id = aid;
    select priority into vsecond_priority from product_image where id = vsecond_id;

    update product_image set priority = -1 where id = aid;
    update product_image set priority = vfirst_priority where id = vsecond_id;
    update product_image set priority = vsecond_priority where id = aid;

    return 1;
end;
$$;


ALTER FUNCTION admin.move_picture(aproduct_id integer, aid integer, adirection character varying) OWNER TO shop;

--
-- Name: order_delete(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.order_delete(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    delete from shop.order_item i where i.order_id = aid;

    delete from shop.customer_order o where o.id = aid
        returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.order_delete(aid integer) OWNER TO shop;

--
-- Name: FUNCTION order_delete(aid integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.order_delete(aid integer) IS 'Delete order';

--
-- Name: product_url_get(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.product_url_get(aproduct_id integer) RETURNS character varying
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select case when p.sef_name is not null then '/product/' || p.sef_name
           else '/product/' || p.id::varchar
           end
      from shop.product p
     where p.id = aproduct_id;
$$;


ALTER FUNCTION web.product_url_get(aproduct_id integer) OWNER TO shop;

--
-- Name: price_history_get(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.price_history_get() RETURNS TABLE(id integer, product_id integer, sku character varying, name character varying, old_price numeric, new_price numeric, user_id integer, user_name character varying, dt_from timestamp with time zone, product_url character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select t.id, t.product_id, t.sku, t.product_name, t.old_price,
           t.price, t.user_id, t.user_name, t.dt_from, t.product_url
      from (
        select h.id,
               h.product_id,
               p.sku,
               p.name as product_name,
               lag(h.price) over (partition by h.product_id order by dt_from) as old_price,
               h.price,
               h.user_id,
               u.name as user_name,
               h.dt_from,
               web.product_url_get(p.id) as product_url
          from stat.product_price_history h
          join shop.product p on p.id = h.product_id
          left join shop.system_user u on u.id = h.user_id
      ) t
     where t.dt_from > now() - interval '2 weeks'
    order by t.dt_from desc;
$$;


ALTER FUNCTION admin.price_history_get() OWNER TO shop;

--
-- Name: FUNCTION price_history_get(); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.price_history_get() IS 'Product price history report';


--
-- Name: product_add_image(integer, integer, character varying); Type: FUNCTION; Schema: admin; Owner: migrator
--

CREATE FUNCTION admin.product_add_image(aproduct_id integer, aindex integer, aurl character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    insert into shop.product_image (product_id, priority, url)
    values (aproduct_id, aindex, aurl)
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.product_add_image(aproduct_id integer, aindex integer, aurl character varying) OWNER TO migrator;

--
-- Name: product_category_set(integer, integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_category_set(aproduct_id integer, acategory_id integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if acategory_id is null then
        delete from shop.product_category where product_id = aproduct_id returning id into vid;
    else
        update shop.product_category set category_id = acategory_id where product_id = aproduct_id
        returning id into vid;

        if not found then
            insert into shop.product_category(product_id, category_id)
            values (aproduct_id, acategory_id)
            returning id into vid;
        end if;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.product_category_set(aproduct_id integer, acategory_id integer) OWNER TO shop;

--
-- Name: product_category_set(character varying, character varying); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_category_set(asku character varying, acategory character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vproduct_id integer; vcategory_id integer;
    vnew_category_id integer;
begin
    select id into vproduct_id from shop.product where sku = asku;
    select id into vcategory_id from shop.category where name = acategory;

    if vproduct_id is null or vcategory_id is null then
        return -1;
    end if;

    update shop.product_category
       set category_id = vcategory_id
     where product_id = vproduct_id
    returning category_id into vnew_category_id;

    if not found then
        insert into shop.product_category (product_id, category_id)
        values (vproduct_id, vcategory_id)
        returning category_id into vnew_category_id;
    end if;

    return vnew_category_id;
end;
$$;


ALTER FUNCTION admin.product_category_set(asku character varying, acategory character varying) OWNER TO shop;

--
-- Name: FUNCTION product_category_set(asku character varying, acategory character varying); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.product_category_set(asku character varying, acategory character varying) IS 'Updates product category';


--
-- Name: product_del(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_del(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    perform admin.product_description_set(aid, null);
    perform admin.product_category_set(aid, null);

    delete from shop.product_image where product_id = aid;
    delete from shop.attribute_value where product_id = aid;
    delete from stat.product_stat where product_id = aid;
    delete from module.module_product where product_id = aid;
    delete from shop.product where id = aid returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.product_del(aid integer) OWNER TO shop;

--
-- Name: FUNCTION product_del(aid integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.product_del(aid integer) IS 'Deletes a product, its category and description';


--
-- Name: product_delete_image(integer, integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_delete_image(aproduct_id integer, aid integer) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult text;
begin
    delete from shop.product_image where product_id = aproduct_id and id = aid
    returning url into vresult;

    return vresult;
end;
$$;


ALTER FUNCTION admin.product_delete_image(aproduct_id integer, aid integer) OWNER TO shop;

--
-- Name: FUNCTION product_delete_image(aproduct_id integer, aid integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.product_delete_image(aproduct_id integer, aid integer) IS 'Deletes images from databases and returns its URL';


--
-- Name: product_description_set(integer, text); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_description_set(aproduct_id integer, adescription text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if adescription is null then
        delete from shop.product_description where product_id = aproduct_id returning id into vid;
    else
        update shop.product_description
           set description = adescription
         where product_id = aproduct_id
        returning id into vid;

        if not found then
            insert into shop.product_description (product_id, description)
            values (aproduct_id, adescription)
            returning id into vid;
        end if;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.product_description_set(aproduct_id integer, adescription text) OWNER TO shop;

--
-- Name: get_attribute_id(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_attribute_id(aattribute_name character varying) RETURNS integer
    LANGUAGE sql IMMUTABLE SECURITY DEFINER
    AS $$
    select id from shop.attribute where name = aattribute_name;
$$;


ALTER FUNCTION web.get_attribute_id(aattribute_name character varying) OWNER TO shop;


--
-- Name: get_attribute_value(integer, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_attribute_value(aproduct_id integer, aattribute_id integer) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select v.value
      from shop.attribute_value v
     where v.attribute_id = aattribute_id
       and v.product_id = aproduct_id;
$$;


ALTER FUNCTION web.get_attribute_value(aproduct_id integer, aattribute_id integer) OWNER TO shop;

--
-- Name: get_product_description(integer, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_description(aproduct_id integer, achars_limit integer DEFAULT NULL::integer) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select case when achars_limit is null or (length(d.description) < achars_limit - 3) then d.description
                else substring(d.description from 1 for achars_limit) || '...'
                end
      from shop.product_description d
     where d.product_id = aproduct_id;
$$;


ALTER FUNCTION web.get_product_description(aproduct_id integer, achars_limit integer) OWNER TO shop;

--
-- Name: get_product_main_image(integer, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_main_image(aproduct_id integer, asize integer DEFAULT '-1'::integer) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select case when asize = -1 then i.url
           else replace(i.url, '/static/image/product/', '/static/image/product/' || asize::text || '/')
           end
      from shop.product_image i
     where product_id = aproduct_id order by priority limit 1;
$$;


ALTER FUNCTION web.get_product_main_image(aproduct_id integer, asize integer) OWNER TO shop;

--
-- Name: get_product_main_category(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_main_category(aproduct_id integer) RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select category_id from shop.product_category where product_id = aproduct_id;
$$;


ALTER FUNCTION web.get_product_main_category(aproduct_id integer) OWNER TO shop;

--
-- Name: FUNCTION get_product_main_category(aproduct_id integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_product_main_category(aproduct_id integer) IS 'Returns product category, "main" is for legacy';

--
-- Name: product_get(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_get(aid integer) RETURNS TABLE(id integer, sku character varying, name character varying, url character varying, manufacturer_id integer, price numeric, diagram character varying, lookup_no smallint, vehicle_id character varying, note text, description text, image text, available integer, manufacturer_name character varying, category_id integer, is_visible boolean, previous_price numeric, sef_name character varying, gtin character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $_$
    select p.id,
           p.sku,
           p.name,
           web.product_url_get(p.id),
           p.manufacturer_id,
           p.price,
           (select diagram from shop.product_diagram where product_id = p.id limit 1),
           (select lookup_no from shop.product_diagram where product_id = p.id limit 1),
           substring(sku from '-(.+)$'),
           web.get_attribute_value(p.id, web.get_attribute_id('Note')),
           web.get_product_description(p.id),
           web.get_product_main_image(p.id),
           p.available,
           m.name,
           web.get_product_main_category(p.id),
           p.is_visible,
           p.previous_price,
           p.sef_name,
           p.gtin
      from shop.product p
      left join shop.manufacturer m on m.id = p.manufacturer_id
     where p.id = aid;
$_$;


ALTER FUNCTION admin.product_get(aid integer) OWNER TO shop;

--
-- Name: product_move_to_category(character varying, character varying, character varying); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_move_to_category(aparent_category character varying, acategory character varying, amask character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult integer;
    vcategory_id integer; vparent_category_id integer;
begin
    vresult := (select count(*) from shop.product where name like amask);

    if vresult = 0 then
        raise warning 'No products matching the given mask';
        return 0;
    end if;

    select id
      into vparent_category_id
      from shop.category
     where name = aparent_category and parent_id is null;

    if vparent_category_id is null then
        return 0;
    end if;

    select id
      into vcategory_id
      from shop.category
     where name = acategory
       and parent_id = vparent_category_id;

    if vcategory_id is null then
        insert into shop.category(name, parent_id)
        values (acategory, vparent_category_id)
        returning id into vcategory_id;
    end if;

    perform admin.product_category_set(p.id, vcategory_id)
       from shop.product p
      where p.name like amask;

    return vresult;
end;
$$;


ALTER FUNCTION admin.product_move_to_category(aparent_category character varying, acategory character varying, amask character varying) OWNER TO shop;

--
-- Name: FUNCTION product_move_to_category(aparent_category character varying, acategory character varying, amask character varying); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.product_move_to_category(aparent_category character varying, acategory character varying, amask character varying) IS 'Move product matching mask amask to specified subcategory';


--
-- Name: product_relation_del(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_relation_del(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    delete from shop.product_relation where id = aid returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.product_relation_del(aid integer) OWNER TO shop;

--
-- Name: FUNCTION product_relation_del(aid integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.product_relation_del(aid integer) IS 'Deletes a relations between products, by ID';


--
-- Name: product_relation_set(integer, integer, character varying); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_relation_set(aparent_id integer, achild_id integer, arelation character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer; vrelation_id integer;
begin
    select id into vrelation_id from shop.relation where mnemonic = arelation;

    if not found then
        return -1;
    end if;

    select id into vid
      from shop.product_relation
     where parent_id = aparent_id
       and child_id = achild_id
       and relation_id = vrelation_id;

    if not found then
        insert into shop.product_relation (parent_id, child_id, relation_id)
        values (aparent_id, achild_id, vrelation_id)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.product_relation_set(aparent_id integer, achild_id integer, arelation character varying) OWNER TO shop;

--
-- Name: product_set(integer, text, text, numeric, integer, boolean, integer, integer, character varying, numeric, character varying, character varying); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.product_set(aid integer, aname text, adescription text, aprice numeric, aavailable integer, ais_visible boolean, acategory_id integer, amanufactirer_id integer, asku character varying, aprevious_price numeric, asef_name character varying, agtin character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if aid is null then
        insert into shop.product(name, price, available, is_visible, manufacturer_id, sku, previous_price,
            sef_name, gtin)
        values (aname, aprice, aavailable, ais_visible, amanufactirer_id, asku, aprevious_price,
            asef_name, agtin)
        returning id into vid;
    else
        update shop.product
           set name = aname,
               price = aprice,
               available = aavailable,
               is_visible = ais_visible,
               manufacturer_id = amanufactirer_id,
               previous_price = aprevious_price,
               sef_name = asef_name,
               gtin = agtin
         where id = aid
        returning id into vid;
    end if;

    perform admin.product_description_set(vid, adescription);
    perform admin.product_category_set(vid, acategory_id);

    return vid;
end;
$$;


ALTER FUNCTION admin.product_set(aid integer, aname text, adescription text, aprice numeric, aavailable integer, ais_visible boolean, acategory_id integer, amanufactirer_id integer, asku character varying, aprevious_price numeric, asef_name character varying, agtin character varying) OWNER TO shop;

--
-- Name: FUNCTION product_set(aid integer, aname text, adescription text, aprice numeric, aavailable integer, ais_visible boolean, acategory_id integer, amanufactirer_id integer, asku character varying, aprevious_price numeric, asef_name character varying, agtin character varying); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.product_set(aid integer, aname text, adescription text, aprice numeric, aavailable integer, ais_visible boolean, acategory_id integer, amanufactirer_id integer, asku character varying, aprevious_price numeric, asef_name character varying, agtin character varying) IS 'Creates or updates a product';


--
-- Name: products_get(integer, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.products_get(acategory_id integer, aname character varying, aorder_by character varying, aorder_dir character varying, apage integer DEFAULT 0) RETURNS TABLE(id integer, manufacturer_name character varying, manufacturer_id integer, name character varying, available integer, price numeric, sku character varying, viewed integer, url character varying, previous_price numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
declare
    vsql text; vbase_query text;
begin
    vbase_query := $sql$
               shop.product p
          left join shop.manufacturer m on m.id = p.manufacturer_id
         where ((lower(p.name) like '%' || lower($1) || '%') or (lower(p.sku) like '%' || lower($1) || '%') or $1 is null)
           and (exists (select * from product_category pc where pc.product_id = p.id and pc.category_id = $2 or $2 is null))
    $sql$;

    if apage > 0 then
        vsql := $sql$
            select p.id, m.name::varchar,
                   m.id, p.name::varchar,
                   p.available,
                   p.price,
                   p.sku::varchar,
                   p.viewed,
                   web.product_url_get(p.id),
                   p.previous_price
            from {base_query}
            order by {order_by} {order_dir}
            limit 20 offset {offset}
        $sql$;
    else
        vsql := 'select count(*)::int, null::varchar, null::int, null::varchar, null::int,
                        null::numeric, null::varchar, null::int, null::varchar, null::numeric
                   from {base_query}';
    end if;

    vsql := replace(vsql, '{base_query}', vbase_query);
    vsql := replace(vsql, '{order_by}', aorder_by);
    vsql := replace(vsql, '{order_dir}', aorder_dir);
    vsql := replace(vsql, '{offset}', ((apage - 1) * 20)::text);

    return query execute vsql using aname, acategory_id;
end;
$_$;


ALTER FUNCTION admin.products_get(acategory_id integer, aname character varying, aorder_by character varying, aorder_dir character varying, apage integer) OWNER TO shop;

--
-- Name: FUNCTION products_get(acategory_id integer, aname character varying, aorder_by character varying, aorder_dir character varying, apage integer); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.products_get(acategory_id integer, aname character varying, aorder_by character varying, aorder_dir character varying, apage integer) IS 'Returns all products in shop';


--
-- Name: set_available(integer, numeric); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.set_available(aproduct_id integer, aavailable numeric) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.product
       set available = aavailable
     where id = aproduct_id
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.set_available(aproduct_id integer, aavailable numeric) OWNER TO shop;

--
-- Name: FUNCTION set_available(aproduct_id integer, aavailable numeric); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.set_available(aproduct_id integer, aavailable numeric) IS 'Updates product available';


--
-- Name: set_delivery_cost(integer, numeric); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.set_delivery_cost(aorder_id integer, adelivery_cost numeric) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.customer_order
       set delivery_cost = adelivery_cost
     where id = aorder_id
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.set_delivery_cost(aorder_id integer, adelivery_cost numeric) OWNER TO shop;

--
-- Name: FUNCTION set_delivery_cost(aorder_id integer, adelivery_cost numeric); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.set_delivery_cost(aorder_id integer, adelivery_cost numeric) IS 'Updates delivery cost for the order';


--
-- Name: set_previous_price(integer, numeric); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.set_previous_price(aproduct_id integer, aprevious_price numeric) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.product
       set previous_price = aprevious_price
     where id = aproduct_id
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.set_previous_price(aproduct_id integer, aprevious_price numeric) OWNER TO shop;

--
-- Name: FUNCTION set_previous_price(aproduct_id integer, aprevious_price numeric); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.set_previous_price(aproduct_id integer, aprevious_price numeric) IS 'Updates product previous price';


--
-- Name: set_price(integer, numeric); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.set_price(aproduct_id integer, aprice numeric) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.product
       set price = aprice
     where id = aproduct_id
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION admin.set_price(aproduct_id integer, aprice numeric) OWNER TO shop;

--
-- Name: FUNCTION set_price(aproduct_id integer, aprice numeric); Type: COMMENT; Schema: admin; Owner: shop
--

COMMENT ON FUNCTION admin.set_price(aproduct_id integer, aprice numeric) IS 'Updates product price';


--
-- Name: snippet_del(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.snippet_del(aid integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    delete from shop.snippet where id = aid returning id into vid;
    return vid;
end;
$$;


ALTER FUNCTION admin.snippet_del(aid integer) OWNER TO shop;

--
-- Name: snippet; Type: TABLE; Schema: shop; Owner: shop
--

CREATE TABLE shop.snippet (
    id integer NOT NULL,
    name character varying(126),
    pos character varying(126),
    priority integer DEFAULT 0 NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    data text,
    show_in_admin boolean DEFAULT true NOT NULL
);


ALTER TABLE shop.snippet OWNER TO shop;

--
-- Name: COLUMN snippet.show_in_admin; Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON COLUMN shop.snippet.show_in_admin IS 'Toggles should snippet be displayed when user in admin or not';


--
-- Name: snippet_get(integer); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.snippet_get(aid integer) RETURNS shop.snippet
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select * from shop.snippet where id = aid;
$$;


ALTER FUNCTION admin.snippet_get(aid integer) OWNER TO shop;

--
-- Name: snippet_set(integer, character varying, character varying, integer, boolean, text, boolean); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.snippet_set(aid integer, aname character varying, apos character varying, apriority integer, ais_enabled boolean, adata text, ashow_in_admin boolean) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if aid is null then
        insert into shop.snippet(name, pos, priority, is_enabled, data, show_in_admin)
        values (aname, apos, apriority, ais_enabled, adata, ashow_in_admin)
        returning id into vid;
    else
        update shop.snippet
           set name = aname,
               pos = apos,
               priority = apriority,
               is_enabled = ais_enabled,
               data = adata,
               show_in_admin = ashow_in_admin
         where id = aid
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.snippet_set(aid integer, aname character varying, apos character varying, apriority integer, ais_enabled boolean, adata text, ashow_in_admin boolean) OWNER TO shop;

--
-- Name: snippets_get(); Type: FUNCTION; Schema: admin; Owner: shop
--

CREATE FUNCTION admin.snippets_get() RETURNS SETOF shop.snippet
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select * from shop.snippet order by priority;
$$;


ALTER FUNCTION admin.snippets_get() OWNER TO shop;

--
-- Name: update_product(integer, text, text, numeric, integer); Type: FUNCTION; Schema: admin; Owner: migrator
--

CREATE FUNCTION admin.update_product(aproduct_id integer, aname text, adescription text, aprice numeric, aavailable integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.product
       set name = aname,
           price = aprice,
           available = aavailable
     where id = aproduct_id
    returning id into vid;

    if adescription is null then
        delete from shop.product_description where product_id = aproduct_id;
    else
        update shop.product_description
           set description = adescription
         where product_id = aproduct_id;

        if not found then
            insert into shop.product_description(product_id, description)
            values(aproduct_id, adescription);
        end if;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION admin.update_product(aproduct_id integer, aname text, adescription text, aprice numeric, aavailable integer) OWNER TO migrator;

--
-- Name: FUNCTION update_product(aproduct_id integer, aname text, adescription text, aprice numeric, aavailable integer); Type: COMMENT; Schema: admin; Owner: migrator
--

COMMENT ON FUNCTION admin.update_product(aproduct_id integer, aname text, adescription text, aprice numeric, aavailable integer) IS 'Updates a product';


--
-- Name: attribute_category_get(character varying, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.attribute_category_get(aname character varying, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    if aname is null then
        return null;
    end if;

    select id into vid from shop.attribute_category where name = aname;

    if vid is null and acreate_if_not_exists then
        insert into shop.attribute_category(name) values (aname)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION api.attribute_category_get(aname character varying, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: attribute_get(integer, character varying, integer, character varying, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.attribute_get(aattribute_category_id integer, aname character varying, apriority integer, adescription character varying, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    select id
      into vid
      from shop.attribute
     where name = aname
       and attribute_category_id is not distinct from aattribute_category_id;

    if vid is null and acreate_if_not_exists then
        insert into shop.attribute(name, attribute_category_id, priority, description)
        values (aname, aattribute_category_id, coalesce(apriority, 0), adescription)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION api.attribute_get(aattribute_category_id integer, aname character varying, apriority integer, adescription character varying, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: attribute_value_set(character varying, character varying, character varying, character varying, integer, character varying, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.attribute_value_set(asku character varying, acategory character varying, aname character varying, avalue character varying, apriority integer, adescription character varying, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult integer;
    vproduct_id integer := api.get_product_id(asku);
    vcategory_id integer := api.attribute_category_get(acategory, acreate_if_not_exists);
    vattribute_id integer;
begin
    if vproduct_id is null then
        return 0;
    end if;

    vattribute_id := api.attribute_get(vcategory_id, aname, apriority, adescription, acreate_if_not_exists);

    if vattribute_id is null then
        return 0;
    end if;

    if avalue is null then
        delete from shop.attribute_value
         where product_id = vproduct_id
           and attribute_id = vattribute_id
        returning id into vresult;

        return 1;
    end if;

    update shop.attribute_value
       set value = avalue
     where product_id = vproduct_id
       and attribute_id = vattribute_id
    returning id into vresult;

    if not found then
        insert into shop.attribute_value(product_id, attribute_id, value)
        values (vproduct_id, vattribute_id, avalue)
        returning id into vresult;
    end if;

    if vresult is not null then
        return 1;
    else
        return 0;
    end if;
end;
$$;


ALTER FUNCTION api.attribute_value_set(asku character varying, acategory character varying, aname character varying, avalue character varying, apriority integer, adescription character varying, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: attributes_set(character varying, json, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.attributes_set(asku character varying, aattributes json, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult integer;
begin
     select sum(api.attribute_value_set(asku, category, name, value, priority, description, acreate_if_not_exists))
       into vresult
       from json_to_recordset(aattributes)
         as r(category text, name text, value text, priority integer, description text);

    return vresult;
end;
$$;


ALTER FUNCTION api.attributes_set(asku character varying, aattributes json, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: FUNCTION attributes_set(asku character varying, aattributes json, acreate_if_not_exists boolean); Type: COMMENT; Schema: api; Owner: shop
--

COMMENT ON FUNCTION api.attributes_set(asku character varying, aattributes json, acreate_if_not_exists boolean) IS 'Updates product attributes, returns count of updated attributes';


--
-- Name: categories_get(integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.categories_get(aparent_id integer DEFAULT NULL::integer) RETURNS TABLE(id integer, name character varying, parent_id integer, sort_order integer)
    LANGUAGE sql SECURITY DEFINER
    AS $$
    select c.id, c.name, c.parent_id, c.sort_order
      from shop.category c
     where (c.parent_id = aparent_id or aparent_id is null)
$$;


ALTER FUNCTION api.categories_get(aparent_id integer) OWNER TO shop;

--
-- Name: category_get(character varying, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.category_get(aname character varying, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer := null;
    vparent_id integer;
    vname varchar;
begin
    raise notice '%', aname;
    for vname in select name from unnest(string_to_array(aname, '->')) name
    loop
        raise notice '%, %', vname, vparent_id;
        vid := api.category_id_get(vname, vparent_id);
        vparent_id := vid;
    end loop;

    return vid;
end;
$$;


ALTER FUNCTION api.category_get(aname character varying, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: category_id_get(character varying, integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.category_id_get(aname character varying, aparent_id integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    raise notice 'api.category_id_get(%, %)', aname, aparent_id;
    select c.id
      into vid
      from shop.category c
     where c.name = aname
       and c.parent_id is not distinct from aparent_id;

    if not found then
        insert into shop.category (name, parent_id)
        values (aname, aparent_id)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION api.category_id_get(aname character varying, aparent_id integer) OWNER TO shop;

--
-- Name: FUNCTION category_id_get(aname character varying, aparent_id integer); Type: COMMENT; Schema: api; Owner: shop
--

COMMENT ON FUNCTION api.category_id_get(aname character varying, aparent_id integer) IS 'Ruturns category id by name and parent_id, creates one if does not exist';


--
-- Name: category_json(text); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.category_json(acategory text) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select row_to_json(r) from (select name, image, sort_order from shop.category where name = acategory) r;
$$;


ALTER FUNCTION api.category_json(acategory text) OWNER TO shop;

--
-- Name: category_json_by_id(integer); Type: FUNCTION; Schema: api; Owner: migrator
--

CREATE FUNCTION api.category_json_by_id(acategory_id integer) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select row_to_json(r) from (select name, image, sort_order from shop.category where id = acategory_id) r;
$$;


ALTER FUNCTION api.category_json_by_id(acategory_id integer) OWNER TO migrator;

--
-- Name: category_update_image(integer, text); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.category_update_image(acategory_id integer, aimage text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update shop.category set image = aimage where id = acategory_id
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION api.category_update_image(acategory_id integer, aimage text) OWNER TO shop;

--
-- Name: FUNCTION category_update_image(acategory_id integer, aimage text); Type: COMMENT; Schema: api; Owner: shop
--

COMMENT ON FUNCTION api.category_update_image(acategory_id integer, aimage text) IS 'Updated image path for category with ID = acategory_id';


--
-- Name: diagrams_set(integer, json); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.diagrams_set(aproduct_id integer, adiagrams json) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vdiagram text; vlookup_no integer; vresult integer := 0;
begin
    for vdiagram, vlookup_no in (
        select diagram, lookup_no
          from json_to_recordset(adiagrams)
            as r(diagram text, lookup_no integer)
        )
    loop

        if not exists (
         select *
           from shop.product_diagram
          where product_id = aproduct_id
            and diagram = vdiagram
            and lookup_no = vlookup_no
        ) then

            insert into shop.product_diagram (product_id, diagram, lookup_no)
            values (aproduct_id, vdiagram, vlookup_no);

            vresult := vresult + 1;
        end if;
    end loop;

    return vresult;
end;
$$;


ALTER FUNCTION api.diagrams_set(aproduct_id integer, adiagrams json) OWNER TO shop;

--
-- Name: FUNCTION diagrams_set(aproduct_id integer, adiagrams json); Type: COMMENT; Schema: api; Owner: shop
--

COMMENT ON FUNCTION api.diagrams_set(aproduct_id integer, adiagrams json) IS 'Loads diagram from JSON into the database';


--
-- Name: get_product_id(character varying); Type: FUNCTION; Schema: api; Owner: migrator
--

CREATE FUNCTION api.get_product_id(asku character varying) RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.id from shop.product p where p.sku = asku;
$$;


ALTER FUNCTION api.get_product_id(asku character varying) OWNER TO migrator;

--
-- Name: FUNCTION get_product_id(asku character varying); Type: COMMENT; Schema: api; Owner: migrator
--

COMMENT ON FUNCTION api.get_product_id(asku character varying) IS 'Returns product ID by SKU';


--
-- Name: images_update(character varying, json); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.images_update(asku character varying, aimages json) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult integer;
begin
     select sum(api.product_image_set(asku, url, priority))
       into vresult
       from json_to_recordset(aimages)
         as r(url text, priority integer);

    return vresult;
end;
$$;


ALTER FUNCTION api.images_update(asku character varying, aimages json) OWNER TO shop;

--
-- Name: is_token_valid(character); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.is_token_valid(atoken character) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return exists (select * from api.token where token = atoken and dt_expire > now());
end;
$$;


ALTER FUNCTION api.is_token_valid(atoken character) OWNER TO shop;

--
-- Name: FUNCTION is_token_valid(atoken character); Type: COMMENT; Schema: api; Owner: shop
--

COMMENT ON FUNCTION api.is_token_valid(atoken character) IS 'Check API token';


--
-- Name: manufacturer_get(character varying, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.manufacturer_get(aname character varying, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    select id into vid from shop.manufacturer where name = aname;

    if vid is null and acreate_if_not_exists then
        insert into shop.manufacturer(name) values (aname)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION api.manufacturer_get(aname character varying, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: module_product_set(character varying, integer, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.module_product_set(amodule character varying, aproduct_id integer, ais_exported boolean) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    if ais_exported = true then
        delete from module.module_product where module = amodule and product_id = aproduct_id;
    else
        update module.module_product
           set is_exported = false
         where module = amodule
           and product_id = aproduct_id;

        if not found then
            insert into module.module_product(module, product_id, is_exported)
            values (amodule, aproduct_id, ais_exported);
        end if;
    end if;
end;
$$;


ALTER FUNCTION api.module_product_set(amodule character varying, aproduct_id integer, ais_exported boolean) OWNER TO shop;

--
-- Name: product_attrs_json(integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_attrs_json(aproduct_id integer) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select coalesce(json_agg((select x from (select ac.name category, a.name, v.value) x)), '[]'::json) as attributes
      from shop.attribute_value v
      join shop.attribute a
        on a.id = v.attribute_id
      join shop.attribute_category ac
        on ac.id = a.attribute_category_id
     where v.product_id = aproduct_id;
$$;


ALTER FUNCTION api.product_attrs_json(aproduct_id integer) OWNER TO shop;

--
-- Name: product_get(character varying, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_get(asku character varying, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    select id into vid from shop.product where sku = asku;

    if vid is null and acreate_if_not_exists then
        insert into shop.product (sku, name)
        values (asku, asku)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION api.product_get(asku character varying, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: product_group_set(integer, text, text); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_group_set(aproduct_id integer, amemonic text, aname text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vgroup_id integer; vid integer;
begin
    select id into vgroup_id
      from shop.product_group
     where mnemonic = amemonic;

    if vgroup_id is null then
        insert into shop.product_group(mnemonic, name)
        values (amemonic, aname)
        returning id into vgroup_id;
    end if;

    select id into vid
      from shop.products_in_group
     where group_id = vgroup_id
       and product_id = aproduct_id;

    if vid is null then
        insert into shop.products_in_group(product_id, group_id)
        values (aproduct_id, vgroup_id)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION api.product_group_set(aproduct_id integer, amemonic text, aname text) OWNER TO shop;

--
-- Name: product_groups_json(integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_groups_json(aproduct_id integer) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select coalesce(json_agg((select x from (select g.mnemonic, g.name) x)), '[]'::json) as images
      from shop.products_in_group pg
      join shop.product_group g on pg.group_id = g.id
     where pg.product_id = aproduct_id;
$$;


ALTER FUNCTION api.product_groups_json(aproduct_id integer) OWNER TO shop;

--
-- Name: product_image_set(character varying, character varying, integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_image_set(asku character varying, aurl character varying, apriority integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vproduct_id integer := api.product_get(asku, false);
    vresult integer;
begin
    if vproduct_id is null then
        return 0;
    end if;

    update shop.product_image
       set priority = apriority
     where product_id = vproduct_id
       and url = aurl;

    if not found then
        insert into shop.product_image(product_id, url, priority)
        values (vproduct_id, aurl, apriority);
    end if;

    return 1;
end;
$$;


ALTER FUNCTION api.product_image_set(asku character varying, aurl character varying, apriority integer) OWNER TO shop;

--
-- Name: product_images_json(integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_images_json(aproduct_id integer) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select coalesce(json_agg((select x from (select  i.priority, i.url) x)), '[]'::json) as images
      from shop.product_image i
     where i.product_id = aproduct_id;
$$;


ALTER FUNCTION api.product_images_json(aproduct_id integer) OWNER TO shop;

--
-- Name: category_path_as_arr(integer[]); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.category_path_as_arr(apath integer[]) RETURNS text[]
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select array_agg(c.name order by ordinality)
      from shop.category c
      join (select * from unnest(apath::int[]) with ordinality id) t using (id)
     where array[c.id] <@ apath;
$$;


ALTER FUNCTION shop.category_path_as_arr(apath integer[]) OWNER TO shop;

--
-- Name: category_path_as_text(integer[]); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.category_path_as_text(apath integer[]) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select array_to_string(shop.category_path_as_arr(apath), '->');
$$;


ALTER FUNCTION shop.category_path_as_text(apath integer[]) OWNER TO shop;

--
-- Name: product_json(character varying); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_json(asku character varying) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select row_to_json(t.*)
      from (
        select p.name,
               m.name manufacturer,
               c.name category,
               p.sku,
               d.description,
               p.gtin,
               api.product_images_json(p.id) as images,
               api.product_attrs_json(p.id) as attributes,
               shop.category_path_as_text(p.path) as categories,
               api.product_groups_json(p.id) as groups
          from shop.product p
          join shop.manufacturer m
            on m.id = p.manufacturer_id
          left join shop.product_description d
            on d.product_id = p.id
          left join shop.product_category pc
            on pc.product_id = p.id
          left join shop.category c
            on c.id = pc.category_id
         where p.sku = asku
        ) t;
$$;


ALTER FUNCTION api.product_json(asku character varying) OWNER TO shop;

--
-- Name: product_set(character varying, json, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_set(asku character varying, aproduct json, acreate_if_not_exists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult integer;
    vproduct_id integer := api.product_get(asku, acreate_if_not_exists);
    vmanufacturer_id integer := api.manufacturer_get((aproduct->'product'->>'manufacturer')::text, acreate_if_not_exists);
    vcategory_id integer := api.category_get((aproduct->'product'->>'categories')::text, acreate_if_not_exists);
begin
    if vproduct_id is null or vmanufacturer_id is null or vcategory_id is null then
        return null;
    end if;

    perform admin.product_description_set(vproduct_id, (aproduct->'product'->>'description')::text);

    update shop.product
       set name = aproduct->'product'->>'name',
           manufacturer_id = vmanufacturer_id,
           gtin = aproduct->'product'->>'gtin'
     where id = vproduct_id;

    update shop.product_category
       set category_id = vcategory_id
     where product_id = vproduct_id;

    if not found then
        insert into shop.product_category (product_id, category_id)
        values (vproduct_id, vcategory_id);
    end if;

    perform api.attributes_set(asku, aproduct->'product'->'attributes', acreate_if_not_exists);

    return vproduct_id;
end;
$$;


ALTER FUNCTION api.product_set(asku character varying, aproduct json, acreate_if_not_exists boolean) OWNER TO shop;

--
-- Name: product_sort_order_set(character varying, integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.product_sort_order_set(asku character varying, asort_order integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult integer;
begin
    update shop.product
       set sort_order = asort_order
     where sku = asku
    returning id into vresult;

    return vresult;
end;
$$;


ALTER FUNCTION api.product_sort_order_set(asku character varying, asort_order integer) OWNER TO shop;

--
-- Name: FUNCTION product_sort_order_set(asku character varying, asort_order integer); Type: COMMENT; Schema: api; Owner: shop
--

COMMENT ON FUNCTION api.product_sort_order_set(asku character varying, asort_order integer) IS 'Updates sort_order column value for product';


--
-- Name: set_available(character varying, integer); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.set_available(asku character varying, aavailable integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    update shop.product
       set available = aavailable
     where sku = asku;

    if found then
        return 1;
    else
        return 0;
    end if;
end;
$$;


ALTER FUNCTION api.set_available(asku character varying, aavailable integer) OWNER TO shop;

--
-- Name: set_available_bulk(json); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.set_available_bulk(adata json) RETURNS TABLE(asku character varying, aavailable integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vsku varchar; vavailable integer; vnew_value integer;
begin
    for vsku, vavailable in
    (
        select sku, available
          from json_to_recordset(adata)
            as r (sku varchar, available integer)
    ) loop
        update shop.product
           set available = vavailable
         where sku = vsku
        returning available into aavailable;
        asku := vsku;
        return next;
    end loop;
end;
$$;


ALTER FUNCTION api.set_available_bulk(adata json) OWNER TO shop;

--
-- Name: set_name(character varying, character varying); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.set_name(asku character varying, aname character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    update shop.product
       set name = aname
     where sku = asku;

    if found then
        return 1;
    else
        return 0;
    end if;
end;
$$;


ALTER FUNCTION api.set_name(asku character varying, aname character varying) OWNER TO shop;

--
-- Name: set_price(character varying, numeric); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.set_price(asku character varying, aprice numeric) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    update shop.product
       set price = aprice
     where sku = asku;

    if found then
        return 1;
    else
        return 0;
    end if;
end;
$$;


ALTER FUNCTION api.set_price(asku character varying, aprice numeric) OWNER TO shop;

--
-- Name: FUNCTION set_price(asku character varying, aprice numeric); Type: COMMENT; Schema: api; Owner: shop
--

COMMENT ON FUNCTION api.set_price(asku character varying, aprice numeric) IS 'Set price for product, returns 1 if product was found, otherwise it returns 0';


--
-- Name: set_product_name(integer, character varying); Type: FUNCTION; Schema: api; Owner: migrator
--

CREATE FUNCTION api.set_product_name(aid integer, aname character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    update shop.product set name = aname where id = aid;

    if found then
        return 0;
    else
        return -1;
    end if;
end;
$$;


ALTER FUNCTION api.set_product_name(aid integer, aname character varying) OWNER TO migrator;

--
-- Name: set_visibility(character varying, boolean); Type: FUNCTION; Schema: api; Owner: shop
--

CREATE FUNCTION api.set_visibility(asku character varying, ais_visible boolean) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    update shop.product
       set is_visible = ais_visible
     where sku = asku;

    if found then
        return 0;
    else
        return -1;
    end if;
end;
$$;


ALTER FUNCTION api.set_visibility(asku character varying, ais_visible boolean) OWNER TO shop;

--
-- Name: auth(integer); Type: FUNCTION; Schema: core; Owner: shop
--

CREATE FUNCTION core.auth(auser_id integer) RETURNS void
    LANGUAGE plpythonu
    AS $$
    GD['user_id'] = auser_id
$$;


ALTER FUNCTION core.auth(auser_id integer) OWNER TO shop;

--
-- Name: add_translation(text, text); Type: FUNCTION; Schema: i18n; Owner: shop
--

CREATE FUNCTION i18n.add_translation(aoriginal text, atranslation text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update i18n.translation_manual
       set translation = atranslation,
           dt_translated = now()
     where original = aoriginal
    returning id into vid;

    if not found then
        insert into i18n.translation_manual(original, translation, translator, dt_translated)
        values (aoriginal, atranslation, 'manual', now());
    end if;

    return vid;
end;
$$;


ALTER FUNCTION i18n.add_translation(aoriginal text, atranslation text) OWNER TO shop;

--
-- Name: get_translations(text); Type: FUNCTION; Schema: i18n; Owner: shop
--

CREATE FUNCTION i18n.get_translations(aoriginal text) RETURNS TABLE(id integer, original text, translation text, translator text, is_manual boolean)
    LANGUAGE sql SECURITY DEFINER
    AS $$
    select t.id, t.original, t.translation, t.translator, true
      from i18n.translation_manual t
     where lower(t.original) like lower(aoriginal) || '%'
    union all
    select t.id, t.original, t.translation, t.translator, false
      from i18n.translation t
     where lower(t.original) like lower(aoriginal) || '%'
     order by 2;
$$;


ALTER FUNCTION i18n.get_translations(aoriginal text) OWNER TO shop;

--
-- Name: update_translations(); Type: FUNCTION; Schema: i18n; Owner: shop
--

CREATE FUNCTION i18n.update_translations() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
declare
    vresult integer := 0;
    vtable_name varchar;
    voriginal_column varchar; vtranslated_column varchar;
    vsql text; vcount bigint;
begin
    vsql := $sql$
    with translations as (
        select coalesce(t.original, tm.original) as original,
               coalesce(tm.translation, t.translation) as translation
          from i18n.translation t
          full outer join i18n.translation_manual tm using(original)
    ), upd as (
        update %1$s u
           set %3$s = t.translation
          from translations t
         where u.%2$s = t.original
           and u.%3$s is distinct from t.translation
        returning *
    ) select count(*) from upd;
    $sql$;

    for vtable_name, voriginal_column, vtranslated_column in
        (select table_name, original_column, translated_column from i18n.translation_column) loop

        vsql := format(vsql, vtable_name, voriginal_column, vtranslated_column);

        execute vsql into vcount;
        vresult := vresult + vcount;
    end loop;

    return vresult;
end;
$_$;


ALTER FUNCTION i18n.update_translations() OWNER TO shop;

--
-- Name: FUNCTION update_translations(); Type: COMMENT; Schema: i18n; Owner: shop
--

COMMENT ON FUNCTION i18n.update_translations() IS 'Translates all columns in database; returns counts of rows affected';


--
-- Name: is_enabled(character varying); Type: FUNCTION; Schema: module; Owner: shop
--

CREATE FUNCTION module.is_enabled(amodule character varying) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    AS $$
    select exists (select * from module.config where module = amodule and is_enabled = true);
$$;


ALTER FUNCTION module.is_enabled(amodule character varying) OWNER TO shop;

--
-- Name: read_config(character varying); Type: FUNCTION; Schema: module; Owner: shop
--

CREATE FUNCTION module.read_config(amodule character varying) RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select config from module.config where module = amodule;
$$;


ALTER FUNCTION module.read_config(amodule character varying) OWNER TO shop;

--
-- Name: write_config(character varying, json); Type: FUNCTION; Schema: module; Owner: shop
--

CREATE FUNCTION module.write_config(amodule character varying, aconfig json) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    update module.config
       set config = aconfig
     where module = amodule
    returning id into vid;

    if not found then
        insert into module.config(module, config)
        values (amodule, aconfig)
        returning id into vid;
    end if;

    return vid;
end;
$$;


ALTER FUNCTION module.write_config(amodule character varying, aconfig json) OWNER TO shop;

--
-- Name: create_user_if_not_exists(text); Type: FUNCTION; Schema: public; Owner: migrator
--

CREATE FUNCTION public.create_user_if_not_exists(auser text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  EXECUTE FORMAT('CREATE USER %s', auser);
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'User % already exists', auser;
END;
$$;


ALTER FUNCTION public.create_user_if_not_exists(auser text) OWNER TO migrator;

--
-- Name: after_order_spam_check(integer); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.after_order_spam_check(aorder_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
    vip inet; vOrdersToday bigint; vOrdersTotal bigint;
begin
    select ip into vip from shop.customer_order where id = aorder_id;

    if not found or vip = '127.0.0.1' then
        return false;
    end if;

    /* Customer should be blocked if he or she made more than 3 orders during one day
       or more than 5 orders in total */
    select sum(case when dt_create > now() - interval '1 day' then 1 else 0 end),
           sum(1)
      into vOrdersToday, vOrdersTotal
      from shop.customer_order
     where ip = vip;

    if vOrdersTotal >= 5 or vOrdersToday >= 3 then
        /* Block it */
        insert into shop.black_list(ip, is_auto)
        values (vip, true);

        return true;
    end if;

    return false;
end;
$$;


ALTER FUNCTION shop.after_order_spam_check(aorder_id integer) OWNER TO shop;

--
-- Name: FUNCTION after_order_spam_check(aorder_id integer); Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON FUNCTION shop.after_order_spam_check(aorder_id integer) IS 'Check if client should be blocked and blocks it';


--
-- Name: get_customer_id(character); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.get_customer_id(acustomer_secret character) RETURNS integer
    LANGUAGE sql
    AS $$
    select id from shop.customer where secret = acustomer_secret;
$$;


ALTER FUNCTION shop.get_customer_id(acustomer_secret character) OWNER TO shop;

--
-- Name: get_new_sef_name(integer, character varying); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.get_new_sef_name(aproduct_id integer, aname character varying) RETURNS character varying
    LANGUAGE plpgsql STABLE
    AS $$
declare
    vsef_name varchar;
begin
    vsef_name := substring(web.sef_from_text(aname) for 126);

    if not exists (select * from shop.product where sef_name = vsef_name) then
        return vsef_name;
    else
        return null;
    end if;
end;
$$;


ALTER FUNCTION shop.get_new_sef_name(aproduct_id integer, aname character varying) OWNER TO shop;

--
-- Name: FUNCTION get_new_sef_name(aproduct_id integer, aname character varying); Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON FUNCTION shop.get_new_sef_name(aproduct_id integer, aname character varying) IS 'Returns new sef name for a product';


--
-- Name: human_size_as_mb(character varying); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.human_size_as_mb(ahuman_size character varying) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
    select regexp_replace(ahuman_size, '\D', '', 'g')::int *
           (case when position('Мб' in ahuman_size) > 0 then 1
                 when position('Гб' in ahuman_size) > 0 then 1024
            else 0 end)
$$;


ALTER FUNCTION shop.human_size_as_mb(ahuman_size character varying) OWNER TO shop;

--
-- Name: tau_category(); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.tau_category() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vids integer[];
begin
    /*
        Updates product paths when category parent_id changed
    */
    if new.parent_id is distinct from old.parent_id then

        select array_agg(n)
          into vids
          from (select unnest(array[old.parent_id, new.parent_id, new.id]) n) t
         where n is not null;

        update shop.product p
           set path = web.product_path_get(p.id)
         where p.path && vids;
    end if;

    return new;
end;
$$;


ALTER FUNCTION shop.tau_category() OWNER TO shop;

--
-- Name: tbu_product(); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.tbu_product() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    new.update_user_id := core.get_current_user();

    return new;
end;
$$;


ALTER FUNCTION shop.tbu_product() OWNER TO shop;

--
-- Name: ti_product(); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.ti_product() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    new.sef_name := shop.get_new_sef_name(new.id, new.name);

    return new;
end;
$$;


ALTER FUNCTION shop.ti_product() OWNER TO shop;

--
-- Name: FUNCTION ti_product(); Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON FUNCTION shop.ti_product() IS 'Trigger to update sef_name before insert on product';


--
-- Name: ti_product_history(); Type: FUNCTION; Schema: shop; Owner: migrator
--

CREATE FUNCTION shop.ti_product_history() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    insert into stat.product_price_history (product_id, price)
    values (new.id, new.price);

    insert into stat.product_available_history (product_id, available)
    values (new.id, new.available);

    return new;
end;
$$;


ALTER FUNCTION shop.ti_product_history() OWNER TO migrator;

--
-- Name: tidu_product_category(); Type: FUNCTION; Schema: shop; Owner: migrator
--

CREATE FUNCTION shop.tidu_product_category() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    r record;
begin
    if TG_OP = 'DELETE' then
        r := old;
    else
        r := new;
    end if;

    update shop.product set path = web.product_path_get(r.product_id) where id = r.product_id;

    return r;
end;
$$;


ALTER FUNCTION shop.tidu_product_category() OWNER TO migrator;

--
-- Name: tu_product_available(); Type: FUNCTION; Schema: shop; Owner: migrator
--

CREATE FUNCTION shop.tu_product_available() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    if new.available is distinct from old.available then
        insert into stat.product_available_history (product_id, available)
        values (new.id, new.available);
    end if;

    return new;
end;
$$;


ALTER FUNCTION shop.tu_product_available() OWNER TO migrator;

--
-- Name: tu_product_name(); Type: FUNCTION; Schema: shop; Owner: shop
--

CREATE FUNCTION shop.tu_product_name() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    new.sef_name := shop.get_new_sef_name(new.id, new.name);

    return new;
end;
$$;


ALTER FUNCTION shop.tu_product_name() OWNER TO shop;

--
-- Name: FUNCTION tu_product_name(); Type: COMMENT; Schema: shop; Owner: shop
--

COMMENT ON FUNCTION shop.tu_product_name() IS 'Trigger to update sef_name after update name for a product';


--
-- Name: tu_product_price(); Type: FUNCTION; Schema: shop; Owner: migrator
--

CREATE FUNCTION shop.tu_product_price() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    if new.price is distinct from old.price then
        insert into stat.product_price_history (product_id, price)
        values (new.id, new.price);
    end if;

    return new;
end;
$$;


ALTER FUNCTION shop.tu_product_price() OWNER TO migrator;

--
-- Name: product_stat_update(integer, integer, integer, integer); Type: FUNCTION; Schema: stat; Owner: shop
--

CREATE FUNCTION stat.product_stat_update(aproduct_id integer, aviewed integer, aadded_to_cart integer, aordered integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vproduct_id integer;
begin
    select p.id into vproduct_id
      from shop.product p
     where p.id = aproduct_id for update;

    update shop.product set viewed = viewed + aviewed where id = aproduct_id;

    update stat.product_stat
       set viewed = viewed + aviewed,
           added_to_cart = added_to_cart + aadded_to_cart,
           ordered = aordered + aordered
     where product_id = aproduct_id
       and dt = current_date;

    if not found then
        insert into stat.product_stat(product_id, viewed, added_to_cart, ordered)
        values (aproduct_id, aviewed, aadded_to_cart, aordered);
    end if;

    return vproduct_id;
end;
$$;


ALTER FUNCTION stat.product_stat_update(aproduct_id integer, aviewed integer, aadded_to_cart integer, aordered integer) OWNER TO shop;

--
-- Name: FUNCTION product_stat_update(aproduct_id integer, aviewed integer, aadded_to_cart integer, aordered integer); Type: COMMENT; Schema: stat; Owner: shop
--

COMMENT ON FUNCTION stat.product_stat_update(aproduct_id integer, aviewed integer, aadded_to_cart integer, aordered integer) IS 'Updates product stats';


--
-- Name: add_product_to_cart(character, integer, smallint); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.add_product_to_cart(acustomer_secret character, aproduct_id integer, aquantity smallint DEFAULT 1, OUT oid integer, OUT ototal_count integer, OUT ototal_amount numeric) RETURNS record
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vresult integer; vcustomer_id integer := shop.get_customer_id(acustomer_secret);
begin
    update shop.cart
       set quantity = quantity + 1
     where customer_id = vcustomer_id
       and product_id = aproduct_id
    returning id into oid;

    if not found then
        insert into shop.cart (customer_id, product_id, quantity)
        values (vcustomer_id, aproduct_id, aquantity)
        returning id into oid;
    end if;

    select sum(quantity)
      into ototal_count
      from shop.cart
     where customer_id = vcustomer_id;
end;
$$;


ALTER FUNCTION web.add_product_to_cart(acustomer_secret character, aproduct_id integer, aquantity smallint, OUT oid integer, OUT ototal_count integer, OUT ototal_amount numeric) OWNER TO shop;

--
-- Name: attribute_categories_get(integer[]); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.attribute_categories_get(afor_attr integer[] DEFAULT NULL::integer[]) RETURNS TABLE(id integer, name character varying)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    if afor_attr is null then
        return query
        select c.id, c.name::varchar
          from shop.attribute_category c
         order by c.priority;
    else
        return query
        select c.id, c.name::varchar
          from shop.attribute_category c
         where exists (
          select *
            from shop.attribute a
           where a.id = any(afor_attr) and a.attribute_category_id = c.id
         )
         order by c.priority;
    end if;
end;
$$;


ALTER FUNCTION web.attribute_categories_get(afor_attr integer[]) OWNER TO shop;

--
-- Name: categories_for_export_get(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.categories_for_export_get(amodule character varying) RETURNS TABLE(id integer, name character varying, parent_id integer)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select c.id, c.name, c.parent_id
      from shop.category c
     where not exists (
        select *
          from module.module_category mc
         where mc.module = amodule
           and mc.category_id = c.id
           and mc.is_exported = false
       )
     order by c.id;
$$;


ALTER FUNCTION web.categories_for_export_get(amodule character varying) OWNER TO shop;

--
-- Name: FUNCTION categories_for_export_get(amodule character varying); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.categories_for_export_get(amodule character varying) IS 'Returns list of categories for given export module';


--
-- Name: category_has_childs(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.category_has_childs(acategory_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    return (select exists (select * from shop.category where parent_id = acategory_id));
end;
$$;


ALTER FUNCTION web.category_has_childs(acategory_id integer) OWNER TO shop;

--
-- Name: FUNCTION category_has_childs(acategory_id integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.category_has_childs(acategory_id integer) IS 'Whether category has childs';


--
-- Name: category_path(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.category_path(aid integer) RETURNS integer[]
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select case when c.parent_id is null then array[c.id]::integer[]
           else array[c.parent_id, c.id]::integer[]
           end
      from shop.category c
     where c.id = aid;
$$;


ALTER FUNCTION web.category_path(aid integer) OWNER TO shop;

--
-- Name: FUNCTION category_path(aid integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.category_path(aid integer) IS 'Returns category path as array';


--
-- Name: create_fast_order(integer, text, text, inet); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.create_fast_order(aproduct_id integer, aemail text, aphone text, aip inet, OUT oid integer, OUT otoken character) RETURNS record
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vcustomer_id integer;
    vamount numeric;
begin
    /*
       We do not need add product to cart while processing fast order, but we need
       to create a fake customer
    */
    insert into shop.customer (secret) values (default)
    returning id into vcustomer_id;

    insert into shop.customer_order (customer_id, email, phone, name, city, address, ip)
    values (vcustomer_id, aemail, aphone, 'Лидогенератор', 'не указан', 'не указан', aip)
    returning id, token into oid, otoken;

    insert into shop.order_item (order_id, product_id, price, quantity, amount)
    select oid, aproduct_id, p.price, 1, p.price
    from shop.product p where p.id = aproduct_id
    returning amount into vamount;

    if not found then
        raise exception 'Product % not found', aproduct_id;
    end if;

    update shop.customer_order set amount = vamount where id = oid;
end;
$$;


ALTER FUNCTION web.create_fast_order(aproduct_id integer, aemail text, aphone text, aip inet, OUT oid integer, OUT otoken character) OWNER TO shop;

--
-- Name: FUNCTION create_fast_order(aproduct_id integer, aemail text, aphone text, aip inet, OUT oid integer, OUT otoken character); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.create_fast_order(aproduct_id integer, aemail text, aphone text, aip inet, OUT oid integer, OUT otoken character) IS 'Creates fast order ignoring adding products to cart; creates new fake customer implicitly';


--
-- Name: create_order(character, character varying, character varying, character varying, character varying, character varying, inet, character varying, character varying, character varying, numeric, character varying, character varying, integer); Type: FUNCTION; Schema: web; Owner: migrator
--

CREATE FUNCTION web.create_order(acustomer_secret character, aemail character varying, aphone character varying, aname character varying, acity character varying, aaddress character varying, aip inet, auser_agent character varying, adelivery_code character varying, adelivery_name character varying, adelivery_cost numeric, alast_name character varying, apatronymic_name character varying, apayment_method_id integer, OUT oid integer, OUT otoken character) RETURNS record
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vcustomer_id integer := shop.get_customer_id(acustomer_secret);
    vorder_id integer; vamount numeric;
begin
    -- Заказ создаётся на основе содержимого корзины

    if (select count(*) from shop.cart where customer_id = vcustomer_id) = 0 then
        oid := -1;
        return;
    end if;

    insert into shop.customer_order(customer_id, email, phone, name, city,
        address, ip, user_agent, delivery_code, delivery_name, delivery_cost,
        last_name, patronymic_name, payment_method_id)
    values (vcustomer_id, aemail, aphone, aname, acity, aaddress, aip,
        auser_agent, adelivery_code, adelivery_name, adelivery_cost,
        alast_name, apatronymic_name, apayment_method_id)
    returning id, token into oid, otoken;

    -- Добавляем товары из корзины в заказ
    insert into shop.order_item (order_id, product_id, price, quantity, amount)
    select oid, c.product_id, p.price, c.quantity, round(c.quantity * p.price, 2)
      from shop.cart c
      join shop.product p
        on p.id = c.product_id
     where c.customer_id = vcustomer_id
     order by p.id;

    -- Обновляем итоговую сумму в заказе
    update shop.customer_order
       set amount = (select sum(amount) from shop.order_item where order_id = oid)
     where id = oid;

    -- Очищаем корзину
    delete from shop.cart where customer_id = vcustomer_id;

    perform shop.after_order_spam_check(oid);
end;
$$;


ALTER FUNCTION web.create_order(acustomer_secret character, aemail character varying, aphone character varying, aname character varying, acity character varying, aaddress character varying, aip inet, auser_agent character varying, adelivery_code character varying, adelivery_name character varying, adelivery_cost numeric, alast_name character varying, apatronymic_name character varying, apayment_method_id integer, OUT oid integer, OUT otoken character) OWNER TO migrator;

--
-- Name: create_payment(character varying, integer, shop.t_currency, numeric, inet, character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.create_payment(aservice character varying, aorder_id integer, acurrency shop.t_currency, aamount numeric, aip inet, aexternal_id character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    insert into shop.payment(service, order_id, currency, amount, ip, external_id)
    values (aservice, aorder_id, acurrency, aamount, aip, aexternal_id)
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION web.create_payment(aservice character varying, aorder_id integer, acurrency shop.t_currency, aamount numeric, aip inet, aexternal_id character varying) OWNER TO shop;

--
-- Name: FUNCTION create_payment(aservice character varying, aorder_id integer, acurrency shop.t_currency, aamount numeric, aip inet, aexternal_id character varying); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.create_payment(aservice character varying, aorder_id integer, acurrency shop.t_currency, aamount numeric, aip inet, aexternal_id character varying) IS 'Creates a new payment';


--
-- Name: export(character varying, boolean); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.export(amodule character varying, available_only boolean DEFAULT false) RETURNS TABLE(id integer, name character varying, price integer, old_price integer, description character varying, main_image text, category_id integer, category_name character varying, manufacturer_id integer, manufacturer_name character varying, available integer, attributes json, url character varying, sku character varying, previous_price integer, images json, image_thumbs json)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select p.id,
           p.name::varchar,
           p.price::integer,
           p.price::integer,
           pd.description::varchar,
           web.get_product_main_image(p.id),
           pc.category_id,
           c.name::varchar,
           p.manufacturer_id, m.name::varchar,
           p.available,
           coalesce((select json_agg(f.*) from web.get_product_card_attributes(p.id) f), '[]'::json),
           web.product_url_get(p.id),
           p.sku::varchar,
           p.previous_price::integer,
           coalesce((select json_agg(f.*) from web.get_product_images(p.id) f), '[]'::json),
           coalesce((select json_agg(f.*) from web.get_product_images(p.id, 200) f), '[]'::json)
      from shop.product p
      join shop.product_category pc on pc.product_id = p.id
      join shop.category c on c.id = pc.category_id
      left join shop.product_description pd on pd.product_id = p.id
      join shop.manufacturer m on m.id = p.manufacturer_id
     where (p.available > 0 or available_only = false)
       and (p.is_visible)
       and p.dt_deleted is null
       and p.is_exported
       and not exists (
        select *
          from module.module_category mc
         where mc.module = amodule
           and mc.category_id = pc.category_id
           and mc.is_exported = false
       )
       and not exists (
        select *
          from module.module_product mp
         where mp.module = amodule
           and mp.product_id = p.id
           and mp.is_exported = false
       );
end;
$$;


ALTER FUNCTION web.export(amodule character varying, available_only boolean) OWNER TO shop;

--
-- Name: FUNCTION export(amodule character varying, available_only boolean); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.export(amodule character varying, available_only boolean) IS 'Export products, used by export plugins';


--
-- Name: export_stat(date); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.export_stat(aday date DEFAULT ('now'::text)::date) RETURNS TABLE(sku character varying, name character varying, viewed integer, added_to_cart integer, ordered integer)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.sku, p.name, s.viewed, s.added_to_cart, s.ordered
      from stat.product_stat s
      join shop.product p on p.id = s.product_id
     where s.dt = aday
       and s.viewed > 0
     order by s.viewed desc;
$$;


ALTER FUNCTION web.export_stat(aday date) OWNER TO shop;

--
-- Name: FUNCTION export_stat(aday date); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.export_stat(aday date) IS 'Exports product stat for mailing and so on';


--
-- Name: feedback_add(character varying, character varying, inet, smallint); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.feedback_add(aname character varying, amessage character varying, aip inet, arate smallint DEFAULT 5) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vid integer;
begin
    insert into shop.feedback (name, message, ip, rate)
    values (aname, amessage, aip, arate)
    returning id into vid;

    return vid;
end;
$$;


ALTER FUNCTION web.feedback_add(aname character varying, amessage character varying, aip inet, arate smallint) OWNER TO shop;

--
-- Name: get_attributes(integer); Type: FUNCTION; Schema: web; Owner: migrator
--

CREATE FUNCTION web.get_attributes(aproduct_id integer) RETURNS TABLE(category_id integer, category_name character varying, id integer, name character varying, value character varying, description character varying, priority integer)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select c.id, c.name::varchar, a.id, a.name::varchar, v.value::varchar,
         a.description::varchar, a.priority
      from shop.attribute_value v
      join shop.attribute a on a.id = v.attribute_id
      join shop.attribute_category c on c.id = a.attribute_category_id
     where v.product_id = aproduct_id
     order by a.priority;
end;
$$;


ALTER FUNCTION web.get_attributes(aproduct_id integer) OWNER TO migrator;

--
-- Name: get_banners(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_banners() RETURNS TABLE(id integer, image_url character varying, priority integer, href character varying, title character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select b.id, b.image_url, b.priority, b.href, b.title
      from shop.banner b
     where b.is_visible
     order by b.priority;
$$;


ALTER FUNCTION web.get_banners() OWNER TO shop;

--
-- Name: FUNCTION get_banners(); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_banners() IS 'Returns banners for site main page';


--
-- Name: get_breadcrumbs(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_breadcrumbs(acategory_id integer) RETURNS TABLE(id integer, name text, parent_id integer, level integer, root_id integer, path integer[], spath text[])
    LANGUAGE sql SECURITY DEFINER
    AS $$
with recursive r as (
    select id, name, parent_id, 1 as level, id as root_id, array[id] as path, array[name] as spath
      from shop.category
     where id = acategory_id
    union
    select c.id, c.name, c.parent_id, r.level + 1 as level, r.path[1], r.path || c.id as path, r.spath || array[c.name] as spath
      from shop.category c
      join r on r.parent_id = c.id
)
select * from r;
$$;


ALTER FUNCTION web.get_breadcrumbs(acategory_id integer) OWNER TO shop;

--
-- Name: get_cart(character); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_cart(acustomer_secret character) RETURNS TABLE(id integer, product_id integer, quantity smallint, price numeric, amount numeric, sku character varying, name character varying, description character varying, image character varying, product_url character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vcustomer_id integer := shop.get_customer_id(acustomer_secret);
begin
    return query
    with cart as (
        select c.id,
               c.product_id,
               c.quantity,
               p.price,
               round(p.price * c.quantity, 2) as amount,
               p.sku::varchar,
               p.name::varchar,
               d.description::varchar as description,
               web.get_product_main_image(c.product_id)::varchar,
               web.product_url_get(c.product_id)::varchar
          from shop.cart c
          join shop.product p
            on p.id = c.product_id
          left join shop.product_description d on d.product_id = p.id
         where c.customer_id = vcustomer_id
         order by c.dt_added
     ) select * from cart c union all
       select -1, null, sum(c_total.quantity)::smallint, null,
              sum(c_total.amount), null, null, null, null, null from cart c_total;
end;
$$;


ALTER FUNCTION web.get_cart(acustomer_secret character) OWNER TO shop;

--
-- Name: get_cart_total(character); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_cart_total(acustomer_secret character, OUT oquantity smallint, OUT oamount numeric) RETURNS record
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
declare
    vcustomer_id integer := shop.get_customer_id(acustomer_secret);
begin
    select coalesce(sum(c.quantity), 0)::smallint,
           coalesce(sum(round(p.price * c.quantity, 2)), 0)
      into oquantity, oamount
      from shop.cart c
      join shop.product p on p.id = c.product_id
     where c.customer_id = vcustomer_id;
end;
$$;


ALTER FUNCTION web.get_cart_total(acustomer_secret character, OUT oquantity smallint, OUT oamount numeric) OWNER TO shop;

--
-- Name: get_categories(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_categories(aparent_id integer) RETURNS TABLE(id integer, parent_id integer, name character varying, image character varying, sef_name character varying, url character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select c.id, c.parent_id, c.name, c.image, c.sef_name,
           case when c.sef_name is null then '/category/' || id::varchar
                else '/category/' || c.sef_name
           end
      from shop.category c
     where c.parent_id is not distinct from aparent_id
       -- and exists (select *
       --               from shop.product_category pc
       --               join shop.product p on p.id = pc.product_id
       --              where pc.category_id = c.id
       --                and p.is_visible
       --             )
    order by c.sort_order, c.name;
$$;


ALTER FUNCTION web.get_categories(aparent_id integer) OWNER TO shop;

--
-- Name: get_category(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_category(aid integer) RETURNS TABLE(id integer, name character varying, image character varying, sef_name character varying, url character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select c.id, c.name, c.image, c.sef_name,
           case when c.sef_name is null then '/category/' || id::varchar
                else '/category/' || c.sef_name
           end
      from shop.category c
     where c.id = aid;
$$;


ALTER FUNCTION web.get_category(aid integer) OWNER TO shop;

--
-- Name: get_category_by_sef(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_category_by_sef(asef character varying) RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select c.id from shop.category c where sef_name = asef;
$$;


ALTER FUNCTION web.get_category_by_sef(asef character varying) OWNER TO shop;

--
-- Name: get_category_url(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_category_url(aid integer) RETURNS character varying
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select case when c.sef_name is null then '/category/' || id::varchar
                else '/category/' || c.sef_name
           end
      from shop.category c
     where c.id = aid;
$$;


ALTER FUNCTION web.get_category_url(aid integer) OWNER TO shop;

--
-- Name: get_config(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_config() RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select json_object_agg(parameter, value) from shop.config;
$$;


ALTER FUNCTION web.get_config() OWNER TO shop;

--
-- Name: russian_date(date); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.russian_date(adate date) RETURNS text
    LANGUAGE sql STABLE
    AS $$

select  (to_char(adate, 'dd')::int)::text || ' ' ||
        case when to_char(adate, 'mm') = '01' then 'января'
            when to_char(adate, 'mm') = '02' then 'февраля'
            when to_char(adate, 'mm') = '03' then 'марта'
            when to_char(adate, 'mm') = '04' then 'апреля'
            when to_char(adate, 'mm') = '05' then 'мая'
            when to_char(adate, 'mm') = '06' then 'июня'
            when to_char(adate, 'mm') = '07' then 'июля'
            when to_char(adate, 'mm') = '08' then 'августа'
            when to_char(adate, 'mm') = '09' then 'сентярбя'
            when to_char(adate, 'mm') = '10' then 'октября'
            when to_char(adate, 'mm') = '11' then 'ноября'
            when to_char(adate, 'mm') = '12' then 'декабря'
       end;
$$;


ALTER FUNCTION web.russian_date(adate date) OWNER TO shop;

--
-- Name: get_dates_for_orders(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_dates_for_orders(alimit integer DEFAULT 90) RETURNS TABLE(russian_date character varying, dt date)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select distinct(web.russian_date(dt_create::date)),
           dt_create::date
      from shop.customer_order
     group by 1, 2 order by 2 desc
     limit alimit;
$$;


ALTER FUNCTION web.get_dates_for_orders(alimit integer) OWNER TO shop;

--
-- Name: get_diagram(character varying, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_diagram(adiagram character varying, avehicle_id integer) RETURNS TABLE(product_id integer, product_name character varying, product_sku character varying, product_description text, product_price numeric, lookup_no smallint)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select pd.product_id,
           p.name,
           p.sku,
           web.get_product_description(p.id),
           p.price,
           pd.lookup_no
      from shop.product_diagram pd
      join shop.product p on p.id = pd.product_id
     where pd.diagram = adiagram
       and p.sku like '%-' || avehicle_id::text
    order by pd.lookup_no;
$$;


ALTER FUNCTION web.get_diagram(adiagram character varying, avehicle_id integer) OWNER TO shop;

--
-- Name: get_feedback(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_feedback() RETURNS TABLE(id integer, dt_added timestamp with time zone, name character varying, message text, rate smallint)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select f.id, f.dt_added, f.name, f.message, f.rate
      from shop.feedback f
     where f.is_published
     order by f.dt_added desc;
$$;


ALTER FUNCTION web.get_feedback() OWNER TO shop;

--
-- Name: get_filters(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_filters() RETURNS json
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select coalesce(json_agg((select x from (select attribute_id, name, operator, distinct_values, position) x) order by position), '{}'::json)
      from shop.filter
     where is_enabled;
$$;


ALTER FUNCTION web.get_filters() OWNER TO shop;

--
-- Name: get_menu(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_menu(aposition character varying DEFAULT 'left'::character varying) RETURNS TABLE(id integer, title character varying, url character varying, parent_id integer, pos character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select m.id, m.title, m.url, m.parent_id, m.position
      from shop.menu m
     where (m.position = aposition or aposition is null)
     order by m.priority;
$$;


ALTER FUNCTION web.get_menu(aposition character varying) OWNER TO shop;

--
-- Name: FUNCTION get_menu(aposition character varying); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_menu(aposition character varying) IS 'Returns menu for website';

--
-- Name: has_category_products(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.has_category_products(acategory_id integer) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select exists (
        select *
          from shop.product p
         where array[acategory_id] <@ p.path
           and p.is_visible
           and p.dt_deleted is null
    );
$$;


ALTER FUNCTION web.has_category_products(acategory_id integer) OWNER TO shop;


--
-- Name: get_order(integer, character varying); Type: FUNCTION; Schema: web; Owner: migrator
--

CREATE FUNCTION web.get_order(aid integer, atoken character varying) RETURNS TABLE(id integer, customer_id integer, dt_create timestamp with time zone, amount numeric, status shop.t_order_status, status_name character varying, email character varying, phone character varying, name character varying, ip inet, city character varying, address character varying, delivery_cost numeric, token character, subtotal numeric, total numeric, delivery_code character varying, delivery_name character varying, last_name character varying, patronymic_name character varying, payment_method_id integer, payment_method_code character varying, payment_method_name character varying)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select o.id, o.customer_id, o.dt_create, o.amount, o.status, web.get_status_name(o.status),
           o.email, o.phone, o.name, o.ip, o.city, o.address, coalesce(o.delivery_cost, 0), o.token,
           o.amount, o.amount + o.delivery_cost, o.delivery_code, o.delivery_name,
           o.last_name, o.patronymic_name, o.payment_method_id, p.code as payment_method_code,
           p.name as payment_method_name
      from shop.customer_order o
      left join shop.payment_method p on p.id = o.payment_method_id
     where o.id = aid;
end;
$$;


ALTER FUNCTION web.get_order(aid integer, atoken character varying) OWNER TO migrator;

--
-- Name: get_order_for_customer(integer, character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_order_for_customer(aid integer, asecret character varying) RETURNS TABLE(id integer, dt_create timestamp with time zone, amount numeric, email character varying, phone character varying, name character varying, address character varying, delivery_cost numeric, token character)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select o.id, o.dt_create, o.amount,
           o.email, o.phone, o.name, o.address, o.delivery_cost, o.token
      from shop.customer_order o
      join shop.customer c on c.id = o.customer_id
     where o.id = aid and c.secret = asecret;
end;
$$;


ALTER FUNCTION web.get_order_for_customer(aid integer, asecret character varying) OWNER TO shop;

--
-- Name: get_order_items(integer, character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_order_items(aorder_id integer, atoken character varying) RETURNS TABLE(id integer, product_id integer, product_sku character varying, quantity integer, price numeric, amount numeric, name character varying)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select i.id, i.product_id, p.sku::varchar, i.quantity, i.price, i.amount, p.name::varchar
      from shop.order_item i
      join shop.product p on p.id = i.product_id
      join shop.customer_order o on o.id = i.order_id
     where i.order_id = aorder_id
     order by i.id;
end;
$$;


ALTER FUNCTION web.get_order_items(aorder_id integer, atoken character varying) OWNER TO shop;

--
-- Name: get_orders(shop.t_order_status, date); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_orders(astatus shop.t_order_status DEFAULT 'new'::shop.t_order_status, adate date DEFAULT ('now'::text)::date) RETURNS TABLE(id integer, customer_id integer, dt_create timestamp with time zone, amount numeric, status shop.t_order_status, status_name character varying, email character varying, phone character varying, name character varying, ip inet, address character varying, delivery_cost numeric)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select o.id, o.customer_id, o.dt_create, o.amount, o.status, web.get_status_name(o.status),
           o.email, o.phone, o.name, o.ip, o.address, o.delivery_cost
      from shop.customer_order o
     where (o.status = astatus or astatus is null)
       and ((o.dt_create between adate::timestamptz and (adate + interval '1 day')::timestamptz) or adate is null)
    order by o.id desc;
end;
$$;


ALTER FUNCTION web.get_orders(astatus shop.t_order_status, adate date) OWNER TO shop;

--
-- Name: get_parameter_value(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_parameter_value(aparameter character varying) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  select value from shop.config where parameter = aparameter;
$$;


ALTER FUNCTION web.get_parameter_value(aparameter character varying) OWNER TO shop;

--
-- Name: get_popular_products(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_popular_products(alimit integer DEFAULT 10) RETURNS integer[]
    LANGUAGE sql SECURITY DEFINER
    AS $$
    select array_agg(p.id order by p.name)
      from shop.product p
      join shop.products_in_group pg on pg.product_id = p.id
      join shop.product_group g on g.id = pg.group_id
     where g.mnemonic = 'popular'
       and p.is_visible
       and p.dt_deleted is null
$$;


ALTER FUNCTION web.get_popular_products(alimit integer) OWNER TO shop;

--
-- Name: FUNCTION get_popular_products(alimit integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_popular_products(alimit integer) IS 'Returns popular products for main page';


--
-- Name: get_product_card_attributes(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_card_attributes(aproduct_id integer) RETURNS TABLE(category_id integer, category_name character varying, id integer, name character varying, value character varying)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select c.id, c.name::varchar, a.id, a.name::varchar, v.value::varchar
      from shop.attribute_value v
      join shop.attribute a on a.id = v.attribute_id
      join shop.attribute_category c on c.id = a.attribute_category_id
     where v.product_id = aproduct_id
       and a.in_product_card = true;
end;
$$;


ALTER FUNCTION web.get_product_card_attributes(aproduct_id integer) OWNER TO shop;

--
-- Name: FUNCTION get_product_description(aproduct_id integer, achars_limit integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_product_description(aproduct_id integer, achars_limit integer) IS 'Returns product description';


--
-- Name: get_product_group_id(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_group_id(amnemonic character varying) RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.id from shop.product_group p where mnemonic = amnemonic;
$$;


ALTER FUNCTION web.get_product_group_id(amnemonic character varying) OWNER TO shop;

--
-- Name: get_product_group_name(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_group_name(aid integer) RETURNS character varying
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.name from shop.product_group p where id = aid;
$$;


ALTER FUNCTION web.get_product_group_name(aid integer) OWNER TO shop;

--
-- Name: get_product_id(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_id(asku character varying) RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.id from shop.product p where p.sku = asku;
$$;


ALTER FUNCTION web.get_product_id(asku character varying) OWNER TO shop;

--
-- Name: FUNCTION get_product_id(asku character varying); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_product_id(asku character varying) IS 'Returns product ID by SKU';


--
-- Name: get_product_images(integer, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_product_images(aproduct_id integer, asize integer DEFAULT '-1'::integer) RETURNS TABLE(id integer, url character varying, priority integer)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select i.id,
           case when asize = - 1 then i.url
           else replace(i.url, '/static/image/product/', '/static/image/product/' || asize::text || '/')
           end,
           i.priority
      from shop.product_image i
     where i.product_id = aproduct_id
    order by i.priority;
$$;


ALTER FUNCTION web.get_product_images(aproduct_id integer, asize integer) OWNER TO shop;

--
-- Name: FUNCTION get_product_images(aproduct_id integer, asize integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_product_images(aproduct_id integer, asize integer) IS 'Returns all images for product, sorted by priority';


--
-- Name: get_products(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_products(acategory_id integer) RETURNS integer[]
    LANGUAGE sql SECURITY DEFINER
    AS $$
    select array_agg(id order by p.name)
      from shop.product p
     where exists (
        select *
          from shop.product_category pc
          left join shop.category c on pc.category_id = c.id
         where pc.product_id = p.id
           and (pc.category_id = acategory_id or c.parent_id = acategory_id)
    )
       and p.is_visible and p.dt_deleted is null;
$$;


ALTER FUNCTION web.get_products(acategory_id integer) OWNER TO shop;

--
-- Name: FUNCTION get_products(acategory_id integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.get_products(acategory_id integer) IS 'Returns product list for category page';


--
-- Name: get_sef_name(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_sef_name(aname character varying) RETURNS character varying
    LANGUAGE sql
    AS $$
    select replace(lower(aname), ' ', '-');
$$;


ALTER FUNCTION web.get_sef_name(aname character varying) OWNER TO shop;

--
-- Name: get_status_name(shop.t_order_status); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_status_name(astatus shop.t_order_status) RETURNS character varying
    LANGUAGE sql IMMUTABLE SECURITY DEFINER
    AS $$
    select case when astatus = 'new' then 'Новый'
                when astatus = 'confirmed' then 'Подтвержден'
                when astatus = 'paid' then 'Оплачен'
                when astatus = 'closed' then 'Закрыт'
                when astatus = 'cancelled' then 'Отменен'
           else '?'
           end;
$$;


ALTER FUNCTION web.get_status_name(astatus shop.t_order_status) OWNER TO shop;

--
-- Name: get_user_info(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.get_user_info(auser_id integer) RETURNS TABLE(name character varying, email character varying, is_admin boolean)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select u.name, u.email, u.is_admin
      from shop.system_user u
     where u.id = auser_id;
$$;


ALTER FUNCTION web.get_user_info(auser_id integer) OWNER TO shop;

--
-- Name: gifts_get(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.gifts_get() RETURNS TABLE(id integer, name text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    return query
    select p.id, p.name
      from shop.product p
     where p.sku like 'gift-%'
     order by p.sku;
end;
$$;


ALTER FUNCTION web.gifts_get() OWNER TO shop;


--
-- Name: infopage_get(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.infopage_get(aurl character varying) RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.code from shop.infopage p where url = aurl;
$$;


ALTER FUNCTION web.infopage_get(aurl character varying) OWNER TO shop;

--
-- Name: infopage_views_inc(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.infopage_views_inc(aurl character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vviews integer;
begin
    update shop.infopage
       set views = views + 1
     where url = aurl
    returning views into vviews;

    return vviews;
end;
$$;


ALTER FUNCTION web.infopage_views_inc(aurl character varying) OWNER TO shop;

--
-- Name: infopages_list(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.infopages_list() RETURNS TABLE(url character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.url from shop.infopage p;
$$;


ALTER FUNCTION web.infopages_list() OWNER TO shop;

--
-- Name: is_ip_blacklisted(inet); Type: FUNCTION; Schema: web; Owner: migrator
--

CREATE FUNCTION web.is_ip_blacklisted(aip inet) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select exists (select * from shop.black_list l where l.ip >>= aip);
$$;


ALTER FUNCTION web.is_ip_blacklisted(aip inet) OWNER TO migrator;

--
-- Name: is_module_enabled(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.is_module_enabled(amodule character varying) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select exists(select *
                    from module.config c
                   where c.module = amodule and c.is_enabled);
$$;


ALTER FUNCTION web.is_module_enabled(amodule character varying) OWNER TO shop;

--
-- Name: FUNCTION is_module_enabled(amodule character varying); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.is_module_enabled(amodule character varying) IS 'Return true if module is enabled, if module is disabled or absent returns false';


--
-- Name: login(character varying, character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.login(alogin character varying, apassword character varying, OUT oid integer, OUT oname character varying, OUT oemail character varying, OUT ois_admin boolean, OUT oerror character varying) RETURNS record
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    select id, name, email, is_admin
      into oid, oname, oemail, ois_admin
      from shop.system_user
     where login = alogin
       and password = apassword;

    if not found then
        select -1, 'Пользователь не найден'
          into oid, oerror;
    end if;
end;
$$;


ALTER FUNCTION web.login(alogin character varying, apassword character varying, OUT oid integer, OUT oname character varying, OUT oemail character varying, OUT ois_admin boolean, OUT oerror character varying) OWNER TO shop;

--
-- Name: new_customer(); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.new_customer(OUT oid integer, OUT osecret character) RETURNS record
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    insert into shop.customer default values
    returning id, secret into oid, osecret;
end;
$$;


ALTER FUNCTION web.new_customer(OUT oid integer, OUT osecret character) OWNER TO shop;

--
-- Name: orders_by_ip_get(inet, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.orders_by_ip_get(aip inet, aexclude_id integer) RETURNS TABLE(id integer, dt_create timestamp with time zone, phone character varying, email character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
    return query
    select o.id, o.dt_create, o.phone, o.email
      from shop.customer_order o
     where o.ip = aip and o.id != aexclude_id
    order by o.dt_create;
end;
$$;


ALTER FUNCTION web.orders_by_ip_get(aip inet, aexclude_id integer) OWNER TO shop;

--
-- Name: FUNCTION orders_by_ip_get(aip inet, aexclude_id integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.orders_by_ip_get(aip inet, aexclude_id integer) IS 'Returns the list of all order made from a given IP, excluding order with id = aexclude_id';


--
-- Name: orders_export(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.orders_export(pdays_limit integer DEFAULT 1) RETURNS SETOF json
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    -- Exports orders for pdays_limit days or all orders if pdays_limit is null
    --
    return query
    select row_to_json(t)
      from (
        select o.id as order_id,
               o.dt_create,
               o.amount,
               o.email,
               o.phone,
               o.address,
               o.delivery_cost,
               o.delivery_name,
               o.delivery_code,
               o.name, o.last_name, o.patronymic_name,
               o.ip as user_ip,
               json_agg((select x from (select i.id, p.name, i.price, i.quantity, i.amount order by i.id) x)) as items
          from shop.customer_order o
          join shop.order_item i on i.order_id = o.id
          join shop.product p on p.id = i.product_id
         where o.dt_create >= current_timestamp - (interval '1 day') * (pdays_limit) or pdays_limit is null
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
    ) t;
end;
$$;



ALTER FUNCTION web.orders_export(pdays_limit integer) OWNER TO shop;

--
-- Name: product_relations_get(integer, character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.product_relations_get(aparent_id integer, arelation character varying) RETURNS TABLE(id integer, parent_id integer, child_id integer, relation character varying, relation_name character varying, child_name character varying, child_sku character varying, child_price numeric)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select pr.id,
           pr.parent_id as parent_id,
           pr.child_id as child_id,
           r.mnemonic as relation,
           r.name as relation_name,
           p.name as child_name,
           p.sku as child_sku,
           p.price as child_price
      from shop.product_relation pr
      join shop.relation r on r.id = pr.relation_id
      join shop.product p on p.id = pr.child_id
     where r.mnemonic = arelation
     order by pr.id;
$$;


ALTER FUNCTION web.product_relations_get(aparent_id integer, arelation character varying) OWNER TO shop;

--
-- Name: product_accessories_get(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.product_accessories_get(aproduct_id integer) RETURNS integer[]
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select array_agg(child_id) from web.product_relations_get(aproduct_id, 'accessory');
$$;


ALTER FUNCTION web.product_accessories_get(aproduct_id integer) OWNER TO shop;

--
-- Name: product_by_sef_get(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.product_by_sef_get(asef character varying) RETURNS integer
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select p.id from shop.product p where p.sef_name = asef;
$$;


ALTER FUNCTION web.product_by_sef_get(asef character varying) OWNER TO shop;

--
-- Name: FUNCTION product_by_sef_get(asef character varying); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.product_by_sef_get(asef character varying) IS 'Returns product ID by sef name if exists';


--
-- Name: product_list_get(integer[], boolean); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.product_list_get(aids integer[], aforse_visibility boolean DEFAULT false) RETURNS TABLE(id integer, sku character varying, name character varying, url character varying, manufacturer_id integer, price numeric, previous_price numeric, diagram character varying, lookup_no smallint, vehicle_id character varying, note text, description text, short_description text, image text, image_thumb text, available integer, card_attributes json, images json, images_thumb json, category_id integer)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $_$
begin
    return query
    select p.id,
           p.sku::varchar,
           p.name::varchar,
           web.product_url_get(p.id),
           p.manufacturer_id,
           p.price,
           p.previous_price,
           (select d.diagram from shop.product_diagram d where product_id = p.id limit 1),
           (select d.lookup_no from shop.product_diagram d where product_id = p.id limit 1),
           substring(p.sku from '-(.+)$')::varchar,
           web.get_attribute_value(p.id, web.get_attribute_id('Note')),
           web.get_product_description(p.id),
           web.get_product_description(p.id, 100),
           web.get_product_main_image(p.id),
           web.get_product_main_image(p.id, 200),
           p.available,
           coalesce((select json_agg(f.*) from web.get_product_card_attributes(p.id) f), '[]'::json),
           coalesce((select json_agg(f.*) from web.get_product_images(p.id) f), '[]'::json),
           coalesce((select json_agg(f.*) from web.get_product_images(p.id, 200) f), '[]'::json),
           web.get_product_main_category(p.id)
      from shop.product p
      /* we use WITH ORDINALITY construction to preserve elements positions in array */
      join (select * from unnest(aids) with ordinality as u(id, ordinality)) ids using (id)
     where (p.is_visible or aforse_visibility)
       and p.dt_deleted is null
      order by ids.ordinality, ids.id;
end;
$_$;


ALTER FUNCTION web.product_list_get(aids integer[], aforse_visibility boolean) OWNER TO shop;

--
-- Name: product_path_get(integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.product_path_get(aid integer) RETURNS integer[]
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    with recursive r as (
        select c.id, c.parent_id, 0 as level
          from shop.product_category pc
          join shop.category c on c.id = pc.category_id
         where product_id = aid
        union
        select c.id, c.parent_id, level + 1
          from shop.category c
          join r on r.parent_id = c.id
    ) select array_agg(id order by level desc) from r;
$$;


ALTER FUNCTION web.product_path_get(aid integer) OWNER TO shop;


--
-- Name: product_search(integer, integer, integer, character varying, character varying, character varying, integer, integer, json, boolean); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.product_search(amanufacturer_id integer, acategory_id integer, agroup_id integer, aname character varying, aorder_col character varying, aorder_dir character varying, aproducts_on_page integer, apage integer, afilters json DEFAULT NULL::json, ainclude_subcategories boolean DEFAULT true) RETURNS integer[]
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
declare
    vsql text; vwhere text := '';
    vresult integer[]; rfilter record; vcompare text;
begin
    raise notice 'filters: %', afilters;
    if aorder_col not in ('price', 'name', 'sort_order') or aorder_dir not in ('asc', 'desc') then
        return array[]::integer[];
    end if;

    vsql := $sql$
    select array_agg(t.id order by {order_col} {order_dir})
      from (
        select p.id, p.{order_col}
          from shop.product p
         where p.is_visible and p.dt_deleted is null
        {where}
        order by p.{order_col} {order_dir}
        limit {limit} offset {offset}
    ) t;
    $sql$;

    if amanufacturer_id is not null then
        vwhere := vwhere || ' and p.manufacturer_id = $1';
    end if;
    if acategory_id is not null then
        if ainclude_subcategories then
            vwhere := vwhere || ' and array[$2] <@ p.path';
        else
            vwhere := vwhere || ' and exists (select * from shop.product_category pc where pc.category_id = $2 and pc.product_id = p.id)';
        end if;
    end if;
    if aname is not null then
        vwhere := vwhere || $sql$ and (lower(p.name) like '%' || lower($3) || '%' or p.sku = lower($3)) $sql$;
    end if;
    if agroup_id is not null then
        vwhere := vwhere || ' and exists (select * from shop.products_in_group pg where pg.product_id = p.id and pg.group_id = $4)';
    end if;
    for rfilter in (
        with unpacked_values as (
            select unnest(string_to_array(r.value, ',')) as value, r.attribute_id, f.id as filter_id
              from json_to_recordset(afilters) as r(attribute_id integer, value text)
              left join shop.filter f on f.attribute_id = r.attribute_id
             where r.value != ''
        )
        select uv.attribute_id, format('v.attribute_id = %L and ', uv.attribute_id) ||
               '(' || string_agg(coalesce(fv.expression, format('v.value = any(string_to_array(%L, %L))', uv.value, ',')) , ' or ') || ')' as expression
          from unpacked_values uv
          left join shop.filter_value fv
            on fv.filter_id = uv.filter_id
           and fv.distinct_value = uv.value
        group by uv.attribute_id
    ) loop
        vwhere := vwhere || format(' and exists (select * from shop.attribute_value v where %s and v.product_id = p.id)', rfilter.expression);
    end loop;

    vsql := replace(vsql, '{where}', vwhere);
    vsql := replace(vsql, '{order_dir}', aorder_dir);
    vsql := replace(vsql, '{order_col}', aorder_col);
    vsql := replace(vsql, '{limit}', aproducts_on_page::text);
    vsql := replace(vsql, '{offset}', (aproducts_on_page * (apage - 1))::text);
    raise notice '%', vsql;
    execute vsql into vresult using amanufacturer_id, acategory_id, aname, agroup_id;
    raise notice '%', vresult;
    return vresult;
end;
$_$;


ALTER FUNCTION web.product_search(amanufacturer_id integer, acategory_id integer, agroup_id integer, aname character varying, aorder_col character varying, aorder_dir character varying, aproducts_on_page integer, apage integer, afilters json, ainclude_subcategories boolean) OWNER TO shop;

--
-- Name: FUNCTION product_search(amanufacturer_id integer, acategory_id integer, agroup_id integer, aname character varying, aorder_col character varying, aorder_dir character varying, aproducts_on_page integer, apage integer, afilters json, ainclude_subcategories boolean); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.product_search(amanufacturer_id integer, acategory_id integer, agroup_id integer, aname character varying, aorder_col character varying, aorder_dir character varying, aproducts_on_page integer, apage integer, afilters json, ainclude_subcategories boolean) IS 'Search product, used in ajax queries';


--
-- Name: remove_product_from_cart(character, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.remove_product_from_cart(acustomer_secret character, aproduct_id integer, OUT oid integer, OUT oquantity integer, OUT oamount numeric) RETURNS record
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vcustomer_id integer := shop.get_customer_id(acustomer_secret);
    vid integer;
begin
    delete
      from shop.cart
     where customer_id = vcustomer_id
       and product_id = aproduct_id
    returning id into vid;

    select vid, f.oquantity, f.oamount
      into oid, oquantity, oamount
      from web.get_cart_total(acustomer_secret) f;
end;
$$;


ALTER FUNCTION web.remove_product_from_cart(acustomer_secret character, aproduct_id integer, OUT oid integer, OUT oquantity integer, OUT oamount numeric) OWNER TO shop;

--
-- Name: search(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.search(asearch character varying) RETURNS TABLE(product_id integer, name character varying, sku character varying, price numeric)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
begin
    return query
    select p.id, p.name::varchar, p.sku::varchar, p.price
      from shop.product p
     where (p.sku = asearch or asearch is null)
        or (lower(p.name) like '%' || lower(asearch) || '%')
    order by p.id limit 20;
end;
$$;


ALTER FUNCTION web.search(asearch character varying) OWNER TO shop;

--
-- Name: FUNCTION search(asearch character varying); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.search(asearch character varying) IS 'Search';


--
-- Name: sef_from_text(text); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.sef_from_text(atext text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
    vresult text;
begin
    vresult := regexp_replace(web.transliteration(lower(atext)), '\s+', '-', 'g');

    return regexp_replace(vresult, '[^a-z0-9-]+', '', 'g');
end;
$$;


ALTER FUNCTION web.sef_from_text(atext text) OWNER TO shop;

--
-- Name: set_cart_item(character, integer, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.set_cart_item(acustomer_key character, aproduct_id integer, aquantity integer) RETURNS TABLE(id integer, product_id integer, quantity smallint, price numeric, amount numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vcustomer_id integer := shop.get_customer_id(acustomer_key);
    vcart_id integer;
begin
    update shop.cart c
       set quantity = aquantity
     where c.customer_id = vcustomer_id
       and c.product_id = aproduct_id
    returning c.id into vcart_id;

    return query
    select c.id, c.product_id, c.quantity, p.price, round(c.quantity * p.price, 2)
      from shop.cart c
      join shop.product p
        on p.id = c.product_id
     where c.id = vcart_id
    union all
    select -1, null, oquantity, null, oamount from web.get_cart_total(acustomer_key);
end;
$$;


ALTER FUNCTION web.set_cart_item(acustomer_key character, aproduct_id integer, aquantity integer) OWNER TO shop;

--
-- Name: FUNCTION set_cart_item(acustomer_key character, aproduct_id integer, aquantity integer); Type: COMMENT; Schema: web; Owner: shop
--

COMMENT ON FUNCTION web.set_cart_item(acustomer_key character, aproduct_id integer, aquantity integer) IS 'Set product quantity in cart to <aquantity>';


--
-- Name: set_payment_status(character varying, character varying, shop.t_payment_status); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.set_payment_status(aservice character varying, aexternal_id character varying, astatus shop.t_payment_status) RETURNS shop.t_payment_status
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vstatus shop.t_payment_status;
    vorder_id integer;
begin
    update shop.payment
       set status = astatus,
           dt_processed = now()
     where service = aservice
       and external_id = aexternal_id
       and status = 'new'
    returning status, order_id into vstatus, vorder_id;

    update shop.customer_order
       set status = 'paid'
     where id = vorder_id;

    return vstatus;
end;
$$;


ALTER FUNCTION web.set_payment_status(aservice character varying, aexternal_id character varying, astatus shop.t_payment_status) OWNER TO shop;

--
-- Name: snippets_get(character varying); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.snippets_get(apos character varying DEFAULT NULL::character varying) RETURNS TABLE(id integer, name character varying, pos character varying, priority integer, data text, show_in_admin boolean)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    select s.id, s.name, s.pos, s.priority, s.data, s.show_in_admin
      from shop.snippet s
     where (s.pos = apos or apos is null)
       and s.is_enabled
     order by priority;
$$;


ALTER FUNCTION web.snippets_get(apos character varying) OWNER TO shop;

--
-- Name: transliteration(text); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.transliteration(atext text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
    vfrom text[] := array['ъ', 'ь', 'щ', 'ё', 'ж', 'ц', 'ч', 'ш', 'ы', 'ю', 'я', 'а', 'б', 'в', 'г', 'д', 'е', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'э']::text[];
    vto text[] := array['', '', 'sch', 'yo', 'zh', 'ts', 'ch', 'sh', 'yi', 'yu', 'ya', 'a', 'b', 'v', 'g', 'd', 'e', 'z', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'h', 'e']::text[];
    vresult text;
begin
   select string_agg(coalesce(vto[array_position(vfrom, c)],c),'')
     into vresult
     from regexp_split_to_table(atext,'') g(c);
   return vresult;
end;
$$;


ALTER FUNCTION web.transliteration(atext text) OWNER TO shop;

--
-- Name: update_cart_item(character, integer, integer); Type: FUNCTION; Schema: web; Owner: shop
--

CREATE FUNCTION web.update_cart_item(acustomer_key character, aproduct_id integer, aquantity_delta integer) RETURNS TABLE(id integer, product_id integer, quantity smallint, price numeric, amount numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
    vcustomer_id integer := shop.get_customer_id(acustomer_key);
    r record;
begin
    select *
      into r
      from shop.cart c
     where c.customer_id = vcustomer_id
       and c.product_id = aproduct_id
    for update;

    if not found and aquantity_delta > 0 then
        insert into shop.cart (customer_id, product_id, quantity)
        values (vcustomer_id, aproduct_id, aquantity_delta)
        returning * into r;
    elsif aquantity_delta in (-1, 1) and r.quantity + aquantity_delta >= 0 then
        update shop.cart c set quantity = c.quantity + aquantity_delta where c.id = r.id;
    else
        return;
    end if;

    return query
    select c.id, c.product_id, c.quantity, p.price, round(c.quantity * p.price, 2)
      from shop.cart c
      join shop.product p
        on p.id = c.product_id
     where c.id = r.id
    union all
    select -1, null, oquantity, null, oamount from web.get_cart_total(acustomer_key);
end;
$$;


ALTER FUNCTION web.update_cart_item(acustomer_key character, aproduct_id integer, aquantity_delta integer) OWNER TO shop;



ALTER SEQUENCE admin.menu_id_seq OWNED BY admin.menu.id;
ALTER SEQUENCE api.token_id_seq OWNED BY api.token.id;
ALTER SEQUENCE i18n.translation_column_id_seq OWNED BY i18n.translation_column.id;
ALTER SEQUENCE i18n.translation_id_seq OWNED BY i18n.translation.id;
ALTER SEQUENCE module.config_id_seq OWNED BY module.config.id;
ALTER SEQUENCE module.module_category_id_seq OWNED BY module.module_category.id;
ALTER SEQUENCE module.module_product_id_seq OWNED BY module.module_product.id;
ALTER SEQUENCE shop.attribute_category_id_seq OWNED BY shop.attribute_category.id;
ALTER SEQUENCE shop.attribute_id_seq OWNED BY shop.attribute.id;
ALTER SEQUENCE shop.attribute_value_id_seq OWNED BY shop.attribute_value.id;
ALTER SEQUENCE shop.banner_id_seq OWNED BY shop.banner.id;
ALTER SEQUENCE shop.black_list_id_seq OWNED BY shop.black_list.id;
ALTER SEQUENCE shop.cart_id_seq OWNED BY shop.cart.id;
ALTER SEQUENCE shop.category_id_seq OWNED BY shop.category.id;
ALTER SEQUENCE shop.customer_id_seq OWNED BY shop.customer.id;
ALTER SEQUENCE shop.customer_order_id_seq OWNED BY shop.customer_order.id;
ALTER SEQUENCE shop.feedback_id_seq OWNED BY shop.feedback.id;
ALTER SEQUENCE shop.filter_id_seq OWNED BY shop.filter.id;
ALTER SEQUENCE shop.filter_value_id_seq OWNED BY shop.filter_value.id;
ALTER SEQUENCE shop.infopage_id_seq OWNED BY shop.infopage.id;
ALTER SEQUENCE shop.manufacturer_id_seq OWNED BY shop.manufacturer.id;
ALTER SEQUENCE shop.menu_id_seq OWNED BY shop.menu.id;
ALTER SEQUENCE shop.order_item_id_seq OWNED BY shop.order_item.id;
ALTER SEQUENCE shop.payment_id_seq OWNED BY shop.payment.id;
ALTER SEQUENCE shop.payment_method_id_seq OWNED BY shop.payment_method.id;
ALTER SEQUENCE shop.product_category_id_seq OWNED BY shop.product_category.id;
ALTER SEQUENCE shop.product_description_id_seq OWNED BY shop.product_description.id;
ALTER SEQUENCE shop.product_diagram_id_seq OWNED BY shop.product_diagram.id;
ALTER SEQUENCE shop.product_group_id_seq OWNED BY shop.product_group.id;
ALTER SEQUENCE shop.product_id_seq OWNED BY shop.product.id;
ALTER SEQUENCE shop.product_image_id_seq OWNED BY shop.product_image.id;
ALTER SEQUENCE shop.product_option_id_seq OWNED BY shop.product_option.id;
ALTER SEQUENCE shop.product_relation_id_seq OWNED BY shop.product_relation.id;
ALTER SEQUENCE shop.products_in_group_id_seq OWNED BY shop.products_in_group.id;
ALTER SEQUENCE shop.relation_id_seq OWNED BY shop.relation.id;
ALTER SEQUENCE shop.snippet_id_seq OWNED BY shop.snippet.id;
ALTER SEQUENCE shop.system_user_id_seq OWNED BY shop.system_user.id;
ALTER SEQUENCE stat.product_available_history_id_seq OWNED BY stat.product_available_history.id;
ALTER SEQUENCE stat.product_price_history_id_seq OWNED BY stat.product_price_history.id;
ALTER SEQUENCE stat.product_stat_id_seq OWNED BY stat.product_stat.id;

ALTER TABLE ONLY admin.menu ALTER COLUMN id SET DEFAULT nextval('admin.menu_id_seq'::regclass);
ALTER TABLE ONLY api.token ALTER COLUMN id SET DEFAULT nextval('api.token_id_seq'::regclass);
ALTER TABLE ONLY i18n.translation ALTER COLUMN id SET DEFAULT nextval('i18n.translation_id_seq'::regclass);
ALTER TABLE ONLY i18n.translation_column ALTER COLUMN id SET DEFAULT nextval('i18n.translation_column_id_seq'::regclass);
ALTER TABLE ONLY module.config ALTER COLUMN id SET DEFAULT nextval('module.config_id_seq'::regclass);
ALTER TABLE ONLY module.module_category ALTER COLUMN id SET DEFAULT nextval('module.module_category_id_seq'::regclass);
ALTER TABLE ONLY module.module_product ALTER COLUMN id SET DEFAULT nextval('module.module_product_id_seq'::regclass);
ALTER TABLE ONLY shop.attribute ALTER COLUMN id SET DEFAULT nextval('shop.attribute_id_seq'::regclass);
ALTER TABLE ONLY shop.attribute_category ALTER COLUMN id SET DEFAULT nextval('shop.attribute_category_id_seq'::regclass);
ALTER TABLE ONLY shop.attribute_value ALTER COLUMN id SET DEFAULT nextval('shop.attribute_value_id_seq'::regclass);
ALTER TABLE ONLY shop.banner ALTER COLUMN id SET DEFAULT nextval('shop.banner_id_seq'::regclass);
ALTER TABLE ONLY shop.black_list ALTER COLUMN id SET DEFAULT nextval('shop.black_list_id_seq'::regclass);
ALTER TABLE ONLY shop.cart ALTER COLUMN id SET DEFAULT nextval('shop.cart_id_seq'::regclass);
ALTER TABLE ONLY shop.category ALTER COLUMN id SET DEFAULT nextval('shop.category_id_seq'::regclass);
ALTER TABLE ONLY shop.customer ALTER COLUMN id SET DEFAULT nextval('shop.customer_id_seq'::regclass);
ALTER TABLE ONLY shop.customer_order ALTER COLUMN id SET DEFAULT nextval('shop.customer_order_id_seq'::regclass);
ALTER TABLE ONLY shop.feedback ALTER COLUMN id SET DEFAULT nextval('shop.feedback_id_seq'::regclass);
ALTER TABLE ONLY shop.filter ALTER COLUMN id SET DEFAULT nextval('shop.filter_id_seq'::regclass);
ALTER TABLE ONLY shop.filter_value ALTER COLUMN id SET DEFAULT nextval('shop.filter_value_id_seq'::regclass);
ALTER TABLE ONLY shop.infopage ALTER COLUMN id SET DEFAULT nextval('shop.infopage_id_seq'::regclass);
ALTER TABLE ONLY shop.manufacturer ALTER COLUMN id SET DEFAULT nextval('shop.manufacturer_id_seq'::regclass);
ALTER TABLE ONLY shop.menu ALTER COLUMN id SET DEFAULT nextval('shop.menu_id_seq'::regclass);
ALTER TABLE ONLY shop.order_item ALTER COLUMN id SET DEFAULT nextval('shop.order_item_id_seq'::regclass);
ALTER TABLE ONLY shop.payment ALTER COLUMN id SET DEFAULT nextval('shop.payment_id_seq'::regclass);
ALTER TABLE ONLY shop.payment_method ALTER COLUMN id SET DEFAULT nextval('shop.payment_method_id_seq'::regclass);
ALTER TABLE ONLY shop.product ALTER COLUMN id SET DEFAULT nextval('shop.product_id_seq'::regclass);
ALTER TABLE ONLY shop.product_category ALTER COLUMN id SET DEFAULT nextval('shop.product_category_id_seq'::regclass);
ALTER TABLE ONLY shop.product_description ALTER COLUMN id SET DEFAULT nextval('shop.product_description_id_seq'::regclass);
ALTER TABLE ONLY shop.product_diagram ALTER COLUMN id SET DEFAULT nextval('shop.product_diagram_id_seq'::regclass);
ALTER TABLE ONLY shop.product_group ALTER COLUMN id SET DEFAULT nextval('shop.product_group_id_seq'::regclass);
ALTER TABLE ONLY shop.product_image ALTER COLUMN id SET DEFAULT nextval('shop.product_image_id_seq'::regclass);
ALTER TABLE ONLY shop.product_option ALTER COLUMN id SET DEFAULT nextval('shop.product_option_id_seq'::regclass);
ALTER TABLE ONLY shop.product_relation ALTER COLUMN id SET DEFAULT nextval('shop.product_relation_id_seq'::regclass);
ALTER TABLE ONLY shop.products_in_group ALTER COLUMN id SET DEFAULT nextval('shop.products_in_group_id_seq'::regclass);
ALTER TABLE ONLY shop.relation ALTER COLUMN id SET DEFAULT nextval('shop.relation_id_seq'::regclass);
ALTER TABLE ONLY shop.snippet ALTER COLUMN id SET DEFAULT nextval('shop.snippet_id_seq'::regclass);
ALTER TABLE ONLY shop.system_user ALTER COLUMN id SET DEFAULT nextval('shop.system_user_id_seq'::regclass);
ALTER TABLE ONLY stat.product_available_history ALTER COLUMN id SET DEFAULT nextval('stat.product_available_history_id_seq'::regclass);
ALTER TABLE ONLY stat.product_price_history ALTER COLUMN id SET DEFAULT nextval('stat.product_price_history_id_seq'::regclass);
ALTER TABLE ONLY stat.product_stat ALTER COLUMN id SET DEFAULT nextval('stat.product_stat_id_seq'::regclass);

ALTER TABLE ONLY admin.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);

ALTER TABLE ONLY api.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (id);

ALTER TABLE ONLY api.token
    ADD CONSTRAINT token_token_key UNIQUE (token);

ALTER TABLE ONLY i18n.translation_column
    ADD CONSTRAINT translation_column_pkey PRIMARY KEY (id);

ALTER TABLE ONLY i18n.translation_manual
    ADD CONSTRAINT translation_manual_pkey PRIMARY KEY (id);

ALTER TABLE ONLY i18n.translation
    ADD CONSTRAINT translation_pkey PRIMARY KEY (id);

ALTER TABLE ONLY module.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (id);

ALTER TABLE ONLY module.module_category
    ADD CONSTRAINT module_category_pkey PRIMARY KEY (id);

ALTER TABLE ONLY module.module_product
    ADD CONSTRAINT module_product_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.attribute_category
    ADD CONSTRAINT attribute_category_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.attribute
    ADD CONSTRAINT attribute_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.attribute_value
    ADD CONSTRAINT attribute_value_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.banner
    ADD CONSTRAINT banner_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.black_list
    ADD CONSTRAINT black_list_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (parameter);

ALTER TABLE ONLY shop.customer_order
    ADD CONSTRAINT customer_order_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.customer
    ADD CONSTRAINT customer_secret_key UNIQUE (secret);

ALTER TABLE ONLY shop.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.filter
    ADD CONSTRAINT filter_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.filter_value
    ADD CONSTRAINT filter_value_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.infopage
    ADD CONSTRAINT infopage_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.payment_method
    ADD CONSTRAINT payment_method_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product_description
    ADD CONSTRAINT product_description_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product_diagram
    ADD CONSTRAINT product_diagram_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product_group
    ADD CONSTRAINT product_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product_image
    ADD CONSTRAINT product_image_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.product_relation
    ADD CONSTRAINT product_relation_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.products_in_group
    ADD CONSTRAINT products_in_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.relation
    ADD CONSTRAINT relation_mnemonic_key UNIQUE (mnemonic);

ALTER TABLE ONLY shop.relation
    ADD CONSTRAINT relation_name_key UNIQUE (name);

ALTER TABLE ONLY shop.relation
    ADD CONSTRAINT relation_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.snippet
    ADD CONSTRAINT snippet_pkey PRIMARY KEY (id);

ALTER TABLE ONLY shop.system_user
    ADD CONSTRAINT system_user_pkey PRIMARY KEY (id);

ALTER TABLE ONLY stat.product_available_history
    ADD CONSTRAINT product_available_history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY stat.product_price_history
    ADD CONSTRAINT product_price_history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY stat.product_stat
    ADD CONSTRAINT product_stat_pkey PRIMARY KEY (id);


CREATE UNIQUE INDEX translation_column_table_name_original_column_idx ON i18n.translation_column USING btree (table_name, original_column);


--
-- Name: translation_lower_idx; Type: INDEX; Schema: i18n; Owner: shop
--

CREATE UNIQUE INDEX translation_lower_idx ON i18n.translation USING btree (lower(original));


--
-- Name: translation_lower_idx1; Type: INDEX; Schema: i18n; Owner: shop
--

CREATE UNIQUE INDEX translation_lower_idx1 ON i18n.translation USING btree (lower(original));


--
-- Name: config_module_idx; Type: INDEX; Schema: module; Owner: shop
--

CREATE UNIQUE INDEX config_module_idx ON module.config USING btree (module);


--
-- Name: module_category_module_category_id_idx; Type: INDEX; Schema: module; Owner: shop
--

CREATE UNIQUE INDEX module_category_module_category_id_idx ON module.module_category USING btree (module, category_id);


--
-- Name: module_product_module_product_id_idx; Type: INDEX; Schema: module; Owner: shop
--

CREATE UNIQUE INDEX module_product_module_product_id_idx ON module.module_product USING btree (module, product_id);


--
-- Name: attribute_category_name_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX attribute_category_name_idx ON shop.attribute_category USING btree (name);


--
-- Name: attribute_name_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX attribute_name_idx ON shop.attribute USING btree (attribute_category_id, name);


--
-- Name: attribute_value_product_id_attribute_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX attribute_value_product_id_attribute_id_idx ON shop.attribute_value USING btree (product_id, attribute_id);


--
-- Name: black_list_ip_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX black_list_ip_idx ON shop.black_list USING btree (ip);


--
-- Name: cart_customer_id_product_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX cart_customer_id_product_id_idx ON shop.cart USING btree (customer_id, product_id);


--
-- Name: category_lower_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX category_lower_idx ON shop.category USING btree (lower(name_en));


--
-- Name: category_name_parent_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX category_name_parent_id_idx ON shop.category USING btree (name, parent_id);


--
-- Name: category_parent_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX category_parent_id_idx ON shop.category USING btree (parent_id);


--
-- Name: category_sef_name_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX category_sef_name_idx ON shop.category USING btree (sef_name);


--
-- Name: config_parameter_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX config_parameter_idx ON shop.config USING btree (parameter);


--
-- Name: customer_order_customer_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX customer_order_customer_id_idx ON shop.customer_order USING btree (customer_id);


--
-- Name: filter_attribute_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX filter_attribute_id_idx ON shop.filter USING btree (attribute_id);


--
-- Name: filter_value_filter_id_distinct_value_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX filter_value_filter_id_distinct_value_idx ON shop.filter_value USING btree (filter_id, distinct_value);


--
-- Name: infopage_url_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX infopage_url_idx ON shop.infopage USING btree (url);


--
-- Name: manufacturer_name_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX manufacturer_name_idx ON shop.manufacturer USING btree (name);


--
-- Name: order_item_order_id_product_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX order_item_order_id_product_id_idx ON shop.order_item USING btree (order_id, product_id);


--
-- Name: payment_method_code; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX payment_method_code ON shop.payment_method USING btree (code);


--
-- Name: payment_method_name; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX payment_method_name ON shop.payment_method USING btree (name);


--
-- Name: payment_service_external_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX payment_service_external_id_idx ON shop.payment USING btree (service, external_id);


--
-- Name: product_category_category_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX product_category_category_id_idx ON shop.product_category USING btree (category_id);


--
-- Name: product_category_product_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX product_category_product_id_idx ON shop.product_category USING btree (product_id);


--
-- Name: product_category_product_id_idx1; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_category_product_id_idx1 ON shop.product_category USING btree (product_id);


--
-- Name: product_description_product_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_description_product_id_idx ON shop.product_description USING btree (product_id);


--
-- Name: product_diagram_product_id_diagram_lookup_no_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_diagram_product_id_diagram_lookup_no_idx ON shop.product_diagram USING btree (product_id, diagram, lookup_no);


--
-- Name: product_diagram_product_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX product_diagram_product_id_idx ON shop.product_diagram USING btree (product_id);


--
-- Name: product_group_mnemonic_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_group_mnemonic_idx ON shop.product_group USING btree (mnemonic);


--
-- Name: product_image_product_id_priority_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_image_product_id_priority_idx ON shop.product_image USING btree (product_id, priority);


--
-- Name: product_lower_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX product_lower_idx ON shop.product USING btree (lower(name) varchar_pattern_ops);


--
-- Name: product_option_product_id_value_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_option_product_id_value_idx ON shop.product_option USING btree (product_id, value);


--
-- Name: product_path_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX product_path_idx ON shop.product USING gin (path);


--
-- Name: product_relation_parent_id_child_id_relation_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_relation_parent_id_child_id_relation_id_idx ON shop.product_relation USING btree (parent_id, child_id, relation_id);


--
-- Name: product_sef_name_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE INDEX product_sef_name_idx ON shop.product USING btree (sef_name varchar_pattern_ops);


--
-- Name: product_sku_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX product_sku_idx ON shop.product USING btree (sku);


--
-- Name: products_in_group_product_id_group_id_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX products_in_group_product_id_group_id_idx ON shop.products_in_group USING btree (product_id, group_id);


--
-- Name: system_user_lower_idx; Type: INDEX; Schema: shop; Owner: shop
--

CREATE UNIQUE INDEX system_user_lower_idx ON shop.system_user USING btree (lower((login)::text));


--
-- Name: product_available_history_product_id_dt_from_idx; Type: INDEX; Schema: stat; Owner: shop
--

CREATE UNIQUE INDEX product_available_history_product_id_dt_from_idx ON stat.product_available_history USING btree (product_id, dt_from);


--
-- Name: product_price_history_product_id_dt_from_idx; Type: INDEX; Schema: stat; Owner: shop
--

CREATE UNIQUE INDEX product_price_history_product_id_dt_from_idx ON stat.product_price_history USING btree (product_id, dt_from);


--
-- Name: product_stat_dt_product_id_idx; Type: INDEX; Schema: stat; Owner: shop
--

CREATE UNIQUE INDEX product_stat_dt_product_id_idx ON stat.product_stat USING btree (dt, product_id);

CREATE TRIGGER tau_category AFTER UPDATE OF parent_id ON shop.category FOR EACH ROW EXECUTE PROCEDURE shop.tau_category();


--
-- Name: product tbu_product; Type: TRIGGER; Schema: shop; Owner: shop
--

CREATE TRIGGER tbu_product BEFORE UPDATE ON shop.product FOR EACH ROW EXECUTE PROCEDURE shop.tbu_product();


--
-- Name: product ti_product; Type: TRIGGER; Schema: shop; Owner: shop
--

CREATE TRIGGER ti_product BEFORE INSERT ON shop.product FOR EACH ROW EXECUTE PROCEDURE shop.ti_product();


--
-- Name: product ti_product_history; Type: TRIGGER; Schema: shop; Owner: shop
--

CREATE TRIGGER ti_product_history AFTER INSERT ON shop.product FOR EACH ROW EXECUTE PROCEDURE shop.ti_product_history();


--
-- Name: product_category tidu_product_category; Type: TRIGGER; Schema: shop; Owner: shop
--

CREATE TRIGGER tidu_product_category AFTER INSERT OR DELETE OR UPDATE ON shop.product_category FOR EACH ROW EXECUTE PROCEDURE shop.tidu_product_category();


--
-- Name: product tu_product_available; Type: TRIGGER; Schema: shop; Owner: shop
--

CREATE TRIGGER tu_product_available AFTER UPDATE OF available ON shop.product FOR EACH ROW EXECUTE PROCEDURE shop.tu_product_available();


--
-- Name: product tu_product_name; Type: TRIGGER; Schema: shop; Owner: shop
--

CREATE TRIGGER tu_product_name BEFORE UPDATE OF name ON shop.product FOR EACH ROW WHEN ((new.name IS DISTINCT FROM old.name)) EXECUTE PROCEDURE shop.tu_product_name();


--
-- Name: product tu_product_price; Type: TRIGGER; Schema: shop; Owner: shop
--

CREATE TRIGGER tu_product_price AFTER UPDATE OF price ON shop.product FOR EACH ROW EXECUTE PROCEDURE shop.tu_product_price();


--
-- Name: menu menu_parent_id_fkey; Type: FK CONSTRAINT; Schema: admin; Owner: shop
--

ALTER TABLE ONLY admin.menu
    ADD CONSTRAINT menu_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES admin.menu(id);


--
-- Name: module_category module_category_category_id_fkey; Type: FK CONSTRAINT; Schema: module; Owner: shop
--

ALTER TABLE ONLY module.module_category
    ADD CONSTRAINT module_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES shop.category(id) ON DELETE CASCADE;


--
-- Name: module_product module_product_product_id_fkey; Type: FK CONSTRAINT; Schema: module; Owner: shop
--

ALTER TABLE ONLY module.module_product
    ADD CONSTRAINT module_product_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id) ON DELETE CASCADE;


--
-- Name: attribute attribute_attribute_category_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.attribute
    ADD CONSTRAINT attribute_attribute_category_id_fkey FOREIGN KEY (attribute_category_id) REFERENCES shop.attribute_category(id);


--
-- Name: attribute_value attribute_value_attribute_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.attribute_value
    ADD CONSTRAINT attribute_value_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES shop.attribute(id);


--
-- Name: attribute_value attribute_value_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.attribute_value
    ADD CONSTRAINT attribute_value_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: cart cart_customer_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES shop.customer(id);


--
-- Name: cart cart_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.cart
    ADD CONSTRAINT cart_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: category category_parent_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.category
    ADD CONSTRAINT category_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES shop.category(id);


--
-- Name: customer_order customer_order_customer_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.customer_order
    ADD CONSTRAINT customer_order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES shop.customer(id);


--
-- Name: customer_order customer_order_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.customer_order
    ADD CONSTRAINT customer_order_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES shop.payment_method(id);


--
-- Name: filter filter_attribute_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.filter
    ADD CONSTRAINT filter_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES shop.attribute(id);


--
-- Name: filter_value filter_value_filter_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.filter_value
    ADD CONSTRAINT filter_value_filter_id_fkey FOREIGN KEY (filter_id) REFERENCES shop.filter(id);


--
-- Name: menu menu_parent_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.menu
    ADD CONSTRAINT menu_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES shop.menu(id);


--
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop.customer_order(id);


--
-- Name: order_item order_item_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: payment payment_order_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.payment
    ADD CONSTRAINT payment_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop.customer_order(id);


--
-- Name: product_category product_category_category_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_category
    ADD CONSTRAINT product_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES shop.category(id);


--
-- Name: product_category product_category_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_category
    ADD CONSTRAINT product_category_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: product product_create_user_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product
    ADD CONSTRAINT product_create_user_id_fkey FOREIGN KEY (create_user_id) REFERENCES shop.system_user(id);


--
-- Name: product_description product_description_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_description
    ADD CONSTRAINT product_description_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: product_diagram product_diagram_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_diagram
    ADD CONSTRAINT product_diagram_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: product_image product_image_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_image
    ADD CONSTRAINT product_image_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: product product_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product
    ADD CONSTRAINT product_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES shop.manufacturer(id);


--
-- Name: product_option product_option_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_option
    ADD CONSTRAINT product_option_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: product_relation product_relation_child_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_relation
    ADD CONSTRAINT product_relation_child_id_fkey FOREIGN KEY (child_id) REFERENCES shop.product(id);


--
-- Name: product_relation product_relation_parent_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_relation
    ADD CONSTRAINT product_relation_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES shop.product(id);


--
-- Name: product_relation product_relation_relation_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product_relation
    ADD CONSTRAINT product_relation_relation_id_fkey FOREIGN KEY (relation_id) REFERENCES shop.relation(id);


--
-- Name: product product_update_user_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.product
    ADD CONSTRAINT product_update_user_id_fkey FOREIGN KEY (update_user_id) REFERENCES shop.system_user(id);


--
-- Name: products_in_group products_in_group_group_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.products_in_group
    ADD CONSTRAINT products_in_group_group_id_fkey FOREIGN KEY (group_id) REFERENCES shop.product_group(id);


--
-- Name: products_in_group products_in_group_product_id_fkey; Type: FK CONSTRAINT; Schema: shop; Owner: shop
--

ALTER TABLE ONLY shop.products_in_group
    ADD CONSTRAINT products_in_group_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- Name: product_available_history product_available_history_user_id_fkey; Type: FK CONSTRAINT; Schema: stat; Owner: shop
--

ALTER TABLE ONLY stat.product_available_history
    ADD CONSTRAINT product_available_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES shop.system_user(id);


--
-- Name: product_price_history product_price_history_user_id_fkey; Type: FK CONSTRAINT; Schema: stat; Owner: shop
--

ALTER TABLE ONLY stat.product_price_history
    ADD CONSTRAINT product_price_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES shop.system_user(id);


--
-- Name: product_stat product_stat_product_id_fkey; Type: FK CONSTRAINT; Schema: stat; Owner: shop
--

ALTER TABLE ONLY stat.product_stat
    ADD CONSTRAINT product_stat_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop.product(id);


--
-- PostgreSQL database dump complete
--
--
-- Name: get_menu_json(); Type: FUNCTION; Schema: web; Owner: shop
--

create or replace
function web.get_menu_json() returns json as $$
    select coalesce(json_agg(t), '[]'::json) from
    (
        select id, name, 0 depth, sort_order,
               case when c.sef_name is not null then '/category/' || c.sef_name
                    else '/category/' || c.id::text end url,

                (select json_agg(t) from (
                    select cc.id, cc.name, 1 depth,
                    case when cc.sef_name is not null then '/category/' || cc.sef_name
                    else '/category/' || cc.id::text end url
                  from shop.category cc
                 where parent_id = c.id
                   and cc.is_visible order by cc.sort_order) t) childs
          from shop.category c
         where parent_id is null
           and web.has_category_products(c.id)
           and c.is_visible
        group by 1, 2, 3, 4
        order by sort_order
    ) t
$$ language sql security definer stable;


ALTER FUNCTION web.get_menu_json() OWNER TO shop;

INSERT INTO shop.config (parameter, value) VALUES ('Title', 'Test shop');

