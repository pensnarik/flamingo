create table shop.config
(
	parameter 	 varchar(126) primary key,
	value 		 text
);

create unique index on shop.config (parameter);
