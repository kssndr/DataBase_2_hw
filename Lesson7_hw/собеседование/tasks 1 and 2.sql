USE SS;

###  задание 1

SELECT
  user.id, user.name,
  COUNT(DISTINCT l1.user_id) likes_get,
  COUNT(distinct l2.like_to_user) likes_sent,
  SUM(IF(l1.user_id = l2.like_to_user, 1, 0)) cross_like
FROM `user`
LEFT JOIN likes l1 ON user.id = l1.like_to_user
LEFT JOIN likes l2 ON user.id = l2.user_id
GROUP BY user.id;

###  задание 2

SELECT
  user_id,
  SUM(IF(like_to_user = 1, 1, 0)) to1,
  SUM(IF(like_to_user = 2, 1, 0)) to2,
  SUM(IF(like_to_user = 3, 1, 0)) to3
FROM likes
GROUP BY user_id
HAVING (to1 = 1 AND to2 = 1 AND to3 = 0);