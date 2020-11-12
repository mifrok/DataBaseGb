-- drop database snet2910;
drop database if exists snet2910;
-- create database if not exists snet2910 character set = utf8mb4;
create database snet2910;

use vk;
drop table if exists users;
create table users(
	id serial primary key, -- serial = bigint unsigned not null auto_increment unique
	firstname varchar(50),
	lastname varchar(50) comment 'Фамилия пользователя',
	email varchar(120) unique,
	phone varchar(20) unique,
	birthday date,
	hometown varchar(100),
	gender char(1),
	photo_id bigint unsigned,
	created_at datetime default now(),
	pass char(30)
);

alter table users add index (phone); 
alter table users add index users_firstname_lastname_idx (firstname, lastname); 
ALTER TABLE users CHANGE birtday birthday date NULL;

drop table if exists settings;
create table settings(
	user_id serial primary key,
	can_see ENUM('all', 'friends_of_friends', 'friends', 'nobody'),
	can_comment ENUM('all', 'friends_of_friends', 'friends', 'nobody'),
	can_message ENUM('all', 'friends_of_friends', 'friends', 'nobody'),
	foreign key (user_id) references users(id)
);

drop table if exists messages;
create table messages(
	id serial primary key,
	from_user_id bigint unsigned not null,
	to_user_id bigint unsigned not null,
	message text not null,
	is_read bool default 0,
	created_at datetime default now(),
	foreign key (from_user_id) references users(id),
	foreign key (to_user_id) references users(id)
);

alter table messages add index messages_from_user_id (from_user_id); 
alter table messages add index messages_to_user_id (to_user_id); 

drop table if exists friend_requests;
create table friend_requests(
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	status enum('requested', 'approved', 'unfriended', 'declined'),
	requested_at datetime default now(),
	confirmed_at datetime default current_timestamp on update current_timestamp,
	primary key(initiator_user_id, target_user_id),
	index (initiator_user_id),
	index (target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
);

drop table if exists communities;
create table communities (
	id serial primary key,
	name varchar(150),
	index(name)
);

drop table if exists users_communities;
create table users_communities(
	user_id bigint unsigned not null,
	community_id  bigint unsigned not null,
	primary key(user_id, community_id),
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
);

drop table if exists posts;
create table posts(
	id serial primary key,
	user_id bigint unsigned not null,
	post text,
	attachments json,
	metadata json,
	like_count bigint,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id)
);

drop table if exists comments;
create table comments (
	id serial primary key,
	user_id bigint unsigned not null,
	post_id bigint unsigned not null,
	comment text,
	like_count bigint,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);

drop table if exists photos;
create table photos(
	id serial primary key,
	filename varchar(255),
	user_id bigint unsigned not null,
	description text,
	like_count bigint,
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id)
);

drop table if exists like_to_photo;
create table like_to_photo(
	id serial primary key,
	user_id bigint unsigned not null,
	photo_id bigint unsigned not null,
	foreign key (user_id) references users(id),
	foreign key (photo_id) references posts(id)
);

drop table if exists like_to_post;
create table like_to_post(
	id serial primary key,
	user_id bigint unsigned not null,
	post_id bigint unsigned not null,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);

drop table if exists like_to_comment;
create table like_to_comment(
	id serial primary key,
	user_id bigint unsigned not null,
	comment_id bigint unsigned not null,
	foreign key (user_id) references users(id),
	foreign key (comment_id) references posts(id)
);
