IN 실습 where3
SELECT *
FROM users;

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN('brown', 'cony', 'sally');