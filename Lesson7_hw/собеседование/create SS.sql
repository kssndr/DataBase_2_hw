CREATE database if not exists SS
default char set utf8mb4 collate utf8mb4_unicode_ci;

USE SS;
CREATE table `user` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `name` VARCHAR(30) DEFAULT NULL);

CREATE TABLE `likes` (
  from_user int NOT NULL,
  to_user int NOT NULL,
  PRIMARY KEY (from_user, to_user),
  FOREIGN KEY (from_user) REFERENCES user (id),
  FOREIGN KEY (to_user) REFERENCES user (id)
);

INSERT INTO `user` VALUES (1,'A'),(2,'B'),(3,'C'),(4,'D');
INSERT INTO `likes` VALUES (1,2),(1,3),(1,4),(2,3),(2,4),(3,4),(4,1),(4,2),(4,3);

SELECT
  user.id,user.name,
  COUNT(DISTINCT l2.from_user) likes_get,
  COUNT(DISTINCT l1.to_user) likes_sent,
  SUM(IF(l1.to_user = l2.from_user, 1, 0)) cross_like
FROM `user`
LEFT JOIN likes l1 ON user.id = l1.from_user
LEFT JOIN likes l2 ON user.id = l2.to_user
GROUP BY user.id;

SELECT
  from_user,
  SUM(IF(to_user = 1, 1, 0)) to1,
  SUM(IF(to_user = 2, 1, 0)) to2,
  SUM(IF(to_user = 3, 1, 0)) to3
FROM likes
GROUP BY from_user
HAVING (to1 = 1 AND to2 = 1 AND to3 = 0);

select * FROM likes;
INSERT INTO `user` VALUES (5,'E');

CREATE TABLE `photo` (
  `id` int auto_increment,
  `name` VARCHAR(30),
  user_id int not null,
  PRIMARY KEY(id),
  foreign key (user_id) references `user`(id)
);

CREATE table `comment` (
`id` int auto_increment,
`comm` VARCHAR(255),
`user_id` int not null,
`photo_id` int not null unique,
primary key(id),
foreign key (user_id) references `user`(id),
foreign key (photo_id) references `photo`(id)
);

describe likes;

alter table `likes`
add column like_to_photo int,
add column like_to_comment int,
add UNIQUE KEY `user_id` (`user_id`,`like_to_photo`),
add UNIQUE KEY `user_id_2` (`user_id`,`like_to_comment`),
add UNIQUE KEY `user_id_3` (`user_id`,`like_to_user`)
);

describe likes;

drop table likes;


create table `likes` (
user_id int,
like_to_user int,
like_to_photo int,
like_to_comment int,
UNIQUE KEY `user_id` (`user_id`,`like_to_photo`),
UNIQUE KEY `user_id_2` (`user_id`,`like_to_comment`),
UNIQUE KEY `user_id_3` (`user_id`,`like_to_user`)
);
describe likes;

INSERT INTO photo (user_id) VALUES (1), (1), (2);

INSERT INTO comment (comm, user_id, photo_id) VALUES ('comm1', 2, 1);

INSERT INTO likes(user_id, like_to_user) VALUES (1,2),(1,3),(1,4),(2,3),(2,4),(3,4),(4,1),(4,2),(4,3);

INSERT INTO likes (user_id, like_to_photo) VALUES (1, 2), (2, 2), (2, 3), (3, 3);
INSERT INTO likes (user_id, like_to_comment) VALUES (2,1);

SELECT * FROM user;

INSERT INTO likes(user_id, like_to_user) VALUES (5,1),(5,2);

SELECT
  user.id, user.name,
  COUNT(DISTINCT l1.user_id) likes_get,
  COUNT(distinct l2.like_to_user) likes_sent,
  SUM(IF(l1.user_id = l2.like_to_user, 1, 0)) cross_like
FROM `user`
LEFT JOIN likes l1 ON user.id = l1.like_to_user
LEFT JOIN likes l2 ON user.id = l2.user_id
GROUP BY user.id;

SELECT
  user_id,
  SUM(IF(like_to_user = 1, 1, 0)) to1,
  SUM(IF(like_to_user = 2, 1, 0)) to2,
  SUM(IF(like_to_user = 3, 1, 0)) to3
FROM likes
GROUP BY user_id
HAVING (to1 = 1 AND to2 = 1 AND to3 = 0);
