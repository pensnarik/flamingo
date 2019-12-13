\set ON_ERROR_STOP 1

create user shop with password 'shop';
create user web with password 'web';
create user module with password 'module';

create database :database owner shop;

\connect :database
set role shop;

/* Write your SQL code here. You may include scripts from directories "data" and "schema"

   CREATE TABLE test (id serial, value text);

   \i data/public.test.sql
   \i schema/public/tables/test.sql
*/

create schema shop;
create schema web;
create schema admin;
create schema i18n;
create schema module;

grant usage on schema web to web;
grant usage on schema admin to web;
grant usage on schema i18n to web;
grant usage on schema module to module;

\i schema/shop/types/t_order_status.sql
\i schema/shop/types/t_currency.sql
\i schema/shop/types/t_payment_status.sql

\i schema/shop/tables/system_user.sql
\i schema/shop/tables/config.sql
\i schema/shop/tables/category.sql
\i schema/shop/tables/manufacturer.sql
\i schema/shop/tables/product.sql
\i schema/shop/tables/product_category.sql
\i schema/shop/tables/product_description.sql
\i schema/shop/tables/product_image.sql
\i schema/shop/tables/product_option.sql
\i schema/shop/tables/attribute_category.sql
\i schema/shop/tables/attribute.sql
\i schema/shop/tables/attribute_value.sql
\i schema/web/functions/generate_customer_secret.sql
\i schema/shop/tables/customer.sql
\i schema/shop/tables/cart.sql
\i schema/shop/tables/customer_order.sql
\i schema/shop/tables/order_item.sql
\i schema/shop/tables/product_diagram.sql
\i schema/shop/tables/payment.sql
\i schema/shop/tables/feedback.sql
\i schema/shop/tables/menu.sql

\i schema/shop/functions/get_customer_id.sql

\i schema/web/functions/has_category_products.sql
\i schema/web/functions/get_attributes.plpgsql
\i schema/web/functions/get_breadcrumbs.sql
\i schema/web/functions/get_categories.sql
\i schema/web/functions/new_customer.plpgsql
\i schema/web/functions/add_product_to_cart.plpgsql
\i schema/web/functions/get_cart.plpgsql
\i schema/web/functions/get_cart_total.plpgsql
\i schema/web/functions/remove_product_from_cart.plpgsql
\i schema/web/functions/update_cart_item.plpgsql
\i schema/web/functions/create_order.plpgsql
\i schema/web/functions/get_parameter_value.sql
\i schema/web/functions/login.plpgsql
\i schema/web/functions/get_user_info.sql
\i schema/web/functions/get_status_name.sql
\i schema/web/functions/get_product_description.sql
\i schema/web/functions/get_diagram.sql
\i schema/web/functions/get_attribute_id.sql
\i schema/web/functions/get_attribute_value.sql
\i schema/web/functions/get_product_main_image.sql
\i schema/web/functions/get_product_card_attributes.sql
\i schema/web/functions/get_products.sql
\i schema/web/functions/get_product.sql
\i schema/web/functions/get_orders.plpgsql
\i schema/web/functions/get_order.plpgsql
\i schema/web/functions/get_order_items.plpgsql
\i schema/web/functions/create_payment.plpgsql
\i schema/web/functions/set_payment_status.plpgsql
\i schema/web/functions/search.plpgsql
\i schema/web/functions/get_product_images.sql
\i schema/web/functions/get_config.sql
\i schema/web/functions/get_product_main_category.sql
\i schema/web/functions/export.plpgsql
\i schema/web/functions/get_category.sql
\i schema/web/functions/get_menu.sql
\i schema/web/functions/get_feedback.sql

\i schema/admin/functions/get_order.plpgsql
\i schema/admin/functions/get_order_items.plpgsql
\i schema/admin/functions/set_delivery_cost.plpgsql
\i schema/admin/functions/confirm_order.plpgsql
\i schema/admin/functions/set_price.plpgsql
\i schema/admin/functions/set_available.plpgsql
\i schema/admin/functions/get_products.plpgsql

\i schema/i18n/tables/translation.sql
\i schema/i18n/tables/translation_manual.sql
\i schema/i18n/tables/translation_column.sql

\i schema/i18n/functions/add_translation.plpgsql
\i schema/i18n/functions/get_translations.sql
\i schema/i18n/functions/update_translations.plpgsql

\i schema/module/tables/config.sql
\i schema/module/functions/read_config.sql
\i schema/module/functions/write_config.plpgsql

\copy i18n.translation_manual from data/i18n/translation_manual.sql
\copy i18n.translation_column from data/i18n/translation_column.sql
\copy shop.config from data/shop/config.sql
\copy shop.menu from data/shop/menu.sql
-- Next data is not present in repository because it may contain
-- sensitive private data, such as API keys and passwords.
\copy module.config from data/module/config.sql

