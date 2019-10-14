USE SS_3_1_data;

###  задание 1

SELECT
  users.id, users.nickname,
  COUNT(DISTINCT l1.from_user) likes_get,
  COUNT(distinct l2.to_user) likes_sent,
  SUM(IF(l1.from_user = l2.to_user, 1, 0)) cross_like
FROM users
LEFT JOIN likes_user l1 ON users.id = l1.to_user
LEFT JOIN likes_user l2 ON users.id = l2.from_user
GROUP BY users.id;

###  задание 2

SELECT
  from_user,
  SUM(IF(to_user = 23, 1, 0)) to1,
  SUM(IF(to_user = 24, 1, 0)) to2,
  SUM(IF(to_user = 25, 1, 0)) to3
FROM likes_user
GROUP BY from_user
HAVING (to1 = 1 AND to2 = 1 AND to3 = 0);

-- задание 3

-- пользователь не может дважды лайкнуть одну и ту же сущность;
INSERT INTO likes_user (from_user,to_user) VALUES ('24','23');
-- пользователь имеет право отозвать лайк;
SELECT * FROM likes_comment;
DELETE FROM likes_comment WHERE user_id=23 and comment_id=7;
SELECT * FROM likes_comment;
-- необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;
SELECT photo_id,COUNT(likes_photo.user_id) FROM likes_photo WHERE photo_id=9;
SELECT user_id FROM likes_photo WHERE photo_id=9;
-- в будущем могут появиться новые виды сущностей, которые можно лайкать
-- на каждую новую сущность создаются две новые таблиц - одна описвает сущность, вторая для записи лайков



